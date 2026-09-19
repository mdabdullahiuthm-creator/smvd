#!/usr/bin/env python3
"""
DIVE-G5 builder.

  python src/build_dive_g5.py fetch    --out data/raw
  python src/build_dive_g5.py prepare  --raw data/raw --out data/interim
  python src/build_dive_g5.py split    --interim data/interim --out data/final
  python src/build_dive_g5.py stats    --final data/final

Source dataset:
  DIVE (Alsunaidi, Aljamaan & Hammoudeh, Scientific Data 13:664, 2026)
  Zenodo record 18519253  -  CC BY 4.0
  22,330 verified Ethereum contracts, 8 DASP labels, .sol sources included.

DIVE-G5 keeps 5 of the 8 labels and adds what DIVE does not ship:
function-dependency graphs, duplicate families, and a leakage-safe split.
"""

import argparse
import json
import os
import random
import re
import sys
from collections import Counter

import numpy as np
import pandas as pd

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from core import (assign_families, build_contract_graph, normalize_solidity,  # noqa: E402
                  sha256_of, tokenize)

ZENODO_RECORD = "18519253"

# The 5 classes we keep. DIVE also ships DoS, Bad randomness and Front running;
# those are dropped because they are the rarest categories in DIVE and would be
# reported on too few positives to be meaningful.
CLASSES = ["reentrancy", "access_control", "arithmetic",
           "time_manipulation", "unchecked_low_level_calls"]

# DIVE label columns vary in spelling; each class lists accepted aliases.
LABEL_ALIASES = {
    "reentrancy": ["reentrancy", "re", "reentrancy_label"],
    "access_control": ["access control", "access_control", "accesscontrol", "ac"],
    "arithmetic": ["arithmetic", "arithmetic issues", "arithmetic_issues", "ar"],
    "time_manipulation": ["time manipulation", "time_manipulation",
                          "timemanipulation", "timestamp", "tm"],
    "unchecked_low_level_calls": ["unchecked low level calls",
                                  "unchecked_low_level_calls",
                                  "unchecked calls", "unchecked_calls", "uc"],
}
ADDR_ALIASES = ["contractaddress", "contract_address", "address", "addr"]

MIN_POSITIVES_TO_REPORT = 1000  # below this, do not report the class separately


# ---------------------------------------------------------------- fetch
def cmd_fetch(args):
    """Download the DIVE Zenodo record. Requires network (Colab / your machine)."""
    import requests

    os.makedirs(args.out, exist_ok=True)
    api = f"https://zenodo.org/api/records/{ZENODO_RECORD}"
    print(f"[fetch] {api}")
    meta = requests.get(api, timeout=60).json()
    files = meta.get("files", [])
    if not files:
        sys.exit("[fetch] no files in record - open the Zenodo page manually")

    print(f"[fetch] {len(files)} file(s):")
    for f in files:
        name = f.get("key")
        size_mb = f.get("size", 0) / 1e6
        url = f.get("links", {}).get("self")
        dest = os.path.join(args.out, name)
        print(f"  - {name}  ({size_mb:.1f} MB)")
        if os.path.exists(dest):
            print("    already present, skipping")
            continue
        with requests.get(url, stream=True, timeout=600) as r:
            r.raise_for_status()
            with open(dest, "wb") as fh:
                for chunk in r.iter_content(1 << 20):
                    fh.write(chunk)
    print(f"[fetch] done -> {args.out}")
    print("[fetch] unzip any archives, then run `prepare`.")


# ---------------------------------------------------------------- helpers
def _find_column(df, aliases):
    lowered = {c.lower().strip(): c for c in df.columns}
    for a in aliases:
        if a in lowered:
            return lowered[a]
    for a in aliases:
        for low, orig in lowered.items():
            if a in low:
                return orig
    return None


def _load_labels(raw_dir):
    """Locate the DIVE final-label table and reduce it to our 5 classes."""
    cands = []
    for root, _, files in os.walk(raw_dir):
        for fn in files:
            if fn.lower().endswith((".csv", ".xlsx")) and "label" in fn.lower():
                cands.append(os.path.join(root, fn))
    if not cands:
        for root, _, files in os.walk(raw_dir):
            for fn in files:
                if fn.lower().endswith((".csv", ".xlsx")):
                    cands.append(os.path.join(root, fn))
    if not cands:
        sys.exit(f"[prepare] no CSV/XLSX under {raw_dir}")

    for path in sorted(cands, key=lambda p: ("final" not in p.lower(), len(p))):
        df = pd.read_excel(path) if path.endswith(".xlsx") else pd.read_csv(path)
        addr_col = _find_column(df, ADDR_ALIASES)
        found = {c: _find_column(df, LABEL_ALIASES[c]) for c in CLASSES}
        if addr_col and all(found.values()):
            print(f"[prepare] labels from {os.path.basename(path)}  ({len(df)} rows)")
            out = pd.DataFrame({"address": df[addr_col].astype(str).str.lower().str.strip()})
            for c in CLASSES:
                out[c] = pd.to_numeric(df[found[c]], errors="coerce").fillna(0)
                out[c] = (out[c] > 0).astype(int)
            return out.drop_duplicates("address")
        print(f"[prepare] skipped {os.path.basename(path)} "
              f"(addr={bool(addr_col)}, missing={[k for k, v in found.items() if not v]})")
    sys.exit("[prepare] could not find a label table with all 5 classes. "
             "Inspect the files and extend LABEL_ALIASES.")


