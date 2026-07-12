---
title: Embeddings
category: genai-platform
updated: 2026-07-12
---

# Embeddings

An **embedding** is a dense vector (typically 256–3,072 floats) representing the meaning of text, images, or code: similar meaning → nearby vectors, making semantic similarity computable (cosine similarity). Embeddings power semantic search, [RAG](rag.md) retrieval, clustering, dedup, and recommendations — and for the platform they are simply **derived data** with unusual invalidation rules.

## Produced how

A dedicated embedding model (small encoder, distinct from generative LLMs) maps input → vector in one pass. Families: OpenAI/Cohere/Voyage APIs, open models (BGE, E5, GTE — see the MTEB leaderboard). Selection criteria: dimensionality (storage/search cost), max input tokens (caps chunk size), domain/language fit, cost per million tokens.

## Embeddings as derived data — the platform rules

- **Lineage**: every vector has a source (text), a producing **model + version**, and a chunking config. Record all three with the vector ([data-catalog-and-lineage.md](data-catalog-and-lineage.md)).
- **Invalidation**: source changes → re-embed the chunk; **model version changes → re-embed the entire corpus** — vectors from different models are incompatible spaces; never mix them in one index.
- **Pipelines**: embedding generation is a standard [pipeline](data-ingestion.md) workload — batch backfills (rate-limit-aware), incremental updates, dead-letter handling, all [orchestrated](orchestration.md).
- **Deletion**: erasing a source document means deleting its vectors too — embeddings of PII are governed data, partially invertible back to text ([data-governance.md](data-governance.md)).
- **Footprint math**: 1M chunks × 1536 dims × 4 bytes ≈ 6 GB before index overhead; quantization (int8/binary) cuts 4–32× with modest recall loss ([vector-databases.md](vector-databases.md)).

## Practical guidance

- Embed **chunks, not documents** — long inputs average meaning into mush ([rag.md](rag.md) covers chunking).
- Similarity ≠ relevance: embeddings capture topical closeness, not answer-ness; production retrieval pairs them with keyword search and reranking ([rag.md](rag.md)).
- Keep the source text forever — you will re-embed (model deprecations guarantee it), and rebuild time bounds your recovery time.
- Version-tag vectors and validate at write time; a mixed-model index degrades silently.

## Beyond RAG

Embedding columns are appearing *inside* the warehouse/lakehouse (native VECTOR types): semantic dedup of customer records, similarity joins, clustering support tickets — treat these like any computed column, with the same refresh and lineage discipline.

## Related

- [vector-databases.md](vector-databases.md)
- [rag.md](rag.md)
- [data-catalog-and-lineage.md](data-catalog-and-lineage.md)
