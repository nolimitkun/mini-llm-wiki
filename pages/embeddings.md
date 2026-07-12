---
title: Embeddings
category: fundamentals
updated: 2026-07-12
---

# Embeddings

An **embedding** is a dense vector (typically 256–3,072 floats) representing the *meaning* of a piece of text (or image, audio, code). Texts with similar meaning map to nearby vectors, making semantic similarity computable with simple math — usually **cosine similarity**.

Embeddings are the foundation of [semantic search](retrieval-techniques.md), [RAG](rag-overview.md), clustering, deduplication, recommendation, and anomaly detection over unstructured data.

## How they're produced

A dedicated **embedding model** (usually a small encoder Transformer, distinct from the generative LLM) maps text → vector in a single forward pass. Popular families: OpenAI `text-embedding-3`, Cohere Embed, Voyage, and open models on the [MTEB leaderboard](https://huggingface.co/spaces/mteb/leaderboard) (e.g., BGE, E5, GTE).

Key model properties to evaluate:

| Property | Why it matters |
|---|---|
| Dimensionality | Storage & search cost scale with it; some models support truncation (Matryoshka) |
| Max input tokens | Caps your [chunk size](chunking-strategies.md) |
| Domain/language coverage | General models underperform on legal, medical, code, or non-English text |
| Retrieval vs. similarity tuning | Some models use task-specific prefixes ("query:" / "passage:") |

## Platform considerations

### Embeddings are derived data
Treat them like any materialized view: they have a **source** (the original text), a **producing model + version**, and a **freshness requirement**. When the source changes, re-embed. When the model changes, **re-embed everything** — vectors from different models (or versions) live in incompatible spaces and must never be mixed in one index.

### Pipeline design
Embedding generation belongs in your [data pipelines](data-pipelines-for-llms.md): batch backfills for corpora, incremental/streaming updates for fresh content, with retries and dead-letter handling like any other job.

### Storage & indexing
Vectors live in a [vector database](vector-databases.md) or a vector index inside your existing store (Postgres/pgvector, OpenSearch, warehouse-native). Store alongside each vector: source ID, chunk text, model version, and filterable metadata.

### Cost & footprint
1M chunks × 1,536 dims × 4 bytes ≈ 6 GB raw — before index overhead. Dimension reduction and quantization (int8, binary) can cut this 4–32× with modest recall loss.

## Common pitfalls

- **Mixing model versions in one index** — silently degrades retrieval; enforce model-version metadata and validate at write time.
- **Embedding whole documents** — long inputs average out meaning; embed [chunks](chunking-strategies.md).
- **Assuming similarity = relevance** — embeddings capture topical similarity, not answer-ness; combine with [reranking and hybrid search](retrieval-techniques.md).
- **No re-embedding plan** — model deprecations happen; keep source text so you can always rebuild.

## Related

- [Vector databases](vector-databases.md)
- [RAG overview](rag-overview.md)
- [Retrieval techniques](retrieval-techniques.md)
