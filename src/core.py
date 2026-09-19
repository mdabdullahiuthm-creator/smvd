"""
DIVE-G5 core library.

Pure-python + numpy only. No solc, no external MinHash dependency, so it runs
anywhere (including on old Solidity 0.4.x sources that modern solc refuses).

Three jobs:
  1. normalize_solidity  - canonical text for hashing / tokenizing
  2. MinHasher + Union-Find - near-duplicate families (leakage control)
  3. build_contract_graph - function-dependency graph with 4 typed edges
"""

import hashlib
import re
from typing import Dict, List, Tuple

import numpy as np

# --------------------------------------------------------------------------
# 1. Normalization
# --------------------------------------------------------------------------

_BLOCK_COMMENT = re.compile(r"/\*.*?\*/", re.DOTALL)
_LINE_COMMENT = re.compile(r"//[^\n]*")
_STRING_LIT = re.compile(r'"(?:[^"\\]|\\.)*"|\'(?:[^\'\\]|\\.)*\'')
_HEX_LIT = re.compile(r"\b0x[0-9a-fA-F]+\b")
_NUM_LIT = re.compile(r"\b\d+(?:\.\d+)?(?:e\d+)?\b")
_WS = re.compile(r"\s+")


def strip_comments(src: str) -> str:
    src = _BLOCK_COMMENT.sub(" ", src)
    src = _LINE_COMMENT.sub(" ", src)
    return src


def normalize_solidity(src: str) -> str:
    """Canonical form used for duplicate detection.

    Literals are abstracted so that two contracts differing only in a token
    name, an address constant or a supply number collapse to the same text.
    """
    src = strip_comments(src)
    src = _STRING_LIT.sub(' "STR" ', src)
    src = _HEX_LIT.sub(" HEX ", src)
    src = _NUM_LIT.sub(" NUM ", src)
    src = _WS.sub(" ", src)
    return src.strip()


_TOKEN = re.compile(r"[A-Za-z_]\w*|[^\sA-Za-z_0-9]")


def tokenize(src: str) -> List[str]:
    """Solidity-aware token stream (keywords and operators kept atomic)."""
    return _TOKEN.findall(src)


def sha256_of(text: str) -> str:
    return hashlib.sha256(text.encode("utf-8", "ignore")).hexdigest()


# --------------------------------------------------------------------------
# 2. Near-duplicate detection
# --------------------------------------------------------------------------

_MERSENNE = (1 << 61) - 1


def shingles(tokens: List[str], k: int = 5) -> set:
    if len(tokens) < k:
        return {" ".join(tokens)} if tokens else set()
    return {" ".join(tokens[i:i + k]) for i in range(len(tokens) - k + 1)}


class MinHasher:
    """Pure-python MinHash + LSH banding.

    num_perm=128, bands=8, rows=16 gives an S-curve threshold of
    (1/8)^(1/16) ~ 0.878, so every true >=0.90 pair is a candidate.
    Candidates are then confirmed with exact Jaccard, so the banding only
    affects speed, never correctness.
    """

    def __init__(self, num_perm: int = 128, bands: int = 8, seed: int = 42):
        assert num_perm % bands == 0
        self.num_perm = num_perm
        self.bands = bands
        self.rows = num_perm // bands
        rng = np.random.default_rng(seed)
        self.a = rng.integers(1, _MERSENNE, size=num_perm, dtype=np.int64)
        self.b = rng.integers(0, _MERSENNE, size=num_perm, dtype=np.int64)

    def signature(self, shingle_set: set) -> np.ndarray:
        if not shingle_set:
            return np.full(self.num_perm, _MERSENNE, dtype=np.int64)
        hv = np.array(
            [int(hashlib.md5(s.encode()).hexdigest()[:15], 16) for s in shingle_set],
            dtype=np.int64,
        )
        # (a * h + b) mod prime, vectorised over permutations x shingles
        perm = (np.outer(self.a, hv) + self.b[:, None]) % _MERSENNE
        return perm.min(axis=1)

    def band_keys(self, sig: np.ndarray) -> List[str]:
        keys = []
        for i in range(self.bands):
            chunk = sig[i * self.rows:(i + 1) * self.rows]
            keys.append(f"{i}:" + hashlib.md5(chunk.tobytes()).hexdigest())
        return keys


