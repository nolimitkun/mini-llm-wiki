---
title: Data quality
category: governance-quality
updated: 2026-07-13
sources: [sources/2026-07-open-source-project-comparisons.md, sources/2026-07-commercial-product-comparisons.md]
---

# Data quality

**Data quality** is whether data is fit for its consumers' purposes — fresh enough, complete enough, correct enough. Its cost curve is brutal: an error caught at [ingestion](data-ingestion.md) costs minutes; the same error discovered in an executive dashboard, a model's training set, or an [AI agent's action](agents-and-mcp.md) costs trust, and trust is the platform's actual product.

## The dimensions (pick metrics per dataset, not slogans)

| Dimension | Example check |
|---|---|
| **Freshness** | Table updated within SLO ("orders current to 15 min") |
| **Completeness** | Row counts vs. source; critical columns null-rate |
| **Validity** | Types, formats, accepted ranges (order_total ≥ 0) |
| **Uniqueness** | Primary keys actually unique (JOIN fan-out is the classic silent killer) |
| **Consistency** | Totals reconcile across systems (warehouse revenue = billing system ± tolerance) |
| **Accuracy** | Matches reality — hardest; needs reference data or human sampling |

## The defense layers

1. **Contracts at the boundary**: schema + semantics + SLA agreed with producers; violations rejected or quarantined at [ingestion](data-ingestion.md), not discovered downstream ([data-mesh.md](data-mesh.md)).
2. **Tests in transformation**: assertions as code between every layer — uniqueness, not-null, referential integrity, reconciliations — blocking bad builds ([data-transformation.md](data-transformation.md)).
3. **Observability over what tests miss**: anomaly detection on volumes, distributions, freshness across the estate (Monte Carlo-class tools, or built); tests catch what you predicted, monitoring catches what you didn't.
4. **Incident process**: quality failures get severity levels, owners, comms to affected consumers (via [lineage](data-catalog-and-lineage.md)), and post-mortems — like production outages, because they are.

## Quality for AI consumers

- **Training/feature data**: point-in-time correctness (no future leakage — [feature-stores.md](feature-stores.md)), label quality, dedup, eval-set decontamination ([mlops.md](mlops.md)).
- **RAG corpora**: stale or duplicated documents get *retrieved and quoted*; curation, freshness expiry, and deletion propagation are quality work ([rag.md](rag.md)).
- **LLM-generated data flowing back in**: schema-validate outputs, route low-confidence to review, mark provenance columns (model + prompt version), sample into evaluation ([llmops.md](llmops.md)) — treat the model as an untrusted upstream producer, contract and all.

## Program advice

- Score coverage on tier-1 assets first; a dashboard of *quality SLO compliance per domain* creates the right incentive gradient.
- Every check needs an owner and an action; unowned alerts train people to ignore alerts.
- Publish quality status into the [catalog](data-catalog-and-lineage.md) so trust is visible at the point of discovery.

## Open source project comparison

| Project | Best fit | Watch-outs |
|---|---|---|
| **Great Expectations** | Declarative expectations, validation suites, data-doc-style reporting | Powerful but can become heavy; keep checks tied to owners and actions |
| **Soda Core** | SQL-centric checks, freshness/volume tests, lightweight observability patterns | OSS core covers checks; broader monitoring may require surrounding tooling |
| **dbt tests / dbt-expectations** | Transformation-layer uniqueness, not-null, relationships, accepted values | Excellent for known assertions; not anomaly detection over the whole estate |
| **Deequ** | Spark-scale data quality constraints and profiling | Fits Spark shops; less ergonomic for SQL-first analytics teams |
| **OpenMetadata quality** | Publishing quality status into the catalog context | Quality is more useful at discovery time, but execution coverage still comes from tests/monitors |

Combine transformation tests for invariants with observability/anomaly checks for surprises; no single OSS tool replaces an incident process.

## Commercial product comparison

| Product | Best fit | Watch-outs |
|---|---|---|
| **Monte Carlo** | Data observability across freshness, volume, schema, lineage, and incidents | Strong monitoring layer; still pair with transformation tests and ownership |
| **Bigeye** | Data observability and anomaly detection for warehouse/lakehouse teams | Alert quality and incident workflow matter more than dashboard count |
| **Soda Cloud** | Managed checks, agreements, and data quality monitoring with OSS continuity | Good SQL/check workflow; coverage depends on connected systems |
| **Anomalo** | ML-driven data quality monitoring, especially for enterprise warehouses | Useful anomaly layer; interpretability and action routing need process |
| **Informatica / Talend data quality** | Enterprise suite quality, profiling, cleansing, and governance integration | Powerful but can be heavyweight for modern code-first teams |
| **Databricks DLT expectations / Great Expectations Cloud** | Quality gates close to pipelines and transformation workflows | Works best when embedded in deployment gates, not just reporting |

Commercial data quality buys monitoring and workflow. It does not replace producer contracts, model tests, or incident ownership.

## Related

- [data-governance.md](data-governance.md)
- [data-transformation.md](data-transformation.md)
- [data-catalog-and-lineage.md](data-catalog-and-lineage.md)
