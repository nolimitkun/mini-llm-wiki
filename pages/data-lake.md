---
title: Data lake
category: storage
updated: 2026-07-12
---

# Data lake

A **data lake** is a central repository on cheap object storage (S3, GCS, ADLS) holding data in open file formats — structured tables, semi-structured logs, and unstructured documents/images/audio alike. Its founding bet: **store everything raw first, decide schemas later** (schema-on-read), decoupling storage from any single compute engine.

## Why lakes exist

- **Cost**: object storage is ~10–50× cheaper than warehouse-native storage; retention of raw history becomes affordable.
- **Openness**: files in [Parquet/ORC](table-and-file-formats.md) are readable by any engine — Spark, Trino, DuckDB, warehouse external tables ([query-engines.md](query-engines.md)) — no lock-in.
- **Unstructured data**: ML training corpora, documents for [RAG](rag.md), images, logs — none of it fits a warehouse table naturally.
- **Decoupling**: many engines, one storage layer; compute choices stay reversible.

## The swamp problem

The lake's flexibility is its failure mode. Without discipline you get the **data swamp**: undocumented files, unknown owners, silently broken schemas, duplicate half-truths. The known antidotes:

- **Zone structure** — a conveyed contract about refinement level:

  ```
  raw/      immutable landings, as-delivered ([data-ingestion.md](data-ingestion.md))
  refined/  cleaned, typed, deduplicated
  curated/  consumer-ready, modeled, quality-tested
  ```

- **Catalog everything** — datasets without [catalog entries and owners](data-catalog-and-lineage.md) effectively don't exist.
- **Table formats over bare files** — bring ACID commits and schema enforcement to the lake ([table-and-file-formats.md](table-and-file-formats.md)); this is the road to the [lakehouse](lakehouse.md).
- **Quality gates between zones** ([data-quality.md](data-quality.md)).

## Lake-specific engineering notes

- **Small-file problem**: streaming and frequent ingestion create thousands of tiny files that wreck scan performance; schedule compaction.
- **Partitioning** by date/tenant prunes scans, but over-partitioning (high-cardinality keys) recreates the small-file problem.
- **Layout is forever-ish**: renaming paths breaks every downstream reader — treat directory structure as an API.
- **Security**: object-store ACLs are coarse; fine-grained (row/column) control needs a table format + governance layer on top ([data-security-and-privacy.md](data-security-and-privacy.md)).

## Related

- [lakehouse.md](lakehouse.md)
- [table-and-file-formats.md](table-and-file-formats.md)
- [data-catalog-and-lineage.md](data-catalog-and-lineage.md)