class UnionFind:
    def __init__(self):
        self.parent: Dict[str, str] = {}

    def find(self, x: str) -> str:
        self.parent.setdefault(x, x)
        while self.parent[x] != x:
            self.parent[x] = self.parent[self.parent[x]]
            x = self.parent[x]
        return x

    def union(self, x: str, y: str) -> None:
        rx, ry = self.find(x), self.find(y)
        if rx != ry:
            self.parent[ry] = rx


def jaccard(a: set, b: set) -> float:
    if not a and not b:
        return 1.0
    inter = len(a & b)
    return inter / (len(a) + len(b) - inter)


def assign_families(records: List[dict], threshold: float = 0.90,
                    shingle_k: int = 5, verbose: bool = True) -> Dict[str, str]:
    """records: [{'contract_id':..., 'normalized':...}, ...] -> {id: family_id}

    Exact duplicates merge by SHA-256; near-duplicates by MinHash-LSH
    candidates confirmed with exact Jaccard >= threshold.
    """
    mh = MinHasher()
    uf = UnionFind()
    by_hash: Dict[str, str] = {}
    buckets: Dict[str, List[str]] = {}
    shing: Dict[str, set] = {}

    for rec in records:
        cid = rec["contract_id"]
        uf.find(cid)
        h = sha256_of(rec["normalized"])
        if h in by_hash:
            uf.union(by_hash[h], cid)
        else:
            by_hash[h] = cid
        s = shingles(tokenize(rec["normalized"]), k=shingle_k)
        shing[cid] = s
        for key in mh.band_keys(mh.signature(s)):
            buckets.setdefault(key, []).append(cid)

    checked = set()
    for members in buckets.values():
        if len(members) < 2 or len(members) > 500:  # skip degenerate mega-buckets
            continue
        for i in range(len(members)):
            for j in range(i + 1, len(members)):
                a, b = members[i], members[j]
                pair = (a, b) if a < b else (b, a)
                if pair in checked:
                    continue
                checked.add(pair)
                if jaccard(shing[a], shing[b]) >= threshold:
                    uf.union(a, b)

    fam = {rec["contract_id"]: uf.find(rec["contract_id"]) for rec in records}
    if verbose:
        n_fam = len(set(fam.values()))
        print(f"  {len(records)} contracts -> {n_fam} families "
              f"({len(records) - n_fam} collapsed)")
    return fam


# --------------------------------------------------------------------------
# 3. Function-dependency graph
# --------------------------------------------------------------------------

_FUNC_HEAD = re.compile(
    r"\b(function\s+(\w+)|constructor|fallback|receive|modifier\s+(\w+))\s*\(",
    re.MULTILINE,
)
_STATE_VAR = re.compile(
    r"^\s*(?:uint\d*|int\d*|address|bool|bytes\d*|string|mapping\s*\([^)]*\))"
    r"(?:\s+(?:public|private|internal|constant|immutable))*\s+(\w+)\s*[;=]",
    re.MULTILINE,
)

EXTERNAL_CALL_PATTERNS = [
    r"\.call\s*\{", r"\.call\s*\(", r"\.call\.value", r"\.delegatecall",
    r"\.staticcall", r"\.send\s*\(", r"\.transfer\s*\(",
]
_EXT_CALL = re.compile("|".join(EXTERNAL_CALL_PATTERNS))

EDGE_TYPES = ["internal_call", "external_call", "state_dep", "control_dep"]


def _match_block(src: str, open_idx: int) -> int:
    """Return index just past the '}' matching the '{' at/after open_idx."""
    i = src.find("{", open_idx)
    if i == -1:
        return -1
    depth = 0
    while i < len(src):
        if src[i] == "{":
            depth += 1
        elif src[i] == "}":
            depth -= 1
            if depth == 0:
                return i + 1
        i += 1
    return -1


def extract_functions(src: str) -> List[dict]:
    """Regex + brace matching. Works on every Solidity version, no compiler."""
    clean = strip_comments(src)
    funcs = []
    for m in _FUNC_HEAD.finditer(clean):
        name = m.group(2) or m.group(3) or m.group(1).strip()
        kind = "modifier" if m.group(3) else "function"
        end = _match_block(clean, m.end())
        if end == -1:
            continue
        body = clean[m.start():end]
        funcs.append({
            "name": name,
            "kind": kind,
            "start_char": m.start(),
            "end_char": end,
            "start_line": clean.count("\n", 0, m.start()) + 1,
            "end_line": clean.count("\n", 0, end) + 1,
            "body": body,
        })
    return funcs


