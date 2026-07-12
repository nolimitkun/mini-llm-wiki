---
title: Retrieval techniques
category: rag
updated: 2026-07-12
---

# Retrieval techniques

Retrieval quality caps [RAG](rag-overview.md) quality — the generator can't cite what the retriever didn't find. Production retrieval is a **pipeline**, not a single vector query.

## The retrieval stack

```
query → query processing → candidate generation (hybrid) → filtering → reranking → top-k to prompt
```

### 1. Query processing

- **Rewriting**: turn conversational queries ("what about for enterprise?") into standalone ones using chat history — essential for multi-turn assistants.
- **Expansion**: add synonyms/related terms, or **HyDE** (embed a hypothetical answer instead of the question).
- **Decomposition**: split multi-part questions into sub-queries; retrieve for each.
- **Routing**: classify the query to pick the right index/source (docs vs. tickets vs. schema).

### 2. Candidate generation — go hybrid

| Method | Strengths | Weaknesses |
|---|---|---|
| **Dense (vector)** | Paraphrase, semantics, cross-lingual | Misses exact terms: IDs, SKUs, error codes, names |
| **Sparse (BM25/keyword)** | Exact matches, rare terms | No semantic understanding |
| **Hybrid (both + fusion)** | Best of both | Two indexes to run |

Fuse result lists with **Reciprocal Rank Fusion (RRF)** — simple, tuning-free, hard to beat. Hybrid is the production default; vector-only is a prototype smell.

### 3. Metadata filtering

Apply structured filters *before or during* similarity search: tenant, ACL groups ([governance](data-governance.md)), date ranges, doc type, language. Ensure your [vector DB](vector-databases.md) pre-filters efficiently.

### 4. Reranking

Retrieve generously (top 50–100 candidates), then apply a **cross-encoder reranker** (Cohere Rerank, BGE-reranker, etc.) that scores each query–chunk pair jointly and keep the top 5–10. Rerankers are far more accurate than embedding similarity and typically the **single biggest retrieval quality win** after hybrid search. Cost: one extra model call, ~50–200 ms.

### 5. Assembly

- Deduplicate near-identical chunks; optionally merge adjacent chunks from the same document.
- Order for the model: most relevant near the start or end of the context block ([lost-in-the-middle](context-windows.md)).
- Attach source metadata for citations.

## Tuning knobs & diagnostics

- **k (chunks in prompt)**: more isn't better — irrelevant chunks distract the model and cost tokens. Tune with [evaluation](rag-evaluation.md); 5–10 reranked chunks is a common sweet spot.
- **Similarity threshold**: below a floor, return "nothing relevant found" and let the prompt trigger a refusal instead of forcing weak context in.
- **Debug order**: check *is the answer in the corpus?* → *does it survive chunking?* → *does candidate generation find it (recall@100)?* → *does reranking keep it (recall@k)?* — instrument each stage.

## Related

- [Chunking strategies](chunking-strategies.md)
- [Vector databases](vector-databases.md)
- [Evaluating RAG systems](rag-evaluation.md)
