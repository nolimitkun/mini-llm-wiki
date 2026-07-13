---
title: Data lake
category: storage
updated: 2026-07-13
sources: [sources/2026-07-open-source-project-comparisons.md, sources/2026-07-commercial-product-comparisons.md]
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

## Open source project comparison

The lake itself is mostly object storage plus conventions; the project choice is about how much storage operations you want to own.

| Project | Best fit | Watch-outs |
|---|---|---|
| **MinIO** | S3-compatible object storage for on-prem, edge, labs, and sovereign deployments | Simple and fast, but you still own durability design, upgrades, lifecycle policy, and capacity planning |
| **Ceph** | Unified object/block/file storage for infrastructure teams already operating storage clusters | Much broader than a data lake substrate; operational surface is larger than MinIO |
| **Apache Ozone** | Hadoop-adjacent object storage at very large scale | Niche fit unless you already live in the Hadoop ecosystem |
| **LakeFS** | Git-like branching/versioning over object-store data workflows | Complements object storage; does not replace table-format transactions or a governance catalog |

For most data teams, avoid making storage clever: pick S3-compatible semantics, standardize paths/zones, and put table formats plus catalogs above it.

## Commercial product comparison

| Product | Best fit | Watch-outs |
|---|---|---|
| **Amazon S3** | Default object-store substrate for AWS data lakes and lakehouses | Watch egress, request costs, lifecycle policy, and cross-account access complexity |
| **Google Cloud Storage** | GCP-native lakes feeding BigQuery, Dataproc, Dataflow, and Vertex AI | Great simplicity; cross-cloud access and governance boundaries need design |
| **Azure Data Lake Storage / OneLake** | Microsoft/Fabric-centered estates, Power BI integration, enterprise identity alignment | OneLake is opinionated around Fabric; validate non-Microsoft engine paths |
| **Databricks Unity Catalog Volumes / external locations** | Governed lake access inside Databricks lakehouse deployments | Governance is strong inside the platform; raw bucket bypass must be locked down |
| **Snowflake external volumes / Iceberg tables** | Lake data governed or queried through Snowflake without fully moving into warehouse storage | Interoperability depends on table/catalog choices and write ownership |

Managed object stores are usually the right answer unless sovereignty, edge, or on-prem economics force self-hosting. The lake design risk moves from disks to identity, lifecycle, and egress.

## Related

- [lakehouse.md](lakehouse.md)
- [table-and-file-formats.md](table-and-file-formats.md)
- [data-catalog-and-lineage.md](data-catalog-and-lineage.md)
