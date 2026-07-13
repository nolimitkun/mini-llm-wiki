---
title: Data ingestion
category: ingestion-processing
updated: 2026-07-13
sources: [sources/2026-07-open-source-project-comparisons.md, sources/2026-07-commercial-product-comparisons.md]
---

# Data ingestion

**Ingestion** moves data from where it's produced — operational databases, SaaS APIs, event streams, files, documents — into the platform's storage layer. It's the platform's front door, and its reliability ceiling: nothing downstream can be fresher or more complete than what ingestion delivers.

## Patterns

| Pattern | How | Fit |
|---|---|---|
| **Batch extract** | Periodic full or incremental pulls (by updated_at cursor) | Small/medium tables, tolerant freshness |
| **CDC (change data capture)** | Tail the database's write-ahead log; stream inserts/updates/deletes | The gold standard for OLTP replication: low latency, catches deletes, no source load |
| **Event streaming** | Applications publish events to a log ([Kafka](stream-processing.md)) | Behavioral/telemetry data; event-driven architectures |
| **SaaS connectors** | Managed extractors for APIs (Salesforce, Stripe…) | Buy, don't build — API churn maintenance is brutal ([build-vs-buy.md](build-vs-buy.md)) |
| **File/document drops** | Land files in object storage; includes unstructured docs for [GenAI corpora](rag.md) | Partner feeds, legacy exports, content ingestion |

**ELT over ETL** is the modern default: land data *raw* first, transform inside the platform ([data-transformation.md](data-transformation.md)). Raw landings make bugs replayable — you can always re-derive; you can't re-extract the past.

## CDC in one diagram

```
source DB WAL → CDC reader (e.g. Debezium) → event log → merge/upsert → lakehouse table
```

Gotchas that find everyone: initial snapshot consistency with the ongoing stream, schema changes upstream (add a column mid-stream), delete semantics (soft vs hard), and replication lag monitoring.

## Engineering requirements (any pattern)

- **Idempotency** — reruns and replays must not duplicate; dedupe on keys or use upsert merges ([table formats](table-and-file-formats.md)).
- **Schema drift policy** — upstream *will* change; decide per source: block, evolve automatically, or quarantine. **Data contracts** (agreed schema + semantics + SLA with the producing team) turn surprises into negotiations ([data-mesh.md](data-mesh.md)).
- **Late & out-of-order data** — decide watermark/reprocessing windows explicitly.
- **Freshness SLOs** — measure landed-at vs produced-at lag per source; alert like an uptime metric ([data-quality.md](data-quality.md)).
- **Backfill path** — distinct from the incremental path, designed up front, rate-limited against sources.
- **PII at the door** — classify and tag on landing, before data spreads ([data-governance.md](data-governance.md)).

## Open source project comparison

| Project | Best fit | Watch-outs |
|---|---|---|
| **Airbyte** | Broad SaaS/database connector coverage and a UI-driven ingestion platform | Connector breadth is the value; ops, state handling, and connector quality still vary by source |
| **dlt** | Python-owned ELT pipelines, embedded ingestion inside codebases, custom APIs | Less of a platform UI; best when engineers own the ingestion code |
| **Debezium** | Log-based CDC from operational databases through Kafka/Kafka Connect | CDC primitive, not a full ingestion product; schema changes and snapshots need design |
| **Meltano / Singer ecosystem** | Lightweight connector orchestration and portable ELT conventions | Connector maintenance is uneven; good for small teams that accept code-level ownership |
| **Sling / ingestr** | Simple CLI-first replication and quick database/API moves | Great for narrow jobs; not a substitute for enterprise connector governance |

Default to Airbyte for breadth, Debezium for serious CDC, and dlt when ingestion is part of a Python data product.

## Commercial product comparison

| Product | Best fit | Watch-outs |
|---|---|---|
| **Fivetran** | Reliable managed SaaS/database ELT with broad connector coverage and low ops | Expensive at scale; connector behavior and MAR pricing need FinOps visibility |
| **Airbyte Cloud** | Managed version of an OSS-friendly connector ecosystem | More flexible/open posture; verify connector maturity for tier-1 sources |
| **Matillion** | Cloud ELT with visual development and warehouse/lakehouse targets | Good productivity for visual teams; evaluate portability and CI/CD fit |
| **Informatica IDMC** | Enterprise integration, governance, MDM-adjacent estates | Powerful but heavyweight; procurement and implementation effort are nontrivial |
| **Qlik/Talend** | Enterprise data integration, CDC, and data quality combinations | Strong suite story; avoid buying more suite than the ingestion problem needs |
| **AWS Glue / Azure Data Factory / Google Dataflow** | Cloud-native ingestion and movement inside one hyperscaler | Efficient in-cloud defaults; cross-cloud and SaaS connector depth varies |

Buy ingestion when source API churn would eat your team. Build only the sources that are strategic, weird, or too costly to run through managed connectors.

## Related

- [data-transformation.md](data-transformation.md)
- [stream-processing.md](stream-processing.md)
- [data-quality.md](data-quality.md)
