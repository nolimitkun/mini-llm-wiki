---
title: Glossary
category: reference
updated: 2026-07-12
---

# Glossary

Quick definitions with links to the full pages.

| Term | Definition |
|---|---|
| **ACID** | Atomic, consistent, isolated, durable transactions — brought to the lake by [table formats](table-and-file-formats.md) |
| **Agent** | LLM in a loop choosing tools/actions until a goal is met → [agents-and-mcp.md](agents-and-mcp.md) |
| **ANN** | Approximate nearest neighbor — fast vector similarity search → [vector-databases.md](vector-databases.md) |
| **Batch scoring** | Scheduled model predictions written to a table → [model-serving.md](model-serving.md) |
| **CDC** | Change data capture — replicating a database via its write-ahead log → [data-ingestion.md](data-ingestion.md) |
| **Columnar storage** | Values stored column-by-column; the reason analytics is fast → [oltp-vs-olap.md](oltp-vs-olap.md) |
| **Compaction** | Merging small files into scan-efficient large ones → [table-and-file-formats.md](table-and-file-formats.md) |
| **Data contract** | Agreed schema + semantics + SLA at a team boundary → [data-mesh.md](data-mesh.md) |
| **Data mesh** | Domain teams own data as products on a shared platform → [data-mesh.md](data-mesh.md) |
| **Data product** | Dataset with an owner, docs, SLOs, and consumers treated as customers → [data-mesh.md](data-mesh.md) |
| **Data swamp** | Ungoverned lake: undocumented, unowned, untrusted → [data-lake.md](data-lake.md) |
| **Dimensional model** | Facts + dimensions (star schema) for analytics → [data-modeling.md](data-modeling.md) |
| **ELT** | Land raw, transform inside the platform (vs. ETL's transform-first) → [data-ingestion.md](data-ingestion.md) |
| **Embedding** | Dense vector representing meaning; enables semantic search → [embeddings.md](embeddings.md) |
| **Event time vs. processing time** | When it happened vs. when the system saw it → [stream-processing.md](stream-processing.md) |
| **Feature store** | One feature definition, served consistently offline (training) and online (inference) → [feature-stores.md](feature-stores.md) |
| **Grain** | What one row of a fact table represents → [data-modeling.md](data-modeling.md) |
| **Hybrid search** | Vector + keyword retrieval fused → [rag.md](rag.md) |
| **Iceberg / Delta / Hudi** | Open table formats → [table-and-file-formats.md](table-and-file-formats.md) |
| **Idempotency** | Reruns produce the same result — the first law of pipelines → [data-ingestion.md](data-ingestion.md) |
| **Lakehouse** | Warehouse guarantees on open lake storage → [lakehouse.md](lakehouse.md) |
| **Lineage** | The graph of what feeds what, source → dashboard/model/index → [data-catalog-and-lineage.md](data-catalog-and-lineage.md) |
| **LLM gateway** | Single proxy for model traffic: auth, quotas, routing, logging → [llms-on-the-platform.md](llms-on-the-platform.md) |
| **LLM-as-judge** | A strong model scoring outputs against a rubric → [llmops.md](llmops.md) |
| **MCP** | Model Context Protocol — standard connecting AI apps to tools/data → [agents-and-mcp.md](agents-and-mcp.md) |
| **Medallion / zones** | raw → refined → curated refinement layers → [data-lake.md](data-lake.md) |
| **MPP** | Massively parallel processing — queries fanned across nodes → [data-warehouse.md](data-warehouse.md) |
| **OLTP / OLAP** | Transaction processing vs. analytical processing → [oltp-vs-olap.md](oltp-vs-olap.md) |
| **OpenLineage** | Exchange standard for lineage metadata → [data-catalog-and-lineage.md](data-catalog-and-lineage.md) |
| **Parquet** | The default columnar file format → [table-and-file-formats.md](table-and-file-formats.md) |
| **Point-in-time correctness** | Training data as-of the label's timestamp; no future leakage → [feature-stores.md](feature-stores.md) |
| **Predicate pushdown** | Engine skips files/row-groups via statistics → [query-engines.md](query-engines.md) |
| **Prompt injection** | Hostile instructions embedded in content a model reads → [data-security-and-privacy.md](data-security-and-privacy.md) |
| **RAG** | Retrieval-Augmented Generation — retrieve context, then generate → [rag.md](rag.md) |
| **Reverse ETL** | Pushing analytical results back into operational tools → [oltp-vs-olap.md](oltp-vs-olap.md) |
| **Right to erasure** | Legal deletion that must propagate to all derived stores → [data-governance.md](data-governance.md) |
| **SCD** | Slowly changing dimensions — how history is kept when attributes change → [data-modeling.md](data-modeling.md) |
| **Schema-on-read / on-write** | Type at query time (lake) vs. at load time (warehouse) → [data-lake.md](data-lake.md) |
| **Semantic layer** | Governed, reusable metric definitions → [semantic-layer.md](semantic-layer.md) |
| **Time travel** | Querying a table as of a past snapshot → [table-and-file-formats.md](table-and-file-formats.md) |
| **Token** | Subword unit LLMs process; the unit of AI cost → [llms-on-the-platform.md](llms-on-the-platform.md) |
| **Training/serving skew** | Feature computed differently in training vs. production → [feature-stores.md](feature-stores.md) |
| **Watermark** | Streaming's "probably seen everything up to time T" marker → [stream-processing.md](stream-processing.md) |
