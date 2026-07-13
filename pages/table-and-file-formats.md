---
title: Table & file formats
category: storage
updated: 2026-07-13
sources: [sources/2026-07-open-source-project-comparisons.md, sources/2026-07-commercial-product-comparisons.md]
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

## Open source project comparison

| Project / format | Best fit | Watch-outs |
|---|---|---|
| **Parquet** | Default analytical file format for lake, warehouse external tables, ML feature data | Great files do not make a table; use a table format for transactions and deletes |
| **ORC** | Hive/Trino-heavy estates with existing ORC optimization | Less universal as a default interchange than Parquet |
| **Avro / Protobuf** | Streaming payloads with schema registry and compatibility rules | Row payloads, not analytical storage targets; usually convert to Parquet/Iceberg downstream |
| **Apache Iceberg** | Multi-engine transactional tables and neutral lakehouse architecture | Best when paired with an explicit catalog and table-maintenance automation |
| **Delta Lake** | Spark-first lakehouse tables and Databricks interoperability | Validate non-Spark readers/writers before calling it open interchange |
| **Apache Hudi** | Upsert-heavy ingestion and incremental consumption | Operationally distinctive; fit it to CDC needs rather than general BI alone |

The durable choice is less about feature checklists than about the engines that must read and write the same tables safely.

## Commercial product comparison

| Product | Best fit | Watch-outs |
|---|---|---|
| **Databricks Delta / Unity Catalog** | Delta-centered lakehouse tables with strong managed governance and optimization | Neutrality depends on UniForm/Iceberg support and non-Databricks engine needs |
| **Snowflake Iceberg Tables / Open Catalog** | Iceberg interoperability with Snowflake governance and query performance | Validate external engine write patterns and catalog ownership |
| **AWS Glue Data Catalog + Athena/EMR** | AWS-native table metadata and managed query/processing over open formats | Glue is common plumbing; fine-grained governance may require Lake Formation and extra design |
| **Google BigLake / BigQuery external tables** | BigQuery-governed access to lake files and open-table data | Strong GCP fit; cross-engine write guarantees need validation |
| **Microsoft Fabric OneLake / shortcuts** | Microsoft-governed lake files with Power BI and Fabric engine integration | Works best inside Fabric conventions; test open table semantics across outside engines |

The commercial question is not Parquet versus ORC. It is who owns table metadata, optimization, access policy, and cross-engine writes.

## Related

- [lakehouse.md](lakehouse.md)
- [data-lake.md](data-lake.md)
- [query-engines.md](query-engines.md)
