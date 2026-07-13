---
title: Orchestration
category: ingestion-processing
updated: 2026-07-13
sources: [sources/2026-07-open-source-project-comparisons.md]
---

# Orchestration

**Orchestration** coordinates the platform's work: run this ingestion, then these transformations, then refresh that dashboard and retrain that model — with retries, alerting, backfills, and an audit trail. It's the platform's nervous system; when it's weak, the symptom is humans re-running things by hand at 9am.

## What an orchestrator provides

- **DAGs**: tasks and dependencies — nothing runs before its inputs are ready.
- **Scheduling & sensors**: time-based (cron) and event-based (file landed, table updated) triggers.
- **Retries with backoff**, timeouts, and failure routing (alert, skip, dead-letter).
- **Backfills**: rerun a date range after a bug fix — first-class, not a shell loop.
- **Observability**: run history, duration trends, SLA misses ([data-quality.md](data-quality.md) freshness ties in here).
- **Parametrized runs**: same pipeline, per-tenant/per-date parameters.

Tools: Airflow (incumbent), Dagster (asset-oriented), Prefect, plus vendor-managed and warehouse-native schedulers.

## Task-centric vs. asset-centric

The significant recent shift: from "schedule **tasks**" to "declare **data assets** and their dependencies" — the orchestrator derives what must run to keep assets fresh. Asset thinking aligns orchestration with [lineage](data-catalog-and-lineage.md), makes freshness SLOs first-class ("this table must be updated by 7am"), and matches how [transformation frameworks](data-transformation.md) already declare DAGs.

## Design guidance

- **Idempotent tasks, always** — every task safe to rerun; parameterize by logical date/partition, never "now".
- **Keep orchestration thin**: the orchestrator decides *when and whether*; heavy compute runs in engines ([query-engines.md](query-engines.md), Spark, warehouse). Don't process dataframes inside scheduler workers.
- **One paved-road orchestrator** per platform; five schedulers = zero observability ([what-is-a-data-platform.md](what-is-a-data-platform.md)).
- **Data-aware triggers over clock guessing**: "run when upstream table updates" beats "run at 3am and hope ingestion finished".
- **Alert on outcomes, not noise**: page on SLA misses of tier-1 assets; log-and-batch the rest. An orchestrator that cries wolf gets muted.
- **ML/AI pipelines are just DAGs too**: training, [embedding/index refreshes](llms-on-the-platform.md), evaluation runs belong on the same orchestrator with the same disciplines ([mlops.md](mlops.md)).

## Open source project comparison

| Project | Best fit | Watch-outs |
|---|---|---|
| **Airflow** | Mature task-centric DAG scheduling, huge operator ecosystem, teams that need a common denominator | Easy to overload with business logic; asset awareness and local dev ergonomics lag newer designs |
| **Dagster** | Asset-centric data platforms, typed assets, freshness policies, lineage-aware development | Requires adopting its mental model; fewer legacy integrations than Airflow |
| **Prefect** | Python-first workflow automation, dynamic flows, approachable developer experience | Governance and asset semantics depend more on team conventions |
| **Argo Workflows** | Kubernetes-native batch/workflow execution for containerized jobs | Great execution substrate, but less data-aware out of the box |
| **Temporal** | Durable application workflows and long-running business processes | Excellent for services; not a drop-in data orchestrator unless you build data semantics around it |

Airflow remains the safe incumbent; Dagster is the strongest data-asset choice; Prefect is the ergonomic Python option.

## Related

- [data-transformation.md](data-transformation.md)
- [data-ingestion.md](data-ingestion.md)
- [mlops.md](mlops.md)
