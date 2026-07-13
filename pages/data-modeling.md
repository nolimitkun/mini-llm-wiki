---
title: Data modeling
category: modeling-serving
updated: 2026-07-13
sources: [sources/2026-07-open-source-project-comparisons.md, sources/2026-07-commercial-product-comparisons.md]
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

## Open source project comparison

Modeling is a practice more than a product, but OSS tools shape how models are expressed, tested, and reused.

| Project / approach | Best fit | Watch-outs |
|---|---|---|
| **dbt-core** | Dimensional marts, documented SQL models, tests, exposures, and downstream lineage | It will not design grains or metrics for you; bad models become neatly documented bad models |
| **SQLMesh** | Model evolution with stronger environment and incremental planning semantics | Smaller community; most useful when model lifecycle complexity is already painful |
| **OpenMetadata / DataHub** | Publishing model ownership, descriptions, lineage, and usage signals | Catalog metadata must be wired into workflow or it decays |
| **MetricFlow / Cube / Lightdash metrics** | Turning modeled tables into governed metrics for humans and agents | Semantic layers expose modeling mistakes quickly; fix grains and relationships first |

Use dbt/SQLMesh to encode the physical model, a catalog to make it discoverable, and a semantic layer only after the core grains are defensible.

## Commercial product comparison

| Product | Modeling role | Watch-outs |
|---|---|---|
| **dbt Cloud** | Collaborative SQL modeling, docs, exposures, semantic-layer path | Still depends on good grains, owners, and tests; it will not fix conceptual modeling |
| **Coalesce** | Visual modeling and transformation patterns for Snowflake teams | Strong productivity for Snowflake estates; less portable as a general modeling layer |
| **Erwin / ER/Studio / SqlDBM** | Enterprise logical/physical data modeling and documentation | Useful for governance-heavy teams; can become detached from executable transformation code |
| **Atlan / Alation / Collibra** | Catalog-side model documentation, ownership, glossary, and usage context | Catalogs describe models; they do not enforce modeling discipline by themselves |
| **Looker / Tableau semantic models / Power BI models** | BI-facing governed relationships and metrics | Risk of business logic living only in BI unless synchronized with warehouse models |

Commercial modeling value comes from collaboration and governance around the model. Keep the executable truth close to transformation code and publish it outward.

## Related

- [semantic-layer.md](semantic-layer.md)
- [data-transformation.md](data-transformation.md)
- [data-warehouse.md](data-warehouse.md)
