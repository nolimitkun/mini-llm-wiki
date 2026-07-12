# Research notes: building a data/AI platform from open source (July 2026)

Raw web-research findings gathered 2026-07-12 for the wiki page on open-source data/AI platform stacks. Immutable per sources/ rules.

## Lakehouse core (storage + table format + engines)

- The dominant OSS lakehouse pattern: **MinIO (S3-compatible) + Apache Iceberg + Trino + dbt + Airflow**, with Flink for streaming writes and Nessie/Polaris-class catalogs adding Git-like version control. Widely documented as reproducible reference stacks, including laptop-scale tutorials.
  - https://blog.dataengineerthings.org/build-a-lakehouse-on-a-laptop-with-dbt-airflow-trino-iceberg-and-minio-0700540a183d
  - https://medium.com/yapi-kredi-teknoloji/building-a-real-time-open-data-lake-architecture-with-flink-iceberg-nessie-dbt-trino-and-36c32abae1cd
  - https://www.thelitehouse.io/post/building-an-open-data-platform-on-premise-with-open-source-tools
- Iceberg momentum: Format V3 shipped; adoption surveys show ~78% exclusive usage among respondents; every major engine/cloud treats Iceberg as default interchange. Delta Lake retains the largest installed base (Databricks); the two together cover the vast majority of production lakehouse tables.
  - https://dev.to/alexmercedcoder/the-2025-2026-ultimate-guide-to-the-data-lakehouse-and-the-data-lakehouse-ecosystem-dig
- Multiple engines (Spark, Trino, ClickHouse, Dremio, DuckDB) can read the same Iceberg tables from the same catalog without migration — the "open lakehouse" claim is real in 2026.
  - https://www.databricks.com/blog/what-open-lakehouse-open-data-standards-explained
- Spark remains the most widely adopted large-scale engine (~80% of Fortune 500). Kafka + Flink remain the streaming backbone; Confluent Tableflow-class products now write Kafka topics directly to Iceberg/Delta with exactly-once, reducing custom streaming jobs.
- Practitioner caution: "chose Kafka, Flink, ClickHouse, Airflow because each was best in class — spent a year making them work together reliably." Most teams adopt OSS by layer and move latency-critical serving to managed offerings to avoid integration drag.

## Ingestion & transformation

- OSS ingestion landscape: **Airbyte** (350+ connectors, embeds Debezium for CDC), **dlt** (pip-install Python ELT, schema inference/evolution), **Sling/Meltano/ingestr**; **Debezium** as the log-based CDC standard, usually via Kafka Connect.
  - https://airbyte.com/top-etl-tools-for-sources/open-source-data-ingestion-tools
  - https://www.automq.com/blog/debezium-vs-airbyte-open-source-data-integration
  - https://getbruin.com/blog/best-data-ingestion-tools-2026/
- Transformation: dbt-core remains the standard; SQLMesh as the challenger. Notable 2026 consolidation: **dbt Labs + Fivetran merger** — one entity controls ingestion (Fivetran), transformation (dbt), and semantic layer (MetricFlow); relevant to OSS-vs-vendor risk assessment.
  - https://getbruin.com/blog/dlt-alternatives/

## Semantic layer

- OSS options: **Cube Core** (agentic analytics positioning: one governed model for BI + embedded + AI agents) and **MetricFlow** (dbt Semantic Layer; metrics-as-YAML beside models; most widely adopted vendor-neutral approach).
  - https://cube.dev/articles/best-semantic-layer-for-ai-and-bi-2026
  - https://www.typedef.ai/resources/semantic-layer-architectures-explained-warehouse-native-vs-dbt-vs-cube

## Catalog, lineage, governance

- **OpenMetadata**: most active OSS catalog community in 2026; schema-first unified platform (catalog + governance + quality + lineage). **DataHub Core**: graph-based metadata model, Kafka-streamed real-time metadata, strong GraphQL API; DataHub Cloud is the more mature commercial path.
  - https://atlan.com/openmetadata-vs-datahub/
  - https://dataworkers.io/resources/open-source-data-catalog/
- **OpenLineage** is the exchange standard for lineage events; **Marquez** its reference implementation — fits teams on Airflow/Spark/dbt needing lineage without a full catalog; pair with DataHub/OpenMetadata for discovery/glossary/governance.
  - https://datahub.com/blog/open-source-data-lineage/

## AI/ML layer

- Self-hosted GenAI stack pattern: **vLLM** (GPU serving at scale) or **Ollama** (local/light), **LiteLLM** as gateway, **Qdrant or pgvector** for vectors, **LangGraph/LlamaIndex** frameworks, **Langfuse** for observability (traces, evals, prompt mgmt; requires ClickHouse+Postgres+Redis — 5+ services self-hosted), **MLflow** expanding into LLM territory (AI gateway, agent tracing, prompt mgmt) on top of classic experiment tracking + registry.
  - https://github.com/langfuse/langfuse
  - https://pyimagesearch.com/2026/05/18/llm-observability-with-self-hosted-langfuse-and-vllm/
  - https://mlflow.org/langfuse-alternative/
  - https://futureagi.com/blog/open-source-stack-ai-agents-2025/
- Smallest credible agent deployment: single Linux box, Docker Compose — framework runtime + Postgres + Redis + Qdrant + Langfuse + MCP gateway; suitable to ~10 concurrent agents.
  - https://www.knowlee.ai/blog/open-source-ai-workforce-platforms-2026
- Classic ML: MLflow (tracking/registry), Feast (feature store), Kubeflow/Ray (training on K8s).

## Cost reality (OSS ≠ free)

- "Open source moves cost rather than removing it: license fees traded for engineering time, infrastructure, operational ownership."
- Data-platform self-hosted TCO estimates: $50k–200k+/yr including infra, DevOps headcount share, monitoring, maintenance opportunity cost. Rule-of-thumb per-app maintenance: 4–8 h/month (updates, monitoring, incidents, patching) — multiplied across every stack component.
  - https://estuary.dev/blog/open-source-data-analytics-tools/
  - https://massivegrid.com/blog/true-cost-of-self-hosting/
- 2026 consensus pattern: hybrid — OSS self-hosted for analytics/regulated/steady workloads, managed versions (often by the same vendors: dbt Cloud, Preset, Airbyte Cloud, DataHub Cloud, Langfuse Cloud) for customer-facing/latency-critical or when team is small.
  - https://upcloud.com/global/blog/self-hosted-vs-managed-databases-2026-guide/