def _node_flags(body: str, state_vars: List[str]) -> List[int]:
    has_ext = 1 if _EXT_CALL.search(body) else 0
    has_write = 0
    for v in state_vars:
        if re.search(rf"\b{re.escape(v)}\s*(?:\[[^\]]*\])?\s*(?:=|\+=|-=)", body):
            has_write = 1
            break
    # state write occurring AFTER an external call: the reentrancy signature
    write_after_call = 0
    if has_ext and has_write:
        mcall = _EXT_CALL.search(body)
        tail = body[mcall.end():]
        for v in state_vars:
            if re.search(rf"\b{re.escape(v)}\s*(?:\[[^\]]*\])?\s*(?:=|\+=|-=)", tail):
                write_after_call = 1
                break
    has_modifier = 1 if re.search(r"\bonly\w+|\brequire\s*\(\s*msg\.sender", body) else 0
    has_loop = 1 if re.search(r"\b(for|while)\s*\(", body) else 0
    unchecked_call = 0
    for pat in [r"\.call", r"\.send\s*\(", r"\.delegatecall"]:
        for mm in re.finditer(pat, body):
            window = body[max(0, mm.start() - 90):mm.start()]
            if "require" not in window and "if" not in window and "assert" not in window:
                unchecked_call = 1
                break
    uses_timestamp = 1 if re.search(r"block\.timestamp|\bnow\b", body) else 0
    return [has_ext, has_write, write_after_call, has_modifier,
            has_loop, unchecked_call, uses_timestamp]


NODE_FLAG_NAMES = ["has_external_call", "writes_state", "write_after_call",
                   "has_access_check", "has_loop", "unchecked_call",
                   "uses_timestamp"]


def build_contract_graph(src: str) -> dict:
    """-> {'nodes': [...], 'edges': [[src_i, dst_j, type_idx, order], ...]}"""
    funcs = extract_functions(src)
    state_vars = list(dict.fromkeys(_STATE_VAR.findall(strip_comments(src))))
    names = {f["name"]: i for i, f in enumerate(funcs)}

    nodes = []
    for f in funcs:
        nodes.append({
            "name": f["name"],
            "kind": f["kind"],
            "start_line": f["start_line"],
            "end_line": f["end_line"],
            "flags": _node_flags(f["body"], state_vars),
            "tokens": tokenize(normalize_solidity(f["body"])),
        })

    edges: List[Tuple[int, int, int, float]] = []
    n = len(funcs)
    for i, f in enumerate(funcs):
        body = f["body"]
        span = max(1, len(body))

        # internal_call: f calls g
        for g_name, j in names.items():
            if j == i or len(g_name) < 2:
                continue
            m = re.search(rf"(?<![\w.]){re.escape(g_name)}\s*\(", body)
            if m:
                edges.append((i, j, 0, round(m.start() / span, 4)))

        # external_call: self-loop marking where the call sits in the body
        m = _EXT_CALL.search(body)
        if m:
            edges.append((i, i, 1, round(m.start() / span, 4)))

        # state_dep: f and g touch the same state variable
        for v in state_vars:
            if not re.search(rf"\b{re.escape(v)}\b", body):
                continue
            for j, g in enumerate(funcs):
                if j != i and re.search(rf"\b{re.escape(v)}\b", g["body"]):
                    edges.append((i, j, 2, 1.0))

        # control_dep: modifier applied to f
        head = body[:body.find("{") if "{" in body else len(body)]
        for g_name, j in names.items():
            if j != i and funcs[j]["kind"] == "modifier" and re.search(
                    rf"(?<![\w.]){re.escape(g_name)}\b", head):
                edges.append((j, i, 3, 0.0))

    # de-duplicate identical (src, dst, type) keeping earliest order
    seen: Dict[Tuple[int, int, int], float] = {}
    for s, d, t, o in edges:
        key = (s, d, t)
        if key not in seen or o < seen[key]:
            seen[key] = o
    edge_list = [[s, d, t, o] for (s, d, t), o in sorted(seen.items())]

    return {"nodes": nodes, "edges": edge_list, "n_nodes": n,
            "state_vars": state_vars}
