---
title: Lakehouse
category: storage
updated: 2026-07-13
sources: [sources/2026-07-open-source-project-comparisons.md]
---

# Lakehouse

The **lakehouse** is the architecture that gives [data lake](data-lake.md) storage the management guarantees of a [data warehouse](data-warehouse.md): ACID transactions, schema enforcement, time travel, and fast SQL — directly on open files in object storage. Its enabling technology is the **open table format** ([Iceberg, Delta, Hudi](table-and-file-formats.md)) plus a shared catalog.

## The claim

One copy of the data, on open storage, serving *all* workloads:

```
                    ┌── BI / SQL analytics ([query-engines.md](query-engines.md))
object storage      ├── batch & streaming ETL
+ open table format ├── data science / ML training ([ml-platform-overview.md](ml-platform-overview.md))
+ catalog           └── GenAI corpora & feature pipelines ([llms-on-the-platform.md](llms-on-the-platform.md))
```

versus the older pattern of a lake *and* a warehouse with a copy-and-drift pipeline between them.

## What the table format layer buys you

- **ACID commits** — concurrent writers, readers never see partial writes; streaming and batch can share tables ([batch-vs-streaming.md](batch-vs-streaming.md)).
- **Schema evolution** — add/rename/drop columns safely, enforced on write.
- **Time travel** — query yesterday's version; reproducible ML training sets and easy incident forensics.
- **Hidden partitioning & stats-based pruning** — engine skips files without user-managed partition columns (Iceberg especially).
- **Upserts/deletes** — CDC merges and GDPR erasure on immutable object storage ([data-ingestion.md](data-ingestion.md), [data-governance.md](data-governance.md)).

## What's genuinely hard

- **Table maintenance is your job** (or your vendor's): compaction of small files, snapshot expiry, orphan cleanup — unmaintained lakehouse tables degrade badly.
- **Catalog becomes the control point**: which catalog (Unity, Polaris, Glue, Nessie…) governs the tables determines real interoperability — engines increasingly read each other's formats but write through *their* catalog. Lock-in moved up a layer; negotiate it consciously.
- **Performance gap edge cases**: hyper-optimized warehouse engines still win some interactive BI workloads; measure yours.

## Adoption pattern that works

1. Land ingestion into table-format tables from day one (raw zone).
2. Run [transformations](data-transformation.md) lake-side; serve BI from the same tables via a fast SQL engine.
3. Keep (or add) a warehouse only where measured price/performance justifies it — as *an engine on the lakehouse*, not a second silo.

## Open source project comparison

Lakehouse choices split into table format, catalog, and engines. Mixing them deliberately matters more than picking a single branded stack.

| Project | Best fit | Watch-outs |
|---|---|---|
| **Apache Iceberg** | Neutral multi-engine lakehouse tables across Trino, Spark, Flink, DuckDB, and warehouses | Catalog choice controls real interoperability; maintenance jobs are still required |
| **Delta Lake** | Spark/Databricks-centered estates and teams that value mature Delta tooling | Strong installed base, but neutrality depends on UniForm/catalog support in your actual engines |
| **Apache Hudi** | CDC-heavy lakes, incremental pulls, and record-level upsert pipelines | Less common as the general-purpose interchange; choose for its write pattern, not fashion |
| **Polaris / Nessie / Lakekeeper** | Iceberg catalogs with governance, branching, or OSS control-plane needs | The catalog becomes the lock-in layer; test every writer, not just readers |

Selection rule: benchmark the whole path--writer, catalog, compaction, query engine, governance--because lakehouse failures usually live in integration gaps.

## Related

- [table-and-file-formats.md](table-and-file-formats.md)
- [data-warehouse.md](data-warehouse.md)
- [reference-architecture.md](reference-architecture.md)
