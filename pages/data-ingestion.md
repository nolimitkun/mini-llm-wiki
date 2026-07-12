---
title: Data ingestion
category: ingestion-processing
updated: 2026-07-12
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

## Related

- [data-transformation.md](data-transformation.md)
- [stream-processing.md](stream-processing.md)
- [data-quality.md](data-quality.md)
