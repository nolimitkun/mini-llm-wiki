---
title: What is a data platform?
category: fundamentals
updated: 2026-07-12
---

# What is a data platform?

A **data platform** is the integrated set of systems an organization uses to ingest, store, process, govern, and serve data — turning raw operational exhaust into analytics, machine learning, and AI products. It's a *platform* in the product sense: a shared foundation with self-service interfaces, so data producers and consumers don't rebuild plumbing per project.

## The core capabilities

Every data platform, whatever the vendor mix, provides these layers:

| Layer | Job | Pages |
|---|---|---|
| **Ingestion** | Move data in from operational systems, SaaS, events | [data-ingestion.md](data-ingestion.md), [stream-processing.md](stream-processing.md) |
| **Storage** | Durable, queryable, cost-tiered storage | [data-warehouse.md](data-warehouse.md), [data-lake.md](data-lake.md), [lakehouse.md](lakehouse.md) |
| **Processing** | Transform raw → refined, batch and streaming | [data-transformation.md](data-transformation.md), [query-engines.md](query-engines.md) |
| **Orchestration** | Schedule, sequence, retry, observe pipelines | [orchestration.md](orchestration.md) |
| **Modeling & serving** | Consumable shapes: marts, metrics, APIs | [data-modeling.md](data-modeling.md), [semantic-layer.md](semantic-layer.md) |
| **Governance** | Catalog, lineage, quality, access control | [data-governance.md](data-governance.md), [data-catalog-and-lineage.md](data-catalog-and-lineage.md) |
| **ML & AI** | Features, training, model & LLM serving | [ml-platform-overview.md](ml-platform-overview.md), [llms-on-the-platform.md](llms-on-the-platform.md) |

## What makes it a *platform* (not a pile of tools)

- **Self-service**: teams onboard a new source or dashboard without filing a ticket to a central team.
- **Paved roads**: opinionated defaults (one orchestrator, one transformation framework, golden-path templates) with escape hatches.
- **Shared contracts**: schemas, SLAs, and ownership are explicit at team boundaries — see [data-mesh.md](data-mesh.md).
- **Cost & operability built in**: observability, [FinOps](finops.md), and [security](data-security-and-privacy.md) are platform features, not per-team afterthoughts.

## The consumers keep multiplying

Historically the platform served **BI** (dashboards, reports). Then **data science and ML** (training sets, [feature stores](feature-stores.md)). Now **AI applications** ([RAG](rag.md), [agents](agents-and-mcp.md)) consume the platform directly at runtime — which raises the bar on freshness, quality, and access control, because a bad row is no longer a wrong chart but a wrong automated action.

## Build order that works

1. Reliable ingestion + one storage layer + orchestrated transformations (the analytics spine).
2. Governance basics: catalog, ownership, [quality checks](data-quality.md) on tier-1 datasets.
3. ML platform capabilities as model use cases mature.
4. GenAI layer on top — it reuses everything below ([reference-architecture.md](reference-architecture.md)).

## Related

- [reference-architecture.md](reference-architecture.md)
- [oltp-vs-olap.md](oltp-vs-olap.md)
- [data-mesh.md](data-mesh.md)
