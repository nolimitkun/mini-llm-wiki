---
title: Vector databases
category: genai-platform
updated: 2026-07-13
sources: [sources/2026-07-open-source-project-comparisons.md, sources/2026-07-commercial-product-comparisons.md]
---

# Vector databases

A **vector database** stores [embeddings](embeddings.md) and answers approximate-nearest-neighbor (ANN) queries — "the k most similar vectors to this one" — the storage primitive behind semantic search and [RAG](rag.md). On the platform it's a **derived, rebuildable store** fed by pipelines, not a source of truth.

## ANN indexes (why "approximate")

Exact search over millions of high-dim vectors is too slow; indexes trade a little recall for orders of magnitude speed:

| Index | Idea | Trade-off |
|---|---|---|
| **HNSW** | Navigable graph | Fast, high recall, memory-hungry — the default |
| **IVF** | Cluster, search nearest clusters | Less memory; recall needs tuning |
| **Quantization** (PQ/int8/binary) | Compress vectors | 4–32× smaller, slight recall loss; combines with above |
| **Disk-based (DiskANN)** | Graph on SSD | Billion-scale on modest RAM |

Tune to **recall@k vs QPS vs memory** measured on *your* data. Capacity math: `vectors × dims × 4B × ~1.5–2×` — 100M × 1536-dim ≈ ~1 TB RAM for HNSW; quantization becomes mandatory around this scale.

## What to store with each vector

ID, chunk text, source doc reference, **embedding model + version**, and filterable metadata — tenant, ACL groups, date, doc type, language. **Metadata filtering is as important as similarity**: verify your engine pre-filters efficiently (post-filtering top-k returns too few results), because ACL enforcement at query time lives here ([data-security-and-privacy.md](data-security-and-privacy.md)).

## Deployment options

| Option | Examples | When |
|---|---|---|
| Extension of what you run | **pgvector**, OpenSearch/Elastic k-NN, warehouse-native vector types | Default start — fewest moving parts, < ~50M vectors |
| Dedicated engine | Qdrant, Weaviate, Milvus | Vector search is core; scale/filtering/quantization needs |
| Managed service | Pinecone, cloud vendors | Minimal ops, cost at scale |
| In-process library | FAISS, LanceDB, hnswlib | Batch jobs, prototypes, embedded |

The trend mirrors the rest of the platform: vector search is becoming a *feature of existing stores* (Postgres, OpenSearch, the lakehouse) rather than a mandatory new silo — resist adding a dedicated system until scale forces it ([build-vs-buy.md](build-vs-buy.md)).

## Platform integration

- **Fed by pipelines** with idempotent upserts and deletion propagation ([data-ingestion.md](data-ingestion.md)) — stale chunks answering from deleted documents is a compliance incident, not a quirk.
- **Hybrid search**: production retrieval pairs vectors with BM25 keyword search ([rag.md](rag.md)); prefer a store that does both.
- **Rebuild time = recovery time**: measure full re-embed + re-index duration; it bounds disaster recovery and model migrations ([embeddings.md](embeddings.md)).
- Index freshness gets an SLO and monitoring like any [quality](data-quality.md) surface.

## Open source project comparison

| Project | Best fit | Watch-outs |
|---|---|---|
| **pgvector** | Start here when Postgres already exists, scale is moderate, and relational filters matter | Simplicity wins early; very large/vector-heavy workloads can outgrow it |
| **Qdrant** | Purpose-built vector search with strong filtering and simpler ops than larger distributed systems | Good default dedicated engine; still a new production datastore |
| **Milvus** | Very large-scale vector workloads and distributed ANN infrastructure | More moving parts; best when scale justifies the complexity |
| **Weaviate** | Vector search plus higher-level schema/search/application features | Opinionated platform; evaluate fit against your desired control model |
| **OpenSearch k-NN** | Hybrid keyword/vector search where OpenSearch is already deployed | Useful consolidation; vector performance and filtering must be benchmarked |
| **LanceDB / FAISS / hnswlib** | Embedded, local, batch, or lake-adjacent vector workflows | Libraries/embedded stores are great until you need multi-tenant online serving |

Default to pgvector for small starts, Qdrant for a dedicated OSS vector store, and Milvus only when scale forces distributed vector infrastructure.

## Commercial product comparison

| Product | Best fit | Watch-outs |
|---|---|---|
| **Pinecone** | Managed purpose-built vector database with low ops and production scaling | Cost and proprietary service dependency grow with corpus/QPS |
| **Qdrant Cloud** | Managed Qdrant with OSS continuity and strong filtering | Good balance of product and openness; validate enterprise features needed |
| **Weaviate Cloud** | Managed Weaviate with schema/search/application features | Opinionated experience; evaluate fit with existing data model |
| **Zilliz Cloud** | Managed Milvus for large-scale vector workloads | Strong at scale; complexity is abstracted, not gone |
| **Databricks Vector Search** | Vector indexes governed close to lakehouse data and Mosaic AI apps | Best inside Databricks; less neutral for multi-platform retrieval |
| **Vertex AI Vector Search / Azure AI Search / Amazon OpenSearch Serverless** | Cloud-native vector search integrated with cloud IAM and AI stacks | Convenient in-cloud; portability and hybrid retrieval details vary |

Managed vector stores buy uptime and scale. The architectural question is whether vectors should live beside Postgres/search/lakehouse data or in a dedicated retrieval service.

## Related

- [embeddings.md](embeddings.md)
- [rag.md](rag.md)
- [data-security-and-privacy.md](data-security-and-privacy.md)
