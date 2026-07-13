---
title: MLOps
category: ml-platform
updated: 2026-07-13
sources: [sources/2026-07-open-source-project-comparisons.md, sources/2026-07-commercial-product-comparisons.md]
---

# MLOps

**MLOps** applies software-delivery discipline to systems whose behavior comes from *data*, not just code: a model is code × data × config, so reproducing, testing, deploying, and monitoring it needs machinery beyond CI/CD. The core loop: train → evaluate → register → deploy → monitor → retrain.

## What must be versioned together

A production prediction should be traceable to: **code** (training script version), **data** (dataset snapshot / [time-travel](lakehouse.md) reference), **features** ([feature-store](feature-stores.md) definitions), **params/config**, and the resulting **model artifact** in the registry. Miss one and "why did the model do that on March 3rd?" becomes unanswerable — a [governance](data-governance.md) problem, not just an engineering itch.

## The pipeline stages

1. **Data validation**: schema and distribution checks on training data — most "model bugs" are [data quality](data-quality.md) bugs; catch them before training.
2. **Training as a pipeline**: reproducible, parameterized, on the same [orchestrator](orchestration.md) as everything else; experiment tracking automatic.
3. **Evaluation gates**: candidate must beat the incumbent on held-out metrics *and* slice analyses (per segment/region — aggregate wins hiding subgroup regressions is the classic trap); fairness checks where decisions affect people.
4. **Registry promotion**: staged rollout with approvals; the registry is the single source of what's deployed where.
5. **Production monitoring**:
   - **Input drift**: feature distributions shift vs. training (population changed, upstream pipeline broke).
   - **Prediction drift** and, where labels arrive, **actual performance decay**.
   - System metrics: latency, errors, cost ([model-serving.md](model-serving.md)).
6. **Retraining triggers**: scheduled, drift-triggered, or performance-triggered — each retrain flows through the same gates. Automation level should match label availability and risk; auto-retrain-auto-deploy on delayed labels is how feedback loops go feral.

## CI/CD/CT

Continuous integration (tests on code *and* data assumptions), continuous delivery (of pipelines and models through environments), **continuous training** (retraining as a product feature). Practical bar: any team member can retrain and ship a rollback-safe model in under a day without heroics.

## MLOps vs. LLMOps

Same skeleton, different joints: with foundation models you usually don't own training — the versioned surface becomes *prompts, retrieval indexes, adapters, and provider model versions*, and evaluation becomes judged text quality rather than labeled metrics. Details in [llmops.md](llmops.md); shared spine argued in [ml-platform-overview.md](ml-platform-overview.md).

## Open source project comparison

| Project | MLOps role | Watch-outs |
|---|---|---|
| **MLflow** | Tracking, registry, artifacts, model packaging, gateway/tracing extensions | Best pragmatic default; governance and CI/CD still need surrounding process |
| **DVC** | Data/model versioning tied to Git workflows and remote storage | Excellent for reproducibility; less of a central registry/serving platform |
| **Weights & Biases Local alternatives / ClearML** | Experiment tracking, orchestration, artifact management in OSS/self-hosted forms | Evaluate license, self-hosting burden, and integration with your registry path |
| **Kubeflow Pipelines** | Reproducible containerized training/evaluation pipelines on Kubernetes | Heavy but strong when K8s-native ML workflows are the standard |
| **Evidently** | Drift, data quality, and model performance monitoring reports/services | Monitoring component, not a full MLOps spine |
| **BentoML / KServe / Ray Serve** | Deployment side of the loop | Serving tools must connect back to registry, eval gates, and monitoring |

MLflow is the common center of gravity; add DVC, KFP, Evidently, or serving platforms for specific gaps rather than assembling a tool pile.

## Commercial product comparison

| Product | MLOps role | Watch-outs |
|---|---|---|
| **Weights & Biases** | Experiment tracking, sweeps, registry, reports, LLM eval/observability extensions | Strong practitioner UX; governance needs enterprise configuration |
| **Neptune.ai** | Experiment tracking and model metadata for research/ML teams | Focused tracking product; deployment and governance live elsewhere |
| **Comet** | Experiment management, model monitoring, and optimization workflows | Good lifecycle features; integrate with registry/deployment path |
| **Databricks Mosaic AI / MLflow managed** | Managed MLflow-style tracking/registry plus Databricks workflows and serving | Strong if Databricks is the ML platform center |
| **SageMaker / Vertex AI / Azure ML** | Cloud-native experiment, pipeline, registry, deployment, and monitoring suites | Broad but can become cloud-local silos if data platform is elsewhere |
| **Arize / Fiddler / WhyLabs** | Model observability, drift, explainability, and production monitoring | Monitoring layer; needs connection to retraining and incident workflow |

Commercial MLOps products should reduce manual tracking and release risk. The forcing function is whether every model can be reproduced, evaluated, promoted, monitored, and rolled back.

## Related

- [ml-platform-overview.md](ml-platform-overview.md)
- [llmops.md](llmops.md)
- [data-quality.md](data-quality.md)
