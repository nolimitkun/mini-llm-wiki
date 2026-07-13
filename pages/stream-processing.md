---
title: Stream processing
category: ingestion-processing
updated: 2026-07-13
sources: [sources/2026-07-open-source-project-comparisons.md]
---

# Stream processing

**Stream processing** computes over unbounded event flows continuously: filtering, enriching, joining, and aggregating events within seconds of their occurrence. It's the machinery behind the "streaming" half of [batch-vs-streaming.md](batch-vs-streaming.md).

## The anatomy

```
producers → event log (Kafka/Kinesis/PubSub) → stream processor (Flink/Spark
            durable, ordered, replayable       Streaming/Kafka Streams)
                                                  → sinks: lakehouse tables,
                                                    real-time OLAP, caches,
                                                    feature stores, alerts
```

The **event log** is the backbone: durable, partitioned, replayable — consumers read at their own pace and can reprocess history. Schemas ride along via a **schema registry** (Avro/Protobuf), which is the streaming world's [data contract](data-ingestion.md) enforcement point.

## The concepts that make streaming hard

- **Event time vs. processing time**: when it happened vs. when you saw it. Correct aggregations use event time.
- **Watermarks**: "I've probably seen everything up to time T" — the trigger for closing windows despite out-of-order arrivals.
- **Windows**: tumbling (fixed), sliding, session (gap-based) — how unbounded streams become finite aggregations.
- **State**: joins and aggregations require managed, checkpointed state; state size and recovery time are your real capacity limits.
- **Delivery semantics**: at-least-once is the honest default; "exactly-once" means effectively-once within a framework's boundaries — sinks still need idempotent writes.

## Platform integration patterns

- **Streaming ingestion → lakehouse**: continuous small commits into [table formats](table-and-file-formats.md), with compaction scheduled ([data-lake.md](data-lake.md) small-file problem).
- **Real-time OLAP serving**: ClickHouse/Druid/Pinot consume streams to serve interactive dashboards over fresh data ([oltp-vs-olap.md](oltp-vs-olap.md)).
- **Online feature computation**: streaming aggregations keep [feature-stores.md](feature-stores.md) fresh for real-time ML.
- **Event-driven AI**: triggering [agent](agents-and-mcp.md) or model actions from events — with the same idempotency care as any consumer.

## Honest costs

A stateful streaming job is a **24/7 service**: capacity planning, checkpoint storage, savepoint-based upgrades, replay procedures, on-call. Before committing, re-ask whether minutes-level micro-batch meets the need ([batch-vs-streaming.md](batch-vs-streaming.md)) — and if yes to streaming, standardize on one processor and build shared tooling (deploy, monitor, replay) as platform capabilities.

## Open source project comparison

| Project | Best fit | Watch-outs |
|---|---|---|
| **Apache Kafka** | Durable event log, broad ecosystem, replayable integration backbone | You operate partitions, retention, schemas, rebalancing, and client compatibility |
| **Redpanda** | Kafka API compatibility with simpler single-binary operations | Compatibility is high but not magical; validate edge connectors and operational expectations |
| **Apache Pulsar** | Multi-tenant messaging, geo-replication, separated compute/storage architecture | More moving parts and smaller data-platform ecosystem than Kafka |
| **Apache Flink** | Stateful event-time processing, exactly-once pipelines, complex windows/joins | A 24/7 distributed system with savepoints, state backends, and upgrade discipline |
| **Kafka Streams / ksqlDB** | Application-adjacent stream processing inside Kafka-centric teams | Narrower than Flink for complex state and multi-source processing |
| **Spark Structured Streaming** | Micro-batch/continuous jobs for Spark-standardized teams | Usually simpler than Flink for Spark shops, but less natural for low-latency event-time applications |

The common open default is Kafka plus Flink; choose Redpanda/Pulsar only when their ops or tenancy model is the explicit reason.

## Related

- [batch-vs-streaming.md](batch-vs-streaming.md)
- [data-ingestion.md](data-ingestion.md)
- [feature-stores.md](feature-stores.md)
