---
title: Batch vs. streaming
category: fundamentals
updated: 2026-07-12
---

# Batch vs. streaming

**Batch** processing works on bounded chunks of data on a schedule (hourly, daily); **streaming** processes events continuously as they arrive. It's a freshness-vs-complexity dial, not a religion — mature platforms run both, and the right default is *batch until a use case proves it needs less latency*.

## The trade

| | Batch | Streaming |
|---|---|---|
| Latency | Minutes–hours | Seconds or less |
| Mental model | "Rerun the query over the table" | "Maintain state as events flow" |
| Failure recovery | Rerun the job (easy if idempotent) | Checkpoints, replays, exactly-once machinery |
| Correctness challenges | Late-arriving data across runs | Event-time vs processing-time, watermarks, out-of-order events |
| Cost shape | Bursty compute, easy to schedule cheap | Always-on infrastructure |
| Typical tools | Warehouse SQL + [dbt-style transforms](data-transformation.md), Spark | Kafka + Flink/Spark Streaming ([stream-processing.md](stream-processing.md)) |

## What actually needs streaming

Genuine streaming use cases: fraud/anomaly detection, operational monitoring, real-time personalization and feature freshness ([feature-stores.md](feature-stores.md)), inventory/logistics state, event-driven applications. A dashboard viewed each morning does not — a common and expensive mistake is streaming pipelines feeding daily-consumed reports.

## The convergence

The gap is narrowing from both ends:

- **Micro-batch** (minutes-level scheduling, incremental models) covers most "near-real-time" asks at batch complexity.
- **Streaming ingestion into the lakehouse**: table formats support frequent small commits ([table-and-file-formats.md](table-and-file-formats.md)), so "the table is minutes fresh" no longer requires a separate serving system.
- **Unified engines** (Spark, Flink) run both semantics; **Kappa architecture** (everything is a stream, batch is a replay) simplified the older Lambda pattern of maintaining parallel batch + speed layers.

The practical architecture today: **stream what must be fresh into the lakehouse and real-time stores; batch-transform everything else in the same storage layer.**

## Decision checklist

1. Who consumes the output, how often, and what breaks if it's an hour old? (Be honest.)
2. Can incremental micro-batch hit the freshness bar? Prefer it.
3. If truly streaming: define event-time semantics, late-data policy, and replay strategy *before* building.
4. Budget the ops: an always-on stateful pipeline is a service with an on-call, not a cron job.

## Related

- [stream-processing.md](stream-processing.md)
- [data-ingestion.md](data-ingestion.md)
- [orchestration.md](orchestration.md)
