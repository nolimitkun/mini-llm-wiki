---
title: Query engines
category: modeling-serving
updated: 2026-07-12
---

# Query engines

A **query engine** executes analytical SQL over data it may not own — the compute half of the storage/compute separation that defines the modern platform. On a [lakehouse](lakehouse.md), the same [Iceberg/Delta tables](table-and-file-formats.md) can be read by several engines, each chosen for its workload.

## The landscape by workload shape

| Engine class | Examples | Sweet spot |
|---|---|---|
| **Warehouse-native MPP** | Snowflake, BigQuery, Redshift | Governed BI at scale, ELT SQL ([data-warehouse.md](data-warehouse.md)) |
| **Distributed SQL on open data** | Trino/Presto, Spark SQL, Dremio | Federated queries, lake analytics, huge joins |
| **General distributed compute** | Spark, Flink | Heavy transformation code, ML prep, [streaming](stream-processing.md) |
| **Single-node vectorized** | DuckDB, Polars, chDB | Small-to-mid data (which is *most* data), local dev, in-pipeline compute |
| **Real-time OLAP** | ClickHouse, Druid, Pinot | Sub-second dashboards over fresh events, user-facing analytics |

Two structural trends: **engines converging on open table formats** (pick storage once, choose engines per workload), and **"small data" rehabilitation** — a single beefy node with DuckDB/Polars outruns clusters for the 90% of datasets under a few hundred GB, at a fraction of cost and complexity.

## How engines go fast (why layout matters)

- **Columnar scans + vectorized execution**: process column batches with CPU-cache-friendly loops.
- **Predicate/projection pushdown**: read only needed columns; skip files/row-groups via min-max stats — effective only if data layout cooperates ([table-and-file-formats.md](table-and-file-formats.md): sorting, compaction, sane partitioning).
- **Cost-based optimization**: join order from table statistics — keep stats fresh.
- **Shuffles are the expensive part** of distributed joins/aggregations; data skew in join keys creates the straggler tasks that make a 5-minute query take an hour.

Practical performance triage, in order: *is the layout pruning?* → *is one task skewed?* → *is the join order sane?* → only then, more compute.

## Choosing without regret

1. Default to your platform's paved-road engine for BI + ELT.
2. Add a real-time OLAP store only when a product surface needs sub-second, high-concurrency queries.
3. Use DuckDB-class engines for dev loops, tests, and small-data pipelines — matching CI to production semantics.
4. Resist engine sprawl: every additional engine multiplies [governance](data-governance.md), [FinOps](finops.md), and expertise surface.

## Related

- [table-and-file-formats.md](table-and-file-formats.md)
- [lakehouse.md](lakehouse.md)
- [finops.md](finops.md)
