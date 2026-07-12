# Index

Catalog of every page in `pages/`, one line each. Maintained per the workflows in [CLAUDE.md](CLAUDE.md).

## fundamentals

- [What is a data platform?](pages/what-is-a-data-platform.md) — the capability layers, what makes it a platform, and a build order that works.
- [OLTP vs. OLAP](pages/oltp-vs-olap.md) — transactional vs. analytical workloads; why columnar wins and why analytics leaves the production DB.
- [Batch vs. streaming](pages/batch-vs-streaming.md) — the freshness-vs-complexity dial, what genuinely needs streaming, and the convergence.

## storage

- [Data warehouse](pages/data-warehouse.md) — columnar MPP SQL, storage/compute separation, layered layout, operational realities.
- [Data lake](pages/data-lake.md) — everything raw on object storage; zone structure and swamp-avoidance discipline.
- [Lakehouse](pages/lakehouse.md) — warehouse guarantees on open lake storage; what table formats buy and what maintenance they demand.
- [Table & file formats](pages/table-and-file-formats.md) — Parquet and friends; Iceberg/Delta/Hudi; how a table format works; operational duties.

## ingestion-processing

- [Data ingestion](pages/data-ingestion.md) — batch extract, CDC, streaming, connectors; ELT-first; engineering requirements at the platform's front door.
- [Data transformation](pages/data-transformation.md) — transformations-as-code: layered models, tests, CI, incremental processing, pitfalls.
- [Orchestration](pages/orchestration.md) — DAGs, scheduling, backfills; task- vs. asset-centric; design guidance.
- [Stream processing](pages/stream-processing.md) — event logs, windows, watermarks, state; platform integration patterns and honest costs.

## modeling-serving

- [Data modeling](pages/data-modeling.md) — dimensional modeling, OBT, Data Vault; grain, SCDs; modeling for ML and AI consumers.
- [Semantic layer](pages/semantic-layer.md) — metrics defined once as governed code; why it's the prerequisite for AI analytics.
- [Query engines](pages/query-engines.md) — the engine landscape by workload, how engines go fast, choosing without sprawl.

## governance-quality

- [Data governance](pages/data-governance.md) — ownership, classification, access, lifecycle; the regulatory floor; governance for AI consumers.
- [Data catalog & lineage](pages/data-catalog-and-lineage.md) — the searchable inventory and the dependency graph; impact analysis; adoption honesty.
- [Data quality](pages/data-quality.md) — dimensions, defense layers (contracts, tests, observability, incidents), quality for AI consumers.
- [Data security & privacy](pages/data-security-and-privacy.md) — access control granularity, protection, privacy engineering, AI-era attack surfaces.

## ml-platform

- [ML platform overview](pages/ml-platform-overview.md) — the capability map, the golden path, classic ML vs. GenAI on one platform.
- [Feature stores](pages/feature-stores.md) — training/serving skew and point-in-time correctness; offline/online anatomy; do you need one.
- [Model serving](pages/model-serving.md) — batch vs. online vs. streaming serving; deployment safety; LLM serving's harsher physics.
- [MLOps](pages/mlops.md) — versioning code×data×config, evaluation gates, drift monitoring, retraining; CI/CD/CT.

## genai-platform

- [LLMs on the data platform](pages/llms-on-the-platform.md) — the platform team's working model: what LLMs demand from and offer the platform.
- [Embeddings](pages/embeddings.md) — vectors as derived data: lineage, invalidation, deletion, footprint math.
- [Vector databases](pages/vector-databases.md) — ANN indexes, metadata/ACL filtering, deployment options, platform integration.
- [Retrieval-Augmented Generation (RAG)](pages/rag.md) — the two pipelines, quality levers in ROI order, evaluation, failure modes, variants.
- [LLMOps](pages/llmops.md) — the config surface, evaluation with LLM judges, gateway monitoring, prompt management.
- [Agents & MCP](pages/agents-and-mcp.md) — tool use, data-platform agent patterns, MCP as governed integration, safety engineering.

## platform-architecture

- [Reference architecture](pages/reference-architecture.md) — the layered big picture and a build order where each stage funds the next.
- [Data mesh & team topologies](pages/data-mesh.md) — domain ownership, data products, federated governance; when mesh fits and when it doesn't.
- [Build vs. buy](pages/build-vs-buy.md) — layer-by-layer defaults, the model decision, TCO traps, a usable rubric.
- [FinOps for data & AI](pages/finops.md) — visibility → attribution → optimization → accountability; where the money goes; AI token spend.

## reference

- [Glossary](pages/glossary.md) — one-line definitions of ~45 terms, each linking to its full page.
