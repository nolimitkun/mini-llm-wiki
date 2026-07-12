---
title: Build vs. buy
category: platform-architecture
updated: 2026-07-12
---

# Build vs. buy

Every layer of the platform is a build/buy/adopt-OSS decision. The recurring principle: **buy commodity capabilities, build what differentiates you, and keep switching costs low** — the data/AI market shifts fast enough that reversibility is worth real architectural effort.

## Layer-by-layer defaults

| Layer | Default | Reasoning |
|---|---|---|
| [Ingestion](data-ingestion.md) connectors | **Buy/OSS** (Fivetran, Airbyte) | SaaS API churn makes homegrown connectors a maintenance tarpit; build only proprietary-source ones |
| [Storage](lakehouse.md) | Cloud object storage + **open table formats** | Openness *is* the exit strategy; the catalog is where lock-in now lives — negotiate it consciously |
| [Transformation](data-transformation.md) | **OSS framework** (dbt-class) | Your models are yours; the framework is commodity |
| [Orchestration](orchestration.md) | **OSS/managed** (Airflow/Dagster-class) | Building a scheduler is a rite of passage nobody should complete |
| [Catalog/governance](data-catalog-and-lineage.md) | Buy or OSS; demand **OpenLineage** export | Value is in adoption, not code; metadata must outlive the vendor |
| [ML platform](ml-platform-overview.md) | Managed suite early; compose as needs sharpen | Suites integrate; composition avoids ceiling-lock |
| BI / horizontal AI apps | **Buy** | Vendors iterate faster than you on generic surfaces |
| Your data products, models, [semantic layer](semantic-layer.md) definitions, domain AI apps | **Build** | This is the differentiation the rest exists to serve |

## The GenAI-specific decision: models

- **Default: provider APIs** behind a gateway — zero infra, frontier quality, usage-based cost.
- **Middle path** (most regulated enterprises): cloud-managed models in your VPC (Bedrock/Vertex/Azure) — provider ops, tighter data boundary ([data-governance.md](data-governance.md)).
- **Self-host open weights** only for: residency rules APIs can't meet, sustained high-volume narrow tasks where the GPU math genuinely wins, or latency requiring co-location — and price in the ops ([model-serving.md](model-serving.md)). Placement across private/public infrastructure is its own decision — [hybrid-cloud.md](hybrid-cloud.md).
- Keep it reversible: the gateway abstracts providers; quality-per-dollar rankings change quarterly.

## The TCO traps (what "build" spreadsheets omit)

- Maintenance is 3–5× initial build over five years; the builder's promotion is not transferable to the maintainer's motivation.
- Integration cost: a "cheaper" tool that fights your stack costs the difference in glue.
- Utilization reality: self-hosted GPU math at 80% utilization, actual 20–40%.
- Ongoing evaluation/curation for AI systems (eval sets, corpus maintenance) — never one-time.
- Exit cost: price the *leaving*, not just the entering — data egress, rewrite scope, retraining.

## A usable rubric

Build only if **all four**: (1) core to differentiation, (2) no adequate product exists, (3) you'll fund maintenance indefinitely, (4) you'd hire for it anyway. Otherwise buy/adopt — and spend the saved engineering on your data models, which no vendor can sell you.

"Adopt OSS" is its own full option: every platform layer has a production-grade open source implementation — the complete stack, its TCO reality, and when full-OSS is the right call are laid out in [open-source-data-ai-platform.md](open-source-data-ai-platform.md).

## Related

- [reference-architecture.md](reference-architecture.md)
- [finops.md](finops.md)
- [llms-on-the-platform.md](llms-on-the-platform.md)
