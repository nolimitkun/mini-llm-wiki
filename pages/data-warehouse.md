---
title: Data warehouse
category: storage
updated: 2026-07-12
---

# Data warehouse

A **data warehouse** is a database purpose-built for analytics: columnar storage, massively parallel SQL execution, and schema-on-write discipline. It's the system of record for the *modeled* view of the business — the place where "revenue" has one definition and dashboards don't lie (see [semantic-layer.md](semantic-layer.md) for keeping it that way).

## What makes it a warehouse

- **Columnar + compressed storage** for fast scans ([oltp-vs-olap.md](oltp-vs-olap.md)).
- **MPP execution**: queries fan out across many nodes.
- **Separation of storage and compute** (the cloud-era shift): storage sits cheap on object stores, compute scales elastically and independently — pay for queries, not idle clusters.
- **Schema-on-write**: data is cleaned and typed on the way in, so consumers can trust shape and semantics.
- **Managed operations**: no index tuning or vacuum scheduling as user burden (mostly).

Representative engines: Snowflake, BigQuery, Redshift, Databricks SQL, Fabric/Synapse.

## Internal layout (the classic layered flow)

```
staging (raw copies from ingestion)
   → core / integration (cleaned, conformed, tested)
      → marts (consumer-facing models per domain)
```

Built and maintained by [transformation pipelines](data-transformation.md) with [quality tests](data-quality.md) between layers, all under [orchestration](orchestration.md).

## Warehouse vs. lake vs. lakehouse

The warehouse's strengths — governance, performance, SQL ergonomics — historically came with lock-in (proprietary storage) and poor fit for unstructured data and ML workloads. The [data lake](data-lake.md) answered with cheap open storage; the [lakehouse](lakehouse.md) merges the two. In 2026 the boundary is genuinely blurry: warehouses read open [table formats](table-and-file-formats.md) on object storage, and lakehouse engines pass warehouse benchmarks. The differentiators left are ecosystem, governance tooling, and price/performance on *your* workload — benchmark with your queries, not vendor decks.

## Operational realities

- **Cost discipline**: the elastic-compute model makes overspend easy — see [finops.md](finops.md) for warehouse-specific tactics (right-sizing, query hygiene, storage tiering).
- **Workload isolation**: separate compute for ELT, BI, and ad-hoc/data-science so one team's monster query doesn't starve dashboards.
- **Concurrency & serving**: warehouses serve analysts well; for user-facing analytics at high QPS, front them with a real-time OLAP store or cache.

## Related

- [lakehouse.md](lakehouse.md)
- [data-modeling.md](data-modeling.md)
- [data-transformation.md](data-transformation.md)
