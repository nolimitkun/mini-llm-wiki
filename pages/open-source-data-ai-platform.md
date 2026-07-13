---
title: Building a data/AI platform from open source
category: platform-architecture
updated: 2026-07-13
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

## Open source project comparisons by layer

| Layer | Compare | Practical read |
|---|---|---|
| Object storage | **MinIO** vs Ceph vs cloud object store | MinIO is the simplest S3-compatible default for platform teams that want object storage without becoming storage-system specialists. Ceph is broader and heavier when you also need block/file storage. Cloud object stores are operationally easiest but are not fully self-hosted. |
| [Table format](table-and-file-formats.md) | **Iceberg** vs Delta Lake vs Hudi | Iceberg is the neutral default for multi-engine lakehouses and open catalog interoperability. Delta is strongest in Databricks-centered estates and has the largest installed base. Hudi remains relevant for upsert-heavy lake ingestion, but has less mindshare as the general-purpose interchange. |
| Catalog | **Polaris** vs Nessie vs Lakekeeper vs Hive Metastore | Polaris and Lakekeeper fit Iceberg-native catalog control planes. Nessie adds Git-like branching and versioned table references. Hive Metastore is familiar legacy glue, but is a weak strategic control plane for new lakehouses. |
| [Query engines](query-engines.md) | **Trino** vs Spark vs DuckDB vs ClickHouse | Trino is the interactive federated SQL default. Spark wins for heavy distributed batch and ML-adjacent jobs. DuckDB is ideal for local/dev/small-data analytics. ClickHouse is the real-time OLAP specialist when subsecond serving matters. |
| [Ingestion](data-ingestion.md) | **Airbyte** vs dlt vs Debezium vs Meltano/Sling/ingestr | Airbyte gives the broadest connector catalog. dlt is lighter and more Python-native for code-owned ELT. Debezium is the CDC primitive for database logs, often under Airbyte or Kafka Connect. Meltano/Sling/ingestr fit simpler, developer-owned pipelines. |
| [Streaming](stream-processing.md) | **Kafka + Flink** vs Redpanda vs Pulsar vs Spark Structured Streaming | Kafka + Flink is the most proven high-scale open streaming pair. Redpanda simplifies Kafka-compatible operations. Pulsar is strong for multi-tenant messaging but adds ecosystem complexity. Spark Structured Streaming fits teams already standardized on Spark. |
| [Transformation](data-transformation.md) | **dbt-core** vs SQLMesh vs Dataform-style code | dbt-core remains the standard for SQL transformations, tests, docs, and hiring. SQLMesh is stronger when stateful planning, environments, and incremental correctness are central. Code-first approaches fit teams that need general programming more than analytics engineering conventions. |
| [Orchestration](orchestration.md) | **Airflow** vs Dagster vs Prefect | Airflow is the incumbent with the largest ecosystem and operator base. Dagster is cleaner for asset-centric data products and lineage-aware development. Prefect is ergonomic for Python workflow automation, especially outside classic warehouse pipelines. |
| [Semantic layer](semantic-layer.md) | **Cube Core** vs MetricFlow vs Lightdash metrics | Cube is strongest when one semantic API must serve BI, embedded analytics, and AI agents. MetricFlow fits dbt-centered teams that want metrics beside models. Lightdash metrics are pragmatic when the BI surface and semantic layer are intentionally coupled. |
| [Catalog & lineage](data-catalog-and-lineage.md) | **OpenMetadata** vs DataHub vs OpenLineage/Marquez | OpenMetadata is the broad catalog/governance default with an active community. DataHub is strong for graph metadata, streaming metadata, and API-driven platform integration. OpenLineage/Marquez is the thinner lineage standard path when you do not need a full catalog. |
| BI | **Superset** vs Metabase vs Lightdash | Superset is the most extensible OSS BI platform for SQL-heavy teams. Metabase is the fastest path for simple self-service analytics. Lightdash is best when dbt models and metrics should directly define the BI experience. |
| [ML platform](ml-platform-overview.md) | **MLflow** vs Kubeflow vs Ray vs Feast | MLflow is the pragmatic tracking/registry default and now overlaps with LLM gateways and tracing. Kubeflow is a Kubernetes-native ML platform, but operationally heavy. Ray is the distributed compute/training substrate. Feast is the feature store, not a full ML platform. |
| [GenAI serving](llms-on-the-platform.md) | **vLLM** vs Ollama vs LiteLLM vs Text Generation Inference | vLLM is the default for high-throughput GPU serving. Ollama is excellent for local development and small self-hosted deployments. LiteLLM is the gateway/router across model providers, not the model server itself. TGI remains a solid Hugging Face-centered serving choice. |
| Vectors / [RAG](rag.md) | **pgvector** vs Qdrant vs Milvus vs Weaviate | pgvector is the best starting point when Postgres already exists and scale is moderate. Qdrant is a strong purpose-built vector store with simpler ops than the largest systems. Milvus fits very large vector workloads. Weaviate adds higher-level search/application features. |
| [LLMOps](llmops.md) | **Langfuse** vs MLflow tracing vs OpenTelemetry-first | Langfuse is the most complete OSS LLM observability/product loop for traces, evals, prompts, and datasets. MLflow tracing fits teams already standardizing on MLflow. OpenTelemetry-first designs maximize standardization, but require more product-specific assembly. |
| Substrate | **Kubernetes** vs Docker Compose vs Nomad; Terraform vs OpenTofu | Kubernetes is the portability and managed-service compatibility default for production. Docker Compose is fine for prototypes and tiny deployments. Nomad can be simpler for some infra teams but has less data/AI ecosystem gravity. OpenTofu is the OSS infrastructure-as-code default where Terraform licensing matters. |

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
