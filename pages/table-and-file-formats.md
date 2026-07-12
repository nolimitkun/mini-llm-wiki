---
title: Table & file formats
category: storage
updated: 2026-07-12
---

# Table & file formats

Two distinct layers get conflated: **file formats** define how bytes of one file encode rows and columns; **table formats** define how many files plus metadata behave as one transactional table. Together they're the open foundation of the [lake](data-lake.md)/[lakehouse](lakehouse.md).

## File formats

| Format | Layout | Use |
|---|---|---|
| **Parquet** | Columnar, compressed, statistics per column chunk | The default for analytics — assume it unless proven otherwise |
| ORC | Columnar | Parquet-equivalent, Hive/Trino heritage |
| Avro | Row-oriented, schema-carrying | Streaming payloads ([Kafka](stream-processing.md)), schema registry ecosystems |
| JSON/CSV | Text | Interchange and landing only — no types, no compression efficiency; convert on ingest |

Why columnar wins for analytics: queries read only needed columns; similar values compress massively; min/max statistics let engines skip whole row groups ([oltp-vs-olap.md](oltp-vs-olap.md)).

## Table formats

Bare Parquet directories can't do concurrent-safe writes, schema changes, or deletes. Table formats add a **metadata/transaction layer** over the files:

| | Iceberg | Delta Lake | Hudi |
|---|---|---|---|
| Origin | Netflix → Apache | Databricks | Uber → Apache |
| Distinctives | Hidden partitioning, strong multi-engine story | Deepest Databricks/Spark integration | CDC-first, record-level upsert heritage |
| Ecosystem (2026) | Broadest neutral adoption; the de-facto interchange | Huge installed base; UniForm bridges to Iceberg | Narrower, streaming-upsert niches |

All three provide the lakehouse core: ACID snapshots, schema evolution, time travel, upserts/deletes. **Selection advice**: your primary engine/vendor usually decides; interop matters more than the format itself — verify that *every* engine you run reads (and ideally writes) your choice through your [catalog](data-catalog-and-lineage.md).

## How a table format works (Iceberg-flavored sketch)

```
catalog → table metadata (schema, snapshots)
            → manifest lists (per snapshot)
               → manifests (file lists + column stats)
                  → parquet data files
```

A commit = write new files + atomically swap the metadata pointer. Readers pin a snapshot (consistent reads, time travel); stats enable file pruning without directory-based partitioning.

## Operational duties (don't skip)

- **Compaction**: merge small files from streaming/frequent commits — the #1 lakehouse performance issue.
- **Snapshot expiry & orphan cleanup**: unbounded time travel = unbounded storage ([finops.md](finops.md)).
- **Sort/cluster within files**: data layout tuned to query patterns beats most other optimizations.

## Related

- [lakehouse.md](lakehouse.md)
- [data-lake.md](data-lake.md)
- [query-engines.md](query-engines.md)
