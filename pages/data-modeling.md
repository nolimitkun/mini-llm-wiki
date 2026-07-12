---
title: Data modeling
category: modeling-serving
updated: 2026-07-12
---

# Data modeling

**Data modeling** is deciding what tables exist, what grain they're at, and how they relate — the difference between a platform where questions take one join and one where every query is archaeology. Storage got cheap; *reasoning* about data didn't. Modeling is how you spend compute to buy comprehension.

## Dimensional modeling (still the workhorse)

Kimball's star schema remains the default for analytics marts:

```
            dim_customer      dim_product
                  \               /
                   fact_orders          ← one row per order line (the "grain")
                  /               \
            dim_date            dim_store
```

- **Facts**: measurable events at a declared grain (order lines, page views, payments). *State the grain in the table description; defend it in tests.*
- **Dimensions**: the who/what/where/when context, denormalized for easy filtering and grouping.
- **Slowly changing dimensions (SCD)**: how history is kept when attributes change — Type 1 overwrite (current-state only) vs Type 2 versioned rows (as-was analysis). Choosing wrong quietly rewrites history in reports.
- **Conformed dimensions**: shared dims (customer, date) across marts are what make cross-domain analysis line up.

## The other approaches, and when they earn their place

| Approach | Idea | When |
|---|---|---|
| **One Big Table (OBT)** | Pre-join everything into a wide denormalized table | Small teams, columnar engines make it fast; fine until metric/dimension reuse and consistency demand structure |
| **Data Vault** | Hubs/links/satellites; insert-only, audit-friendly integration layer | Large enterprises, many volatile sources, compliance-heavy; heavy machinery — don't cargo-cult it |
| **Normalized (3NF) core** | Warehouse integration layer in near-3NF, marts on top | Classic Inmon; survives in regulated industries |

Pragmatic default: **staging → core with clear entities → dimensional (or OBT) marts**, built as [transformations-as-code](data-transformation.md) with tested assumptions.

## Modeling for the platform's newer consumers

- **ML**: point-in-time correctness — training joins must only see data as-of the label's timestamp (the [feature store](feature-stores.md) problem). SCD2-style history makes this possible; current-state-only tables silently leak the future.
- **GenAI/agents**: an [LLM writing SQL](llms-on-the-platform.md) is the ultimate naive consumer — it needs obvious names, documented columns, declared relationships, and a [semantic layer](semantic-layer.md) far more than a human analyst does. Clean modeling has become an AI-readiness investment.
- **Real-time**: streaming sinks favor wide, pre-joined shapes; model the enrichment in the [stream](stream-processing.md) or accept lookup latency.

## Related

- [semantic-layer.md](semantic-layer.md)
- [data-transformation.md](data-transformation.md)
- [data-warehouse.md](data-warehouse.md)
