---
title: Embeddings
category: genai-platform
updated: 2026-07-13
sources: [sources/2026-07-open-source-project-comparisons.md, sources/2026-07-commercial-product-comparisons.md]
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

## Open source project comparison

| Project / model family | Best fit | Watch-outs |
|---|---|---|
| **BGE / bge-m3** | Strong general multilingual/text retrieval baseline in open embedding stacks | Validate on your corpus; leaderboard wins do not guarantee domain fit |
| **E5** | General text embeddings with broad community use | Input formatting conventions matter; keep model version in vector metadata |
| **GTE / Nomic Embed** | Practical open alternatives for local or private embedding pipelines | Dimensionality and context length affect vector cost and chunking strategy |
| **SentenceTransformers** | Training/fine-tuning/evaluating embedding models in Python | Library, not one model; own benchmarking and deployment path |
| **TEI / Infinity / vLLM embeddings support** | Serving embedding models behind an API | Serving layer choice depends on throughput, batching, and GPU/CPU economics |

Pick embeddings by retrieval evals, not vibes: build a small question-document set and measure recall before re-embedding millions of chunks.

## Commercial product comparison

| Product | Best fit | Watch-outs |
|---|---|---|
| **OpenAI embeddings** | Strong general-purpose API embeddings with broad ecosystem support | Token cost, provider dependency, and model migrations require re-embedding plans |
| **Cohere Embed** | Enterprise retrieval, multilingual, rerank pairing, and private deployment options | Validate on your corpus and language/domain mix |
| **Voyage AI** | High-quality retrieval embeddings and domain-oriented model variants | Great retrieval focus; check provider risk and pricing at corpus scale |
| **Google Vertex AI embeddings / Gemini embedding models** | GCP-native embedding pipelines and Vertex integration | Best when data and serving are already in GCP |
| **Amazon Bedrock embeddings** | AWS-native embedding model access and governance | Model choice varies; benchmark each model family |
| **Azure AI model catalog embeddings** | Microsoft-governed embedding access for Azure estates | Useful for Azure policy/residency; evaluate quality and portability |

Commercial embeddings are easy to start and expensive to change. Version every vector and run retrieval evals before a corpus-wide migration.

## Related

- [vector-databases.md](vector-databases.md)
- [rag.md](rag.md)
- [data-catalog-and-lineage.md](data-catalog-and-lineage.md)
