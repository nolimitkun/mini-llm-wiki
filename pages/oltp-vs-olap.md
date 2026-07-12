---
title: OLTP vs. OLAP
category: fundamentals
updated: 2026-07-12
---

# OLTP vs. OLAP

**OLTP** (online transaction processing) systems run the business — orders, payments, user accounts. **OLAP** (online analytical processing) systems analyze the business — aggregations over history. The split exists because the two workloads want opposite things from a database, and it's the founding reason data platforms exist: move data out of OLTP systems into analytical storage without breaking either.

## The workload contrast

| | OLTP | OLAP |
|---|---|---|
| Typical query | Fetch/update one order | Sum revenue by region over 3 years |
| Rows touched | A handful | Millions–billions |
| Pattern | Many small reads/writes, point lookups | Few large scans, aggregations |
| Layout that wins | **Row-oriented** (whole record together) | **Column-oriented** (scan few columns fast, compress well) |
| Optimized for | Latency, concurrency, ACID | Throughput, scan speed |
| Examples | Postgres, MySQL, DynamoDB | Warehouses ([data-warehouse.md](data-warehouse.md)), lakehouse engines |
| Schema style | Normalized (3NF) to avoid update anomalies | Denormalized ([data-modeling.md](data-modeling.md)) for read speed |

Columnar storage is the single most important idea here: analytical queries touch few columns of many rows, so storing values column-by-column enables 10–100× faster scans and far better compression — the basis of [Parquet and modern table formats](table-and-file-formats.md).

## Why you don't run analytics on the production DB

- Big scans evict the OLTP cache and stall transactions — analysts can take down checkout.
- Normalized schemas make analytical queries into 15-way joins.
- History gets overwritten in place; analytics wants immutable history.

Hence the platform pattern: replicate OLTP data into analytical storage via [ingestion/CDC](data-ingestion.md), model it for reading, and let both sides scale independently.

## The blurry middle (know it exists)

- **HTAP** systems promise both workloads in one engine; in practice most platforms still separate them.
- **Real-time OLAP** stores (Druid, ClickHouse, Pinot) serve aggregations at interactive latency over fresh event streams — OLAP performance with OLTP-ish freshness ([stream-processing.md](stream-processing.md)).
- **Reverse ETL** pushes analytical results *back* into operational tools, closing the loop.

## Related

- [data-warehouse.md](data-warehouse.md)
- [data-ingestion.md](data-ingestion.md)
- [table-and-file-formats.md](table-and-file-formats.md)
