---
title: FinOps for data & AI
category: platform-architecture
updated: 2026-07-12
---

# FinOps for data & AI

Cloud data platforms replaced capacity limits with **spend limits you discover afterward**: elastic compute means any analyst, pipeline, or agent can spend unboundedly. FinOps is the practice loop — **visibility → attribution → optimization → accountability** — applied to a domain where the top line item is usually queries nobody remembers writing.

## Visibility & attribution first

Unattributed spend can't be optimized. Tag/label everything (team, pipeline, environment); use warehouse query metering and object-storage inventory; build the **unit-economics view** — cost per pipeline run, per dashboard, per model training, per 1k AI requests. The forcing function: a monthly per-team cost report that team leads actually see.

## Where data platform money goes (and the standard fixes)

| Sink | Fix |
|---|---|
| **Idle/oversized compute** | Auto-suspend warehouses, right-size clusters, spot for fault-tolerant batch |
| **Wasteful queries** | `SELECT *` on wide tables, missing partition filters, dashboards refreshing hourly for daily viewers — query hygiene reviews on the top-20 by cost ([query-engines.md](query-engines.md)) |
| **Full rebuilds of big tables** | Incremental models ([data-transformation.md](data-transformation.md)) |
| **Storage hoarding** | Lifecycle tiering, snapshot/time-travel expiry ([table-and-file-formats.md](table-and-file-formats.md)), delete the staging copies from 2023 |
| **Streaming that could be batch** | Re-ask the freshness question ([batch-vs-streaming.md](batch-vs-streaming.md)) |
| **Zombie pipelines** | Feed nothing anyone reads — [lineage](data-catalog-and-lineage.md) finds them; deprecate ruthlessly |

## AI spend: a different animal

Token-based costs scale with **usage × verbosity**, not instances — a demo-cheap feature becomes ruinous at traffic:

- **Meter at the gateway**: tokens and cost per app/feature/user; budgets with hard caps; anomaly alerts — runaway [agent loops](agents-and-mcp.md) and retry storms show up here first ([llmops.md](llmops.md)).
- **Right-size the model per task** — the 10–100× lever: route easy tasks (classification, extraction) to small cheap models, save frontier models for hard reasoning.
- **Cache**: provider prompt-caching for repeated prefixes (structure prompts static-first); response caching for repeated queries.
- **Trim tokens**: fewer, better-reranked [RAG](rag.md) chunks; capped outputs; compact formats.
- **Batch APIs** (~50% off) for async pipeline work; GPU training/serving gets classic utilization discipline ([model-serving.md](model-serving.md)).

## Accountability that works

Showback → chargeback as maturity grows; budgets with alerts at 80%; cost review in the same ritual as reliability review; **cost as a design input** ("what does this cost per month at 10× traffic?") in data and AI design docs alike. Efficiency is a platform feature: paved roads should be the cheap path by default ([what-is-a-data-platform.md](what-is-a-data-platform.md)).

## Related

- [query-engines.md](query-engines.md)
- [llmops.md](llmops.md)
- [build-vs-buy.md](build-vs-buy.md)
