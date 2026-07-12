---
title: Reference architecture
category: platform-architecture
updated: 2026-07-12
---

# Reference architecture

A composable architecture for a modern data/AI platform. Layers are independent — adopt incrementally, and treat every box as swappable behind its interface ([build-vs-buy.md](build-vs-buy.md)).

## The big picture

```
┌────────────────────────── consumers ───────────────────────────┐
│ BI & dashboards │ notebooks │ data apps │ ML models │ AI agents │
└──────┬──────────────┬─────────────────┬──────────────┬─────────┘
       │              │                 │              │
┌──────▼──────────────▼─────┐  ┌────────▼──────────────▼────────┐
│ SERVING & SEMANTICS       │  │ ML / GENAI LAYER               │
│ semantic layer, marts,    │  │ feature store, training, model │
│ query engines, real-time  │  │ registry & serving, LLM        │
│ OLAP, data APIs           │  │ gateway, RAG/vector indexes    │
└──────┬────────────────────┘  └────────┬───────────────────────┘
       │                                │
┌──────▼────────────────────────────────▼───────────────────────┐
│ PROCESSING          transformations-as-code, batch & stream,  │
│                     orchestration                             │
├────────────────────────────────────────────────────────────────┤
│ STORAGE             lakehouse: object storage + open table    │
│                     formats + catalog (warehouse as engine)   │
├────────────────────────────────────────────────────────────────┤
│ INGESTION           CDC, connectors, event streams, files     │
└────────────────────────────────────────────────────────────────┘
┌────────────────────────────────────────────────────────────────┐
│ CROSS-CUTTING: catalog & lineage · governance & access ·      │
│ quality & observability · security · FinOps                   │
└────────────────────────────────────────────────────────────────┘
```

## Layer notes

- **Ingestion**: [CDC + connectors + streams](data-ingestion.md), landing raw into table-format tables from day one.
- **Storage**: the [lakehouse](lakehouse.md) as the center of gravity — open [table formats](table-and-file-formats.md) on object storage; a [warehouse](data-warehouse.md) engine where price/performance earns it. The **catalog is the control point** — choose it as deliberately as the storage itself.
- **Processing**: [transformations-as-code](data-transformation.md) with tests, [streaming](stream-processing.md) where freshness demands, all on one [orchestrator](orchestration.md).
- **Serving & semantics**: [modeled marts](data-modeling.md), a [semantic layer](semantic-layer.md) as the single definition of metrics (and the AI-readiness investment), [engines](query-engines.md) matched to workload.
- **ML/GenAI**: [feature store](feature-stores.md) and [model serving](model-serving.md) on the shared spine; an **LLM gateway** (auth, quotas, routing, caching, logging) as single egress for model traffic; [RAG indexes](rag.md) as derived, rebuildable stores; platform data exposed to agents via [MCP](agents-and-mcp.md).
- **Cross-cutting**: [catalog/lineage](data-catalog-and-lineage.md), [governance](data-governance.md), [quality](data-quality.md), [security](data-security-and-privacy.md), [FinOps](finops.md) — these are what make it a platform rather than a tool pile.

## Build order

1. **The analytics spine**: ingestion → lakehouse → tested transformations → BI. Boring excellence here funds everything else.
2. **Cross-cutting basics**: catalog with owners, quality tests on tier-1, access control model.
3. **ML capabilities** as use cases mature (registry, serving, features).
4. **GenAI layer**: gateway first (control + visibility), then one RAG use case end-to-end with evaluation, then agents via MCP with least-privilege tooling.

Each stage reuses the previous — a GenAI initiative on a weak data foundation just discovers the foundation's problems at higher speed and cost.

## Related

- [what-is-a-data-platform.md](what-is-a-data-platform.md)
- [lakehouse.md](lakehouse.md)
- [build-vs-buy.md](build-vs-buy.md)
