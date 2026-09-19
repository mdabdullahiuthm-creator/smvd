# DIVE-G5 — dataset builder

Builds a graph-ready, leakage-controlled, 5-class multi-label smart contract
dataset from **DIVE**, plus the derived mitigation corpus.

**This repository contains code, not data.** The contracts come from DIVE and
are downloaded by step 1. Nothing here is fabricated — every number your paper
reports will come from contracts you downloaded and parsed yourself.

## Source

DIVE — Alsunaidi, Aljamaan & Hammoudeh, *Scientific Data* 13:664 (2026).
DOI `10.1038/s41597-026-07025-5` · Zenodo record `18519253` · CC BY 4.0.
22,330 verified Ethereum contracts, deployed 2016–2024, Solidity v0.4.x–v0.8.x,
labelled for 8 DASP categories by six analysis tools with Power-based voting and
post-hoc false-positive filtering. Source code ships as `.sol`.

## Why these 5 classes

DIVE ships 8. We keep Reentrancy, Access control, Arithmetic, Time manipulation
and Unchecked low-level calls, and drop DoS, Bad randomness and Front running —
DIVE's own label distribution shows those are the rarest, and a class reported on
a few hundred positives produces an F1 nobody should trust. Run `stats` and check
before you commit: any class under 1,000 positives should be dropped or merged.

## Run order

```bash
pip install -r requirements.txt

# 1. download DIVE (needs network; run on Colab or your own machine)
python src/build_dive_g5.py fetch   --out data/raw
#    unzip any archives inside data/raw before continuing

# 2. parse, build graphs, detect duplicate families
python src/build_dive_g5.py prepare --raw data/raw --out data/interim

# 3. family-level stratified 70/15/15 split (asserts zero leakage)
python src/build_dive_g5.py split   --interim data/interim --out data/final

# 4. the numbers for your Table I
python src/build_dive_g5.py stats   --final data/final
```

`fetch` prints every file in the Zenodo record before downloading. If `prepare`
cannot find the label columns it prints which ones were missing — extend
`LABEL_ALIASES` in `build_dive_g5.py` to match the actual column names.

## Try it now, without the download

```bash
python src/make_sample.py --out data/raw_sample --n 400
python src/build_dive_g5.py prepare --raw data/raw_sample --out data/interim_sample
python src/build_dive_g5.py split   --interim data/interim_sample --out data/final_sample
python src/build_dive_g5.py stats   --final data/final_sample
```

This generates synthetic template contracts so you can debug shapes, batching and
the model code today. **Never report a number produced from the sample.** Labels
there come from the generator, not from any analysis tool.

## Record schema

```jsonc
{
  "contract_id": "0xabc…",          // Etherscan address
  "sha256":      "…",               // hash of the normalized source
  "pragma":      "^0.8.19",
  "n_tokens":    1843,
  "labels":      [1,0,0,1,0],       // RE, AC, AR, TM, UC
  "family_id":   "0xdef…",          // near-duplicate family — SPLIT ON THIS
  "split":       "train",
  "graph": {
    "n_nodes": 12,
    "nodes": [{ "name":"withdraw", "kind":"function",
                "start_line":41, "end_line":57,
                "flags":[1,1,1,0,0,0,0],   // see NODE_FLAG_NAMES
                "tokens":["function","withdraw", …] }],
    "edges": [[2, 5, 0, 0.31]]       // [src, dst, type, order]
                                     // type: 0 internal_call 1 external_call
                                     //       2 state_dep     3 control_dep
  }
}
```

`flags` are `has_external_call, writes_state, write_after_call,
has_access_check, has_loop, unchecked_call, uses_timestamp`. The third one is
the reentrancy signature: a state write that happens *after* an external call.

Parsing is regex + brace matching, not `solc`. That is deliberate — a large part
of DIVE is Solidity 0.4.x/0.5.x, which current compilers refuse, and a
compiler-dependent pipeline would silently drop those contracts and skew the
corpus toward recent code.

## Leakage control

DIVE's own Technical Validation reports that 3,455 of its 22,330 contracts
(15.47%) share an opcode skeleton with another contract, the largest duplicate
family holding 241 — and its Usage Notes warn this causes train/test leakage and
overestimated performance. So:

- exact duplicates merge by SHA-256 of the normalized source;
- near-duplicates merge by MinHash-LSH candidates confirmed with exact Jaccard
  ≥ 0.90 on 5-token shingles;
- splitting happens at **family** level, and `split` asserts that no family
  spans two splits. If that assertion ever fires, stop and fix it.

## Stage 2 — mitigation corpus

Build `DIVE-G5-Fix` from the **train+val** true positives only (`predicted == 1
and actual == 1`). `stats` prints the upper bound. Each pair holds the
attention-selected function, its PDG slice, the vulnerable code and the patched
code. Test-split contracts must never appear. Evaluate patches by execution —
compiles, vulnerability removed, tests pass — not by BLEU or exact match.

## Before you submit

1. Every reported class has ≥ 1,000 positives.
2. Confusion matrices sum to the **test** split size, not the corpus size.
3. Zero families span splits (the assertion in `split`).
4. Contract2Vec is fitted on train only (`loader.train_contract2vec`).
5. No test-split contract appears in the mitigation corpus.
6. Metrics are macro F1 and PR-AUC with per-class breakdown — DIVE's Usage Notes
   recommend exactly this, because Access control and Reentrancy dominate and
   accuracy would hide the rest.

## Citation

Cite DIVE for the data and state clearly that DIVE-G5 is a derived subset:
5 of 8 classes, deduplicated into families, split at family level, with
function-dependency graphs added.
