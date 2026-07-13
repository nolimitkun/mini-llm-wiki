---
title: Data transformation
category: ingestion-processing
updated: 2026-07-13
sources: [sources/2026-07-open-source-project-comparisons.md]
---

# Data transformation

**Transformation** turns raw landed data into trustworthy, consumable models: cleaning, joining, conforming, aggregating. In the ELT era this happens *inside* the platform (SQL on the [warehouse](data-warehouse.md)/[lakehouse](lakehouse.md)), and the discipline that matters most is treating transformations **as software**: version-controlled, tested, reviewed, deployed.

## The layered flow

```
raw/staging  →  core / intermediate  →  marts
(as landed,     (cleaned, typed,        (consumer-facing models
 immutable)      deduped, conformed,     per domain: finance,
                 business logic)         product, ML features)
```

Each layer has a contract: staging mirrors sources 1:1; core is where business logic lives once (not copy-pasted into every dashboard); marts are shaped for consumption ([data-modeling.md](data-modeling.md)).

## Transformation-as-code (the dbt-popularized workflow)

Whatever the tool (dbt, SQLMesh, Dataform, plain Spark jobs), the practices transfer:

- **Declarative DAG**: each model declares its upstream refs; the framework derives build order — feeding [orchestration](orchestration.md) and [lineage](data-catalog-and-lineage.md).
- **Tests as code**: uniqueness, not-null, referential integrity, accepted ranges — run on every build, block bad deploys ([data-quality.md](data-quality.md)).
- **Code review + CI**: transformation changes ship via PR with tests run against production-like data; schema-diff tooling shows blast radius.
- **Documentation inline**: model and column descriptions live with the code and publish to the [catalog](data-catalog-and-lineage.md).
- **Environments**: dev/staging/prod separation, so experimentation never mutates the tables dashboards read.

## Incremental processing

Full rebuilds are simple and correct — do them while you can afford to. When tables outgrow that:

- **Incremental models** process only new/changed partitions; require careful handling of late data and backfill logic.
- **Merge/upsert semantics** on [table formats](table-and-file-formats.md) handle CDC updates.
- Keep a **full-refresh escape hatch**; incremental state corruption happens, and the fix is a rebuild.

## Recurring pitfalls

- **Business logic scattered** across BI tools, notebooks, and pipelines instead of centralized in core models (then metrics disagree — see [semantic-layer.md](semantic-layer.md)).
- **Untested SQL** — a silent `JOIN` fan-out doubles revenue and nobody notices for a quarter.
- **Monolithic god-models** — 2,000-line SQL nobody dares touch; decompose like any code.
- **No ownership** — every model needs an owning team, or rot is guaranteed ([data-mesh.md](data-mesh.md)).

## Open source project comparison

| Project | Best fit | Watch-outs |
|---|---|---|
| **dbt-core** | SQL analytics engineering, tests/docs/lineage as code, broad hiring ecosystem | Powerful convention, but stateful incremental correctness and environment isolation require discipline |
| **SQLMesh** | Transformations where environments, virtual data environments, and incremental planning matter | Smaller ecosystem than dbt; strongest for teams willing to adopt its planning model |
| **Apache Spark** | Large-scale transforms, non-SQL logic, ML prep, semi-structured processing | More engineering surface than SQL-first transforms; keep orchestration and business logic clean |
| **Flink SQL** | Continuous transformations over streams | Operationally a streaming service; do not use when micro-batch is enough |
| **Dataform-style SQL repos** | Warehouse-native SQL projects with lightweight workflow needs | Often tied to a platform; evaluate portability if OSS/control matters |

Choose the tool by dominant transformation shape: dbt/SQLMesh for modeled analytics, Spark for heavy compute, Flink only when continuous state is truly required.

## Related

- [data-modeling.md](data-modeling.md)
- [orchestration.md](orchestration.md)
- [data-quality.md](data-quality.md)
