# Research notes: open source project comparisons by layer (July 2026)

Raw web-research refresh and synthesis notes gathered 2026-07-13 for page-level OSS project comparison sections across storage, ingestion/processing, modeling/serving, governance/quality, ML platform, and GenAI platform pages.

## Storage and query

- Apache Iceberg, Delta Lake, and Apache Hudi remain the three major open lakehouse table formats. Iceberg is the neutral multi-engine default; Delta remains strongest in Databricks/Spark estates; Hudi is most distinctive for CDC/upsert-heavy pipelines.
  - https://iceberg.apache.org/
  - https://delta.io/
  - https://hudi.apache.org/
  - https://arxiv.org/abs/2604.21449
- MinIO and Ceph are the main self-hosted object-storage choices for data lakes; MinIO optimizes for S3-compatible object storage simplicity, while Ceph is broader object/block/file infrastructure.
  - https://min.io/
  - https://ceph.io/
- Trino, Spark, DuckDB, and ClickHouse occupy distinct open query-engine niches: federated SQL, distributed batch/ML prep, embedded/local analytics, and real-time OLAP.
  - https://trino.io/
  - https://spark.apache.org/
  - https://duckdb.org/
  - https://clickhouse.com/

## Ingestion, processing, and orchestration

- Airbyte is the broad connector platform; dlt is Python-native ELT; Debezium is the CDC primitive; Meltano/Singer, Sling, and ingestr are lighter connector/replication options.
  - https://airbyte.com/
  - https://dlthub.com/
  - https://debezium.io/
  - https://meltano.com/
  - https://slingdata.io/
  - https://github.com/bruin-data/ingestr
- dbt-core remains the SQL transformation default, with SQLMesh as the strongest open challenger around environments and incremental planning. Spark and Flink remain necessary for heavy batch and continuous streaming transformations.
  - https://www.getdbt.com/product/what-is-dbt
  - https://sqlmesh.com/
  - https://spark.apache.org/
  - https://flink.apache.org/
- Airflow remains the incumbent orchestrator; Dagster is strongest for asset-centric data platforms; Prefect is a Python-first workflow option; Argo and Temporal fit adjacent execution/workflow needs.
  - https://airflow.apache.org/
  - https://dagster.io/
  - https://www.prefect.io/
  - https://argoproj.github.io/workflows/
  - https://temporal.io/
- Kafka plus Flink remains the most common OSS streaming backbone. Redpanda offers Kafka-compatible operations, Pulsar offers multi-tenant messaging architecture, and Spark Structured Streaming fits Spark-standardized teams.
  - https://kafka.apache.org/
  - https://flink.apache.org/
  - https://www.redpanda.com/
  - https://pulsar.apache.org/

## Modeling, governance, and quality

- dbt-core, SQLMesh, OpenMetadata/DataHub, and semantic-layer projects shape how data models are expressed, published, and reused.
  - https://www.getdbt.com/
  - https://sqlmesh.com/
  - https://open-metadata.org/
  - https://datahubproject.io/
- Cube Core, MetricFlow/dbt Semantic Layer, and Lightdash are the main open semantic-layer paths for governed metrics.
  - https://cube.dev/
  - https://docs.getdbt.com/docs/build/about-metricflow
  - https://www.lightdash.com/
- OpenMetadata and DataHub are the broad OSS catalog choices; OpenLineage is the exchange standard, with Marquez as a lineage-focused implementation.
  - https://open-metadata.org/
  - https://datahubproject.io/
  - https://openlineage.io/
  - https://marquezproject.ai/
- Great Expectations, Soda Core, dbt tests/dbt-expectations, Deequ, and catalog-integrated quality checks cover different parts of the data-quality stack.
  - https://greatexpectations.io/
  - https://www.soda.io/core
  - https://hub.getdbt.com/calogica/dbt_expectations/latest/
  - https://github.com/awslabs/deequ
- OPA, Apache Ranger, Keycloak, Vault/OpenBao, and engine-level controls form the open-source security/privacy toolbox.
  - https://www.openpolicyagent.org/
  - https://ranger.apache.org/
  - https://www.keycloak.org/
  - https://www.vaultproject.io/
  - https://openbao.org/

## ML and GenAI

- MLflow, Kubeflow, Ray, Metaflow, and Feast cover experiment tracking/registry, Kubernetes-native ML, distributed compute, ML workflows, and feature stores respectively.
  - https://mlflow.org/
  - https://www.kubeflow.org/
  - https://www.ray.io/
  - https://metaflow.org/
  - https://feast.dev/
- KServe, Seldon Core, BentoML, Ray Serve, MLflow model serving, vLLM, SGLang, and Hugging Face TGI occupy different classic-ML and LLM serving niches.
  - https://kserve.github.io/website/
  - https://www.seldon.io/
  - https://www.bentoml.com/
  - https://docs.ray.io/en/latest/serve/
  - https://docs.vllm.ai/
  - https://github.com/sgl-project/sglang
  - https://github.com/huggingface/text-generation-inference
- Langfuse, Phoenix/OpenInference, MLflow tracing, LiteLLM, DeepEval, Ragas, promptfoo, and OpenTelemetry cover LLM tracing, gateways, evals, and observability standards.
  - https://langfuse.com/
  - https://phoenix.arize.com/
  - https://github.com/Arize-ai/openinference
  - https://www.litellm.ai/
  - https://github.com/confident-ai/deepeval
  - https://github.com/explodinggradients/ragas
  - https://www.promptfoo.dev/
  - https://opentelemetry.io/
- pgvector, Qdrant, Milvus, Weaviate, OpenSearch k-NN, LanceDB, FAISS, and hnswlib are the open vector-search paths from extension to dedicated distributed engine to embedded library.
  - https://github.com/pgvector/pgvector
  - https://qdrant.tech/
  - https://milvus.io/
  - https://weaviate.io/
  - https://opensearch.org/docs/latest/vector-search/
  - https://lancedb.com/
  - https://github.com/facebookresearch/faiss
  - https://github.com/nmslib/hnswlib
- LlamaIndex, LangChain, Haystack, LangGraph, Unstructured, Docling, Tika, and reranking libraries support RAG assembly, parsing, retrieval, and agentic workflows.
  - https://www.llamaindex.ai/
  - https://www.langchain.com/
  - https://haystack.deepset.ai/
  - https://www.langchain.com/langgraph
  - https://unstructured.io/
  - https://github.com/docling-project/docling
  - https://tika.apache.org/
- MCP is the open integration standard for tools/resources/prompts; LangGraph, AutoGen, CrewAI, LlamaIndex/LangChain agents, OpenHands, and SWE-agent-style systems represent common open agent frameworks/patterns.
  - https://modelcontextprotocol.io/
  - https://microsoft.github.io/autogen/
  - https://www.crewai.com/open-source
  - https://github.com/All-Hands-AI/OpenHands
  - https://github.com/SWE-agent/SWE-agent