def _index_sol_files(raw_dir):
    """address -> .sol path. DIVE names source files by contract address."""
    idx = {}
    for root, _, files in os.walk(raw_dir):
        for fn in files:
            if not fn.endswith(".sol"):
                continue
            m = re.search(r"(0x[0-9a-fA-F]{40})", fn)
            key = m.group(1).lower() if m else os.path.splitext(fn)[0].lower()
            idx[key] = os.path.join(root, fn)
    print(f"[prepare] {len(idx)} .sol files indexed")
    return idx


_PRAGMA = re.compile(r"pragma\s+solidity\s+([^\;]+);")


# ---------------------------------------------------------------- prepare
def cmd_prepare(args):
    os.makedirs(args.out, exist_ok=True)
    labels = _load_labels(args.raw)
    sol_idx = _index_sol_files(args.raw)

    records, stats = [], Counter()
    for row in labels.itertuples(index=False):
        addr = row.address
        stats["labelled"] += 1
        path = sol_idx.get(addr)
        if path is None:
            stats["no_source"] += 1
            continue
        try:
            with open(path, "r", encoding="utf-8", errors="ignore") as fh:
                src = fh.read()
        except OSError:
            stats["unreadable"] += 1
            continue
        if len(src) < 120:
            stats["too_short"] += 1
            continue

        graph = build_contract_graph(src)
        if graph["n_nodes"] == 0:
            stats["no_functions"] += 1
            continue

        norm = normalize_solidity(src)
        pm = _PRAGMA.search(src)
        records.append({
            "contract_id": addr,
            "sha256": sha256_of(norm),
            "pragma": pm.group(1).strip() if pm else "unknown",
            "n_tokens": len(tokenize(norm)),
            "labels": [int(getattr(row, c)) for c in CLASSES],
            "graph": graph,
            "normalized": norm,
        })
        stats["kept"] += 1
        if stats["kept"] % 500 == 0:
            print(f"  parsed {stats['kept']}")

    print("[prepare] funnel:", dict(stats))
    if not records:
        sys.exit("[prepare] nothing kept - check that .sol files are unzipped")

    print("[prepare] duplicate families...")
    fam = assign_families(records, threshold=args.dup_threshold)
    for r in records:
        r["family_id"] = fam[r["contract_id"]]
        del r["normalized"]  # not needed downstream, keeps the file small

    out = os.path.join(args.out, "contracts.jsonl")
    with open(out, "w") as fh:
        for r in records:
            fh.write(json.dumps(r) + "\n")

    with open(os.path.join(args.out, "funnel.json"), "w") as fh:
        json.dump({"stages": dict(stats),
                   "families": len(set(fam.values()))}, fh, indent=2)
    print(f"[prepare] wrote {len(records)} records -> {out}")


# ---------------------------------------------------------------- split
def _stratified_family_split(fams, ratios, seed):
    """Greedy iterative stratification at family level.

    Families are placed largest-first into whichever split is currently
    furthest below its quota for the rarest label that family carries.
    """
    rng = random.Random(seed)
    names = ["train", "val", "test"]
    totals = np.zeros(len(CLASSES))
    for f in fams.values():
        totals += f["labels"]
    target = {n: totals * r for n, r in zip(names, ratios)}
    got = {n: np.zeros(len(CLASSES)) for n in names}
    size_target = {n: sum(len(f["ids"]) for f in fams.values()) * r
                   for n, r in zip(names, ratios)}
    size_got = {n: 0 for n in names}

    order = sorted(fams.items(), key=lambda kv: (-len(kv[1]["ids"]),
                                                 rng.random()))
    assign = {}
    for fid, f in order:
        lab = f["labels"]
        size = len(f["ids"])

        def cost(n):
            # relative over-fill on size, plus relative over-fill on each
            # label this family carries. Both normalised so neither dominates.
            c = (size_got[n] + size) / max(size_target[n], 1.0)
            for k in range(len(CLASSES)):
                if lab[k] > 0 and target[n][k] > 0:
                    c += (got[n][k] + lab[k]) / target[n][k]
            return c / (1 + int(lab.sum()))

        pick = min(names, key=cost)
        assign[fid] = pick
        got[pick] += lab
        size_got[pick] += size
    return assign


