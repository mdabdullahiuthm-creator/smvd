#!/usr/bin/env python3
"""
Generate a SYNTHETIC mini-corpus in DIVE's on-disk layout.

Purpose: smoke-test the pipeline and the model code before the real DIVE
download finishes. These contracts are machine-generated templates with
labels derived from the template, not from any analysis tool.

NEVER report numbers from this sample in the paper. It exists to prove the
code runs end to end and to let you debug shapes and batching.

  python src/make_sample.py --out data/raw_sample --n 300
"""

import argparse
import csv
import os
import random

HEAD = "// SPDX-License-Identifier: MIT\npragma solidity {ver};\n\n"

SAFE_FN = """
    function {name}(uint amount) public {{
        require(amount > 0, "zero");
        balances[msg.sender] += amount;
        total = total + amount;
    }}
"""

REENTRANT_FN = """
    function {name}(uint amount) public {{
        require(balances[msg.sender] >= amount);
        msg.sender.call.value(amount)("");
        balances[msg.sender] -= amount;
    }}
"""

NO_ACCESS_FN = """
    function {name}(address newOwner) public {{
        owner = newOwner;
    }}
"""

ACCESS_OK_FN = """
    function {name}(address newOwner) public onlyOwner {{
        owner = newOwner;
    }}
"""

OVERFLOW_FN = """
    function {name}(uint a, uint b) public {{
        uint c = a + b;
        counters[msg.sender] = counters[msg.sender] + c;
    }}
"""

TIME_FN = """
    function {name}() public view returns (uint) {{
        return uint(block.timestamp) % 100;
    }}
"""

UNCHECKED_FN = """
    function {name}(address payable to, uint amount) public {{
        to.send(amount);
        total -= amount;
    }}
"""

CHECKED_FN = """
    function {name}(address payable to, uint amount) public {{
        require(to.send(amount), "send failed");
        total -= amount;
    }}
"""

CLASSES = ["reentrancy", "access_control", "arithmetic",
           "time_manipulation", "unchecked_low_level_calls"]


def make_contract(rng, idx):
    labels = {c: 0 for c in CLASSES}
    ver = rng.choice(["^0.4.24", "^0.5.16", "^0.6.12", "^0.7.6", "^0.8.19"])
    body = [
        "    mapping(address => uint) public balances;",
        "    mapping(address => uint) public counters;",
        "    uint public total;",
        "    address public owner;",
        "    modifier onlyOwner() { require(msg.sender == owner); _; }",
    ]
    body.append(SAFE_FN.format(name="deposit"))

    if rng.random() < 0.30:
        body.append(REENTRANT_FN.format(name="withdraw"))
        labels["reentrancy"] = 1
    else:
        body.append(SAFE_FN.format(name="withdraw"))

    if rng.random() < 0.35:
        body.append(NO_ACCESS_FN.format(name="setOwner"))
        labels["access_control"] = 1
    else:
        body.append(ACCESS_OK_FN.format(name="setOwner"))

    if rng.random() < 0.25 and ver.startswith(("^0.4", "^0.5", "^0.6", "^0.7")):
        body.append(OVERFLOW_FN.format(name="addUp"))
        labels["arithmetic"] = 1

    if rng.random() < 0.20:
        body.append(TIME_FN.format(name="draw"))
        labels["time_manipulation"] = 1

    if rng.random() < 0.22:
        body.append(UNCHECKED_FN.format(name="payout"))
        labels["unchecked_low_level_calls"] = 1
    elif rng.random() < 0.5:
        body.append(CHECKED_FN.format(name="payout"))

    # filler functions with random names/arity so distinct contracts do not
    # collapse into one near-duplicate family
    for k in range(rng.randint(1, 5)):
        fn = "".join(rng.choice("abcdefghijklmnopqrstuvwxyz") for _ in range(7))
        args_ = ", ".join(f"uint {chr(97 + j)}" for j in range(rng.randint(1, 3)))
        body.append(
            f"\n    function {fn}({args_}) public view returns (uint) {{\n"
            f"        return total + {rng.randint(1, 9999)};\n    }}\n"
        )

    src = HEAD.format(ver=ver) + f"contract Sample{idx} {{\n" + "\n".join(body) + "\n}\n"
    return src, labels


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", default="data/raw_sample")
    ap.add_argument("--n", type=int, default=300)
    ap.add_argument("--dup-rate", type=float, default=0.12,
                    help="fraction emitted as near-duplicates, to exercise "
                         "family detection")
    ap.add_argument("--seed", type=int, default=7)
    args = ap.parse_args()

    rng = random.Random(args.seed)
    sol_dir = os.path.join(args.out, "sources")
    os.makedirs(sol_dir, exist_ok=True)

    rows, made = [], []
    i = 0
    while len(rows) < args.n:
        if made and rng.random() < args.dup_rate:
            # near-duplicate: same code, renamed contract + different constants
            src, labels = rng.choice(made)
            src = src.replace("Sample", f"Clone{i}_").replace("100", str(rng.randint(2, 999)))
        else:
            src, labels = make_contract(rng, i)
            made.append((src, labels))
        addr = "0x" + "".join(rng.choice("0123456789abcdef") for _ in range(40))
        with open(os.path.join(sol_dir, f"{addr}.sol"), "w") as fh:
            fh.write(src)
        rows.append({"contractAddress": addr, **labels})
        i += 1

    csv_path = os.path.join(args.out, "dive_labels_final.csv")
    with open(csv_path, "w", newline="") as fh:
        w = csv.DictWriter(fh, fieldnames=["contractAddress"] + CLASSES)
        w.writeheader()
        w.writerows(rows)

    print(f"[sample] {len(rows)} SYNTHETIC contracts -> {sol_dir}")
    print(f"[sample] labels -> {csv_path}")
    print("[sample] reminder: synthetic. Never quote these numbers in the paper.")


if __name__ == "__main__":
    main()
