---
title: ML platform overview
category: ml-platform
updated: 2026-07-13
sources: [sources/2026-07-open-source-project-comparisons.md]
---

# ML platform overview

An **ML platform** is the shared infrastructure that takes machine learning from notebook to production repeatably: data access, feature management, training compute, experiment tracking, model registry, deployment, and monitoring. It stands on the data platform — most "ML platform" failures are actually [data quality](data-quality.md) and [pipeline](data-transformation.md) failures wearing an ML costume.

## The capability map

```
[data platform: lakehouse, pipelines, governance]
        │
        ├─ feature engineering & store ([feature-stores.md](feature-stores.md))
        ├─ training: managed compute, experiment tracking (params, metrics, artifacts)
        ├─ registry: versioned models + lineage to data & code
        ├─ deployment: batch scoring | online serving ([model-serving.md](model-serving.md))
        └─ monitoring: drift, performance, retraining triggers ([mlops.md](mlops.md))
```

Tooling spans managed suites (SageMaker, Vertex, Databricks ML, Azure ML) and composable OSS (MLflow, Kubeflow, Ray, Metaflow). The suite-vs-compose choice is a standard [build-vs-buy](build-vs-buy.md) call — suites win on integration, compose wins on flexibility and avoiding ceiling-lock.

## What the platform must make easy (the golden path)

1. **Get training data reproducibly**: versioned datasets / time-travel queries ([lakehouse](lakehouse.md)), point-in-time-correct features.
2. **Track every experiment**: code version, data version, params, metrics — automatically, or it won't happen.
3. **Promote through a registry**: staging → production with [evaluation gates](mlops.md), approvals, rollback.
4. **Deploy without a platform ticket**: templated batch and online serving paths.
5. **Watch it in production**: input drift, prediction quality, latency, cost — with retraining a pipeline away ([orchestration.md](orchestration.md)).

## Classic ML vs. GenAI on the same platform

They share the foundation (data, governance, serving discipline) but differ operationally — which is why this wiki gives GenAI [its own pages](llms-on-the-platform.md):

| | Classic ML | GenAI/LLM |
|---|---|---|
| Model origin | You train it | Usually a foundation model you adapt/prompt |
| Core artifact | Model weights + features | Prompts, retrieval indexes, adapters |
| Evaluation | Labeled metrics (AUC, RMSE) | Judged free-text quality ([llmops.md](llmops.md)) |
| Failure mode | Drift, skew | Hallucination, injection, provider changes |

Don't build two disconnected platforms: one registry/gateway/observability spine with GenAI-specific extensions beats parallel empires ([reference-architecture.md](reference-architecture.md)).

## Maturity honesty

You need an ML *platform* when the third team starts duplicating the second team's deployment scripts. Before that, a paved-road template plus the data platform is enough — premature platformization is how ML infra teams ship zero models for a year.

## Open source project comparison

| Project | Platform role | Watch-outs |
|---|---|---|
| **MLflow** | Experiment tracking, model registry, deployments/gateway/tracing in newer versions | Pragmatic default, but not a full Kubernetes ML platform by itself |
| **Kubeflow** | Kubernetes-native ML stack: notebooks, pipelines, training operators, serving components | Powerful but operationally heavy; adopt components deliberately |
| **Ray** | Distributed Python compute for training, tuning, serving, and data workloads | Compute substrate, not governance/registry/catalog on its own |
| **Metaflow** | Developer-friendly ML workflows with data/versioning ergonomics | Strong for team productivity; less of a broad platform control plane |
| **Feast** | Feature store registry plus offline/online materialization patterns | Solves features, not experiments, training, or serving end to end |

For composable OSS, MLflow plus Feast plus Ray/Kubeflow components is the common path; resist installing the whole universe before model teams need it.

## Related

- [feature-stores.md](feature-stores.md)
- [mlops.md](mlops.md)
- [model-serving.md](model-serving.md)
