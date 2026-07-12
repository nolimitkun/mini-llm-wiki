---
title: Vector databases
category: data-platform
updated: 2026-07-12
---

# Vector databases

A **vector database** stores [embeddings](embeddings.md) and answers **approximate nearest neighbor (ANN)** queries: "give me the k vectors most similar to this one" — the core operation behind semantic search and [RAG](rag-overview.md).

## Why "approximate"?

Exact nearest-neighbor search over millions of high-dimensional vectors is too slow. ANN indexes trade a little recall for orders-of-magnitude speed:

| Index | How it works | Trade-offs |
|---|---|---|
| **HNSW** | Multi-layer navigable graph | Fast, high recall; memory-hungry; the default choice |
| **IVF** | Cluster vectors, search nearest clusters | Lower memory; recall depends on nprobe tuning |
| **Quantization (PQ/SQ/binary)** | Compress vectors | 4–32× smaller; slight recall loss; often combined with IVF/HNSW |
| **DiskANN / SSD-based** | Graph index on disk | Billion-scale on modest RAM; higher latency |

Key metric: **recall@k vs. QPS vs. memory** — tune (e.g., HNSW's `efSearch`) to your latency budget and measure recall on your own data.

## What to store with each vector

```json
{
  "id": "doc123#chunk4",
  "vector": [ ... ],
  "text": "the chunk content",
  "metadata": {
    "source": "confluence", "doc_id": "doc123", "updated_at": "2026-05-01",
    "acl_groups": ["eng"], "embedding_model": "text-embedding-3-large@v1",
    "lang": "en", "doc_type": "runbook"
  }
}
```

Metadata enables **filtered search** (tenant, date, ACL, type) — in practice as important as similarity itself. Verify your engine supports *pre-filtering* efficiently; post-filtering top-k can return too few results.

## Deployment options

| Option | Examples | When |
|---|---|---|
| Extension of existing DB | pgvector, OpenSearch/Elasticsearch k-NN | You already run it; < ~50M vectors; fewest moving parts. **Start here.** |
| Dedicated vector DB | Qdrant, Weaviate, Milvus, Chroma | Vector search is core; need scale, quantization, advanced filtering |
| Managed service | Pinecone, Vertex/OpenSearch/Databricks vector offerings | Minimal ops; cost at scale |
| Library (in-process) | FAISS, hnswlib, LanceDB | Batch/offline, prototypes, embedded use |

## Platform integration concerns

- **Consistency with source of truth.** The vector index is a *derived* store fed by [pipelines](data-pipelines-for-llms.md); plan for drift detection and full rebuilds.
- **Multi-tenancy & ACLs.** Filter at query time using metadata that mirrors source-system permissions — see [security](security-and-privacy.md). Never rely on the LLM to withhold results.
- **Hybrid search.** Most production systems pair vector search with BM25 keyword search ([retrieval techniques](retrieval-techniques.md)); pick a store that supports both or plan for two systems.
- **Capacity math.** `vectors × dims × 4 bytes × (1.5–2 index overhead)`. 100M × 1536-dim ≈ 0.9–1.2 TB RAM for HNSW — quantization or disk-based indexes become mandatory around this scale.
- **Rebuild time** is your recovery time. Measure how long a full re-embed + re-index takes; it bounds disaster recovery and model-migration windows.

## Related

- [Embeddings](embeddings.md)
- [Retrieval techniques](retrieval-techniques.md)
- [Data pipelines for LLM workloads](data-pipelines-for-llms.md)
