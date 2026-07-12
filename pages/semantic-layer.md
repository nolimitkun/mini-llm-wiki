---
title: Semantic layer
category: modeling-serving
updated: 2026-07-12
---

# Semantic layer

A **semantic layer** defines business concepts — metrics, dimensions, entities — *once*, as governed code, and serves them to every consumer: BI tools, notebooks, APIs, and AI. It exists because of a universal failure: "revenue" computed four ways in four dashboards, and a leadership meeting derailed by reconciling them.

## What it contains

```yaml
metric: monthly_recurring_revenue
description: Sum of active subscription amounts, normalized to monthly
model: fact_subscriptions          # built in [data-transformation.md](data-transformation.md)
calculation: SUM(amount_monthly)
filters: status = 'active'
dimensions: [customer_segment, plan, region]
time_grain: [day, month, quarter]
owner: finance-data
```

Consumers ask for *the metric by dimensions*; the layer compiles correct SQL against the [warehouse](data-warehouse.md)/[lakehouse](lakehouse.md). Implementations: dbt Semantic Layer/MetricFlow, Cube, Looker's LookML lineage, AtScale.

## Why it's suddenly strategic: AI consumers

Text-to-SQL against raw schemas is where "chat with your data" projects go to die — the model guesses at joins, filters, and business rules and produces confident, wrong numbers. Pointing the AI at a **semantic layer** instead changes the question from "write correct SQL over 400 tables" to "pick the right governed metric and dimensions" — massively more constrained, auditable, and correct. If your roadmap includes analytics [agents](agents-and-mcp.md) (e.g., exposed via an [MCP server](agents-and-mcp.md)), the semantic layer is the prerequisite investment.

## Design & adoption guidance

- **Start with the contested metrics**: the ones that already caused a reconciliation meeting. Ten well-governed metrics beat three hundred stubs.
- **Metrics are code**: version control, review, tests (does MRR match finance's number?), ownership in the definition ([data-governance.md](data-governance.md)).
- **One definition, many surfaces**: value collapses if the BI tool keeps its own parallel metric definitions — pick tools that consume the layer, or accept you're just adding a fifth version of revenue.
- **Publish to the [catalog](data-catalog-and-lineage.md)**: metric definitions are the documentation analysts (and LLMs) actually need.
- **Mind query performance**: the layer compiles SQL; pre-aggregations/caching for hot metric-dimension combinations keep dashboards interactive.

## Failure modes

- Semantic layer as shelfware: built, not wired into the tools people use.
- Definitions without owners — a governance problem wearing a technology costume.
- Trying to model *everything* up front instead of following real usage.

## Related

- [data-modeling.md](data-modeling.md)
- [llms-on-the-platform.md](llms-on-the-platform.md)
- [data-catalog-and-lineage.md](data-catalog-and-lineage.md)