def cmd_split(args):
    os.makedirs(args.out, exist_ok=True)
    recs = [json.loads(l) for l in open(os.path.join(args.interim, "contracts.jsonl"))]

    fams = {}
    for r in recs:
        f = fams.setdefault(r["family_id"], {"ids": [], "labels": np.zeros(len(CLASSES))})
        f["ids"].append(r["contract_id"])
        f["labels"] = np.maximum(f["labels"], np.array(r["labels"]))

    ratios = [args.train, args.val, 1.0 - args.train - args.val]
    assign = _stratified_family_split(fams, ratios, args.seed)

    counts = Counter()
    for r in recs:
        r["split"] = assign[r["family_id"]]
        counts[r["split"]] += 1

    for name in ["train", "val", "test"]:
        path = os.path.join(args.out, f"{name}.jsonl")
        with open(path, "w") as fh:
            for r in recs:
                if r["split"] == name:
                    fh.write(json.dumps(r) + "\n")
        print(f"[split] {name}: {counts[name]}")

    # leakage assertion: no family may straddle two splits
    fam_splits = {}
    for r in recs:
        fam_splits.setdefault(r["family_id"], set()).add(r["split"])
    bad = [f for f, s in fam_splits.items() if len(s) > 1]
    assert not bad, f"LEAKAGE: {len(bad)} families span splits"
    print("[split] leakage check passed (0 families span splits)")

    with open(os.path.join(args.out, "split_meta.json"), "w") as fh:
        json.dump({"classes": CLASSES, "counts": dict(counts),
                   "ratios": ratios, "seed": args.seed}, fh, indent=2)


# ---------------------------------------------------------------- stats
def cmd_stats(args):
    rows, per_split = [], {}
    for name in ["train", "val", "test"]:
        path = os.path.join(args.final, f"{name}.jsonl")
        if not os.path.exists(path):
            continue
        recs = [json.loads(l) for l in open(path)]
        per_split[name] = recs
        arr = np.array([r["labels"] for r in recs])
        rows.append([name, len(recs)] + arr.sum(axis=0).tolist())

    df = pd.DataFrame(rows, columns=["split", "contracts"] + CLASSES)
    print("\n=== DIVE-G5 composition (paste into Table I) ===")
    print(df.to_string(index=False))

    total = df[CLASSES].sum()
    print("\n=== class check ===")
    for c in CLASSES:
        n = int(total[c])
        flag = "OK" if n >= MIN_POSITIVES_TO_REPORT else "TOO FEW - drop or merge"
        print(f"  {c:28s} {n:6d}  {flag}")

    if "test" in per_split:
        n_test = len(per_split["test"])
        print(f"\n  Your confusion matrices must sum to {n_test}, not to the corpus size.")

    allrecs = [r for v in per_split.values() for r in v]
    if allrecs:
        nodes = np.array([r["graph"]["n_nodes"] for r in allrecs])
        edges = np.array([len(r["graph"]["edges"]) for r in allrecs])
        print(f"\n  graph: nodes mean {nodes.mean():.1f} median {np.median(nodes):.0f} "
              f"max {nodes.max()} | edges mean {edges.mean():.1f}")
        vuln = sum(1 for r in allrecs if sum(r["labels"]) > 0)
        print(f"  vulnerable contracts: {vuln} / {len(allrecs)} "
              f"({100 * vuln / len(allrecs):.1f}%)")
        tr = len(per_split.get("train", [])) + len(per_split.get("val", []))
        tr_v = sum(1 for r in per_split.get("train", []) + per_split.get("val", [])
                   if sum(r["labels"]) > 0)
        print(f"  Dataset-2 upper bound (train+val true positives): ~{tr_v} pairs")


# ---------------------------------------------------------------- cli
def main():
    p = argparse.ArgumentParser(description="Build the DIVE-G5 dataset")
    sub = p.add_subparsers(dest="cmd", required=True)

    f = sub.add_parser("fetch"); f.add_argument("--out", default="data/raw")
    f.set_defaults(func=cmd_fetch)

    pr = sub.add_parser("prepare")
    pr.add_argument("--raw", default="data/raw")
    pr.add_argument("--out", default="data/interim")
    pr.add_argument("--dup-threshold", type=float, default=0.90)
    pr.set_defaults(func=cmd_prepare)

    s = sub.add_parser("split")
    s.add_argument("--interim", default="data/interim")
    s.add_argument("--out", default="data/final")
    s.add_argument("--train", type=float, default=0.70)
    s.add_argument("--val", type=float, default=0.15)
    s.add_argument("--seed", type=int, default=42)
    s.set_defaults(func=cmd_split)

    st = sub.add_parser("stats"); st.add_argument("--final", default="data/final")
    st.set_defaults(func=cmd_stats)

    args = p.parse_args()
    args.func(args)


if __name__ == "__main__":
    main()
