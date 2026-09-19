#!/usr/bin/env python3
"""
DIVE-G5 -> PyTorch Geometric.

Run this on Colab AFTER building the dataset. It needs torch +
torch_geometric + gensim, which are deliberately NOT required by the build
pipeline (so the build runs anywhere).

    from loader import load_split, train_contract2vec
    w2v = train_contract2vec("data/final/train.jsonl")       # train split only
    train = load_split("data/final/train.jsonl", w2v)

Node feature = mean-pooled Contract2Vec of the function body (d=100)
               concatenated with 7 structural flags -> 107 dims.
Edge types    = internal_call, external_call, state_dep, control_dep (0..3)
Edge attr     = the ordering scalar, which is what lets the model tell
                "state write before external call" from "after".
"""

import json

import numpy as np

CLASSES = ["reentrancy", "access_control", "arithmetic",
           "time_manipulation", "unchecked_low_level_calls"]
EMB_DIM = 100
N_FLAGS = 7


def read_jsonl(path):
    with open(path) as fh:
        for line in fh:
            yield json.loads(line)


def train_contract2vec(train_path, dim=EMB_DIM, epochs=5, seed=42):
    """Skip-gram over function token streams.

    Trained on the TRAIN split only. Fitting it on the whole corpus would
    leak test-set lexical statistics into the representation.
    """
    from gensim.models import Word2Vec

    sentences = []
    for rec in read_jsonl(train_path):
        for node in rec["graph"]["nodes"]:
            if node["tokens"]:
                sentences.append(node["tokens"])
    print(f"[c2v] {len(sentences)} function token streams")
    model = Word2Vec(sentences, vector_size=dim, window=5, min_count=2,
                     sg=1, workers=4, epochs=epochs, seed=seed)
    print(f"[c2v] vocab {len(model.wv)}")
    return model


def _node_matrix(rec, w2v):
    rows = []
    for node in rec["graph"]["nodes"]:
        vecs = [w2v.wv[t] for t in node["tokens"] if t in w2v.wv]
        emb = np.mean(vecs, axis=0) if vecs else np.zeros(EMB_DIM, dtype=np.float32)
        rows.append(np.concatenate([emb, np.array(node["flags"], dtype=np.float32)]))
    return np.vstack(rows).astype(np.float32)


def load_split(path, w2v, device=None):
    """-> list[torch_geometric.data.Data] with y (5,) and mask (5,)."""
    import torch
    from torch_geometric.data import Data

    out = []
    for rec in read_jsonl(path):
        g = rec["graph"]
        if g["n_nodes"] == 0:
            continue
        x = torch.tensor(_node_matrix(rec, w2v))

        if g["edges"]:
            e = np.array(g["edges"], dtype=np.float32)
            edge_index = torch.tensor(e[:, :2].T.astype(np.int64))
            edge_type = torch.tensor(e[:, 2].astype(np.int64))
            edge_attr = torch.tensor(e[:, 3:4])
        else:  # isolated nodes: self-loops keep message passing well defined
            n = g["n_nodes"]
            edge_index = torch.arange(n).repeat(2, 1)
            edge_type = torch.zeros(n, dtype=torch.long)
            edge_attr = torch.zeros(n, 1)

        d = Data(x=x, edge_index=edge_index, edge_attr=edge_attr)
        d.edge_type = edge_type
        d.y = torch.tensor(rec["labels"], dtype=torch.float32)
        # DIVE annotates all 5 classes, so the mask is all ones here. It stays
        # in the schema so a second corpus with partial labels can be mixed in
        # later without changing the loss.
        d.mask = torch.ones(len(CLASSES))
        d.contract_id = rec["contract_id"]
        d.family_id = rec["family_id"]
        out.append(d.to(device) if device else d)
    print(f"[load] {path}: {len(out)} graphs")
    return out


def masked_bce(logits, y, mask, pos_weight=None):
    """Loss computed only where mask == 1."""
    import torch
    import torch.nn.functional as F

    per = F.binary_cross_entropy_with_logits(
        logits, y, pos_weight=pos_weight, reduction="none")
    return (per * mask).sum() / mask.sum().clamp(min=1.0)


def compute_pos_weight(dataset):
    """pos_weight = negatives / positives, per class. For class imbalance."""
    import torch

    y = torch.stack([d.y for d in dataset])
    pos = y.sum(0).clamp(min=1.0)
    return ((len(dataset) - pos) / pos).clamp(max=50.0)
