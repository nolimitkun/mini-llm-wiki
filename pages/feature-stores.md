---
title: Feature stores
category: ml-platform
updated: 2026-07-13
sources: [sources/2026-07-open-source-project-comparisons.md, sources/2026-07-commercial-product-comparisons.md]
---

# Feature stores

A **feature store** manages the data ML models consume: it computes features once, serves them consistently for both training (historical, batch) and inference (current, low-latency), and makes them discoverable and reusable across teams. It exists to kill two chronic bugs: **training/serving skew** and **future leakage**.

## The two problems it solves

**Training/serving skew** — the feature computed one way in the training pipeline (SQL over the warehouse) and another way in the service (Java at request time) drifts subtly; the model underperforms in production for no visible reason. The store fixes this with *one definition, two materializations*.

**Point-in-time correctness** — training joins must see feature values *as they were at each label's timestamp*. A naive join against current values leaks the future into training ("customer_lifetime_orders" includes orders after the churn event you're predicting), producing great offline metrics and a production faceplant. The store's point-in-time join is the cure — enabled by keeping history ([data-modeling.md](data-modeling.md) SCD thinking, [lakehouse time travel](lakehouse.md)).

## Anatomy

```
feature definitions (code: transformations over platform tables/streams)
        │
        ├── offline store: historical values on the lakehouse
        │     → point-in-time training sets, batch scoring
        └── online store: latest values in a low-latency KV (Redis/DynamoDB-class)
              → request-time lookups for [online serving](model-serving.md)

batch pipelines ([orchestration.md](orchestration.md)) + streaming updates
([stream-processing.md](stream-processing.md)) keep both materialized
```

Plus a registry: feature metadata, owners, freshness, and which models consume what — lineage that pays off at incident time ([data-catalog-and-lineage.md](data-catalog-and-lineage.md)).

## Do you need one?

- **Batch-scoring-only shop**: probably not — disciplined [transformation](data-transformation.md) tables with history serve training and scoring fine.
- **Online inference with request-time features**: yes, something must bridge offline/online — buy (Tecton, Databricks/SageMaker/Vertex feature stores), adopt OSS (Feast), or build a thin one.
- **Many teams reinventing the same features**: the registry/reuse value alone can justify it.

## Operational notes

- Feature pipelines are production pipelines: [quality tests](data-quality.md), freshness SLOs (a stale online feature silently degrades every prediction), backfill paths.
- Monitor **offline/online consistency** explicitly — sample online reads against offline recomputation.
- Features are governed data: PII classification and access control apply ([data-governance.md](data-governance.md)); embeddings served for [GenAI](llms-on-the-platform.md) increasingly live in the same discipline.

## Open source project comparison

| Project | Best fit | Watch-outs |
|---|---|---|
| **Feast** | OSS feature registry, point-in-time joins, offline/online store abstraction | Default OSS choice; you still operate storage, pipelines, quality, and online serving |
| **Hopsworks Feature Store** | More complete feature platform with UI, governance, and managed path options | Heavier stack; evaluate whether you need platform breadth or just Feast-like primitives |
| **Butterfree** | Spark-based feature engineering pipelines | Narrower ecosystem; useful when Spark feature computation is the main pain |
| **Lakehouse tables + dbt/Spark** | Batch-only models and simple reusable features without online serving | Often enough; do not add a feature store until point-in-time reuse or online lookup hurts |
| **Redis / Cassandra / DynamoDB-compatible stores** | Online feature materialization targets | Serving store, not feature governance; pair with a registry and offline source of truth |

Adopt Feast when online/offline consistency and point-in-time training joins become recurring problems, not because every ML platform diagram has a feature store box.

## Commercial product comparison

| Product | Best fit | Watch-outs |
|---|---|---|
| **Tecton** | Production feature platform with online/offline consistency and streaming features | Strong dedicated product; cost and vendor dependency should match model volume |
| **Databricks Feature Store / Feature Engineering** | Lakehouse-native features for Databricks ML teams | Best when training, registry, and serving are also Databricks-centered |
| **SageMaker Feature Store** | AWS-native online/offline feature storage and ML integration | Strong AWS fit; portability outside AWS is limited |
| **Vertex AI Feature Store** | GCP-native feature management for Vertex AI users | Best when Vertex AI is the ML control plane |
| **Hopsworks managed offering** | Feature platform with OSS lineage and managed operations | Good if you want Feast-like openness with a fuller product |
| **Redis Enterprise / DynamoDB / Bigtable** | Online feature serving substrate | Serving store only; registry, point-in-time joins, and governance must come from elsewhere |

Buy a feature platform when online inference volume, reuse, and point-in-time correctness justify it. Otherwise lakehouse tables plus disciplined transforms are often enough.

## Related

- [ml-platform-overview.md](ml-platform-overview.md)
- [stream-processing.md](stream-processing.md)
- [data-modeling.md](data-modeling.md)
