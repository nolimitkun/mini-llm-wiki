---
title: Building a data/AI platform from open source
category: platform-architecture
updated: 2026-07-12
sources: [sources/2026-07-oss-data-ai-platform-research.md]
---

# Building a data/AI platform from open source

Every layer of the [reference architecture](reference-architecture.md) has a production-grade open source implementation in 2026 — you can assemble a complete data/AI platform with zero license fees. The honest framing: **open source moves cost rather than removing it** (license fees → engineering time and operational ownership), and its deepest value isn't price but **control and portability** — the same stack runs on any cloud or [on-prem](hybrid-cloud.md), with no vendor able to reprice your roadmap.

## The reference OSS stack, layer by layer

| Layer | Default pick | Alternatives / notes |
|---|---|---|
| Object storage | **MinIO** (S3-compatible, on-prem) or cloud object store | The substrate everything shares |
| [Table format](table-and-file-formats.md) | **Apache Iceberg** | Delta Lake (largest installed base); Iceberg is the neutral interchange (~78% exclusive-use in adoption surveys) |
| Catalog (technical) | **Polaris / Nessie / Lakekeeper** | Nessie adds Git-like branching; the control point — choose deliberately ([lakehouse.md](lakehouse.md)) |
| [Query engines](query-engines.md) | **Trino** (interactive SQL), **Spark** (heavy batch), **DuckDB** (small data/dev), **ClickHouse** (real-time OLAP) | All read the same Iceberg tables — engine-per-workload is the OSS superpower |
| [Ingestion](data-ingestion.md) | **Airbyte** (350+ connectors), **dlt** (Python ELT), **Debezium** (CDC standard) | Airbyte embeds Debezium for database CDC |
| [Streaming](stream-processing.md) | **Kafka + Flink** | Kafka-to-Iceberg table services are shrinking custom job counts |
| [Transformation](data-transformation.md) | **dbt-core** | SQLMesh the strongest challenger; note 2026's dbt+Fivetran merger when weighing vendor risk |
| [Orchestration](orchestration.md) | **Airflow** (incumbent) or **Dagster** (asset-centric) | |
| [Semantic layer](semantic-layer.md) | **Cube Core** or **MetricFlow** | Cube positions as the AI-agent-facing layer |
| [Catalog & lineage](data-catalog-and-lineage.md) | **OpenMetadata** (most active community) or **DataHub** (graph model, streaming metadata) | **OpenLineage** as the exchange standard; Marquez for lineage-only needs |
| BI | **Superset**, Metabase, Lightdash | |
| [ML platform](ml-platform-overview.md) | **MLflow** (tracking/registry, now also LLM gateway + agent tracing), **Feast** (features), **Ray/Kubeflow** (training) | |
| [GenAI serving](llms-on-the-platform.md) | **vLLM** (GPU scale), **Ollama** (local), **LiteLLM** (gateway) | Open-weight models: Llama/Qwen/Mistral/DeepSeek families |
| Vectors / [RAG](rag.md) | **pgvector** or **Qdrant**; LlamaIndex/LangGraph frameworks | Start with pgvector ([vector-databases.md](vector-databases.md)) |
| [LLMOps](llmops.md) | **Langfuse** (traces, evals, prompt mgmt) | Itself a 5-service stack (ClickHouse, Postgres, Redis…) — self-hosting observability has its own ops bill |
| Substrate | **Kubernetes** + Terraform/OpenTofu + Prometheus/Grafana/OpenTelemetry | What makes the whole thing [portable](hybrid-cloud.md) |

## What the research says about doing this well

- **Integration is the product.** Each component is best-in-class; the platform is the glue. Practitioner reports are consistent: picking Kafka + Flink + ClickHouse + Airflow took *a year of engineering to make reliable together*. Budget integration as a first-class workstream, not residue.
- **Adopt by layer, not big-bang.** The common successful path: lakehouse core first (storage + Iceberg + one engine + dbt + orchestrator), then governance, then ML/AI layers — mirroring the [build order](reference-architecture.md).
- **The TCO math**: self-hosted platform stacks land around $50k–200k+/yr in infrastructure plus DevOps time before you count the opportunity cost; per-component maintenance runs ~4–8 h/month (upgrades, patches, incidents) — multiplied by fifteen components. Compare against managed offerings honestly ([finops.md](finops.md), [build-vs-buy.md](build-vs-buy.md)).
- **The 2026 consensus is hybrid consumption**: self-host where control, residency, or steady-state economics win ([hybrid-cloud.md](hybrid-cloud.md)); use the *same vendors' managed versions* (Airbyte Cloud, dbt Cloud, DataHub Cloud, Langfuse Cloud, Preset) where a small team shouldn't own ops. Because it's the same OSS underneath, this choice stays reversible — the whole point.
- **Watch the commercial gravity of "open core"**: single-vendor projects can relicense or merge (dbt+Fivetran being 2026's example); prefer Apache/CNCF-governed projects for the layers you can't easily swap, and demand open standards (Iceberg, OpenLineage, OpenTelemetry, MCP) at every boundary.

## When full-OSS is the right call

Strong fit: platform engineering capacity exists (≥ a small dedicated team), sovereignty or [on-prem](hybrid-cloud.md) requirements, sustained scale where managed margins dominate, or the platform *is* the product. Weak fit: a three-person data team with a backlog — take managed services and revisit at scale ([build-vs-buy.md](build-vs-buy.md) rubric applies per layer).

## Related

- [build-vs-buy.md](build-vs-buy.md)
- [reference-architecture.md](reference-architecture.md)
- [hybrid-cloud.md](hybrid-cloud.md)
