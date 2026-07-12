---
title: Hybrid cloud for data & AI platforms
category: platform-architecture
updated: 2026-07-12
---

# Hybrid cloud for data & AI platforms

A **hybrid cloud** data/AI platform spans **private infrastructure** (on-prem data centers, private cloud, colo) and one or more **public clouds** (AWS, Azure, GCP) as a single logical platform. Most enterprises don't choose hybrid — they *are* hybrid, by history (mainframes, ERP, data centers with years of depreciation left) or by law (sovereignty). The architecture question is not "cloud or not" but **where each workload and dataset lives, and how the seams stay governable**.

## Why workloads stay private / go public

| Force → private (on-prem) | Force → public cloud |
|---|---|
| **Data sovereignty & residency** — regulated data legally pinned to a jurisdiction or premises ([data-governance.md](data-governance.md)) | Elasticity — burst compute, seasonal loads, experiments |
| **Data gravity** — petabytes near the systems that produce them; moving them costs more than computing in place | Managed services — warehouses, orchestration, ML suites without ops staff |
| **Predictable-load economics** — steady 24/7 workloads on depreciated hardware undercut cloud list prices | Frontier AI access — latest GPUs/TPUs and [model provider APIs](llms-on-the-platform.md) without capex or queues |
| **Latency to factories/hospitals/stores** — edge and near-edge processing | Global reach and multi-region DR |
| GPU fleet economics *at sustained high utilization* | GPU access *without* utilization risk |

## Architecture patterns

- **Data plane split by classification**: sensitive/regulated tiers stay private; de-identified or non-sensitive tiers flow to public cloud for elastic analytics and AI. Requires classification at [ingestion](data-ingestion.md) and [tokenization/masking](data-security-and-privacy.md) at the boundary.
- **Compute-to-data**: send queries and training jobs to where data lives, not data to compute — federated [query engines](query-engines.md) (Trino-class) and schedulable training across sites.
- **Burst / split AI lifecycle**: train or fine-tune in the public cloud on de-identified data, **serve privately** near the sensitive data ([model-serving.md](model-serving.md)); or the inverse — pretrained APIs in cloud, [RAG](rag.md) over documents that never leave premises.
- **Consistent substrate**: Kubernetes + object storage (S3-compatible, e.g. MinIO on-prem) + **open [table formats](table-and-file-formats.md)** as the portability layer — the same Iceberg/Delta tables and engines run both sides, making placement a policy decision instead of a rewrite.
- **Extended control planes**: cloud vendors reaching on-prem (AWS Outposts, Azure Arc/Stack, Google Distributed Cloud) vs. cloud-neutral platforms running anywhere (Kubernetes-based lakehouse stacks, Snowflake/Databricks multi-cloud). The first is operationally easiest and deepens lock-in; the second inverts that trade ([build-vs-buy.md](build-vs-buy.md)).

## The seams (where hybrid hurts)

- **One governance plane or none**: [catalog, lineage](data-catalog-and-lineage.md), classification, and access policy must span both sides — two catalogs means the private side becomes the shadow estate. Federate identity (single IdP) before anything else.
- **Egress economics**: cloud egress fees make chatty cross-boundary pipelines ruinous; design for coarse, scheduled, compressed movement ([finops.md](finops.md) — and FinOps must merge cloud bills with on-prem TCO to compare honestly).
- **Network as a platform component**: private links (Direct Connect/ExpressRoute/Interconnect), bandwidth planning, and latency budgets belong in the architecture, not the networking team's backlog.
- **Split-brain data**: the same "customers" table maintained both sides drifts; declare a system of record per dataset and replicate one-way ([data-quality.md](data-quality.md) consistency checks across the seam).
- **Skills × 2**: every capability (monitoring, security, deploy) needs to work in both worlds; standardize tooling (IaC, K8s, OpenTelemetry) to keep it one team, not two.

## Hybrid AI, specifically

- **Sovereign AI** requirements increasingly mandate models, prompts, and embeddings stay in-jurisdiction — driving on-prem/open-weight [LLM serving](llms-on-the-platform.md) for regulated prompts, with the [gateway](reference-architecture.md) routing by data classification: sensitive → private endpoint, generic → public API.
- **GPU placement math**: own GPUs win only at sustained high utilization; the common landing is a small private fleet for baseline + regulated inference, cloud for training bursts and evaluation ([build-vs-buy.md](build-vs-buy.md)).
- **[Vector indexes](vector-databases.md) and [feature stores](feature-stores.md) follow their source data's classification** — an index derived from private documents is private, wherever it's cheaper to host.

## Related

- [reference-architecture.md](reference-architecture.md)
- [build-vs-buy.md](build-vs-buy.md)
- [data-governance.md](data-governance.md)
