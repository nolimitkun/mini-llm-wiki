---
title: MLOps
category: ml-platform
updated: 2026-07-12
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

## Related

- [ml-platform-overview.md](ml-platform-overview.md)
- [llmops.md](llmops.md)
- [data-quality.md](data-quality.md)
