---
title: Fine-tuning
category: training-adaptation
updated: 2026-07-12
---

# Fine-tuning

**Fine-tuning** continues training a pretrained model on your own examples to change its *behavior*: output format, tone, domain style, task-specific skill. The most important thing to know:

> **Fine-tuning teaches behavior, not facts.** For knowledge, use [RAG](rag-overview.md). Fine-tuned "knowledge" goes stale, can't be access-controlled, and can't be deleted per-document.

## When to fine-tune (and when not)

Reach for fine-tuning when:

- **Prompting has plateaued** — you've iterated on prompts + few-shot examples and quality is still short.
- **Format/style consistency** — strict output schemas, brand voice, code conventions the model won't reliably hold.
- **Latency/cost** — distill a large model's behavior into a small one: fine-tune the small model on the large model's outputs (see [cost optimization](cost-optimization.md)).
- **Narrow repeated tasks** — classification, extraction, routing at high volume.

Don't fine-tune for: fresh/private knowledge (RAG), one-off tasks, or before you have an [evaluation set](evaluation.md) — you can't tell if it worked.

**Order of operations: prompt engineering → RAG → fine-tuning.** Each step is 10× the effort of the previous.

## Methods

| Method | What trains | Cost | Notes |
|---|---|---|---|
| **Full fine-tuning** | All weights | High (multi-GPU) | Max quality; risks catastrophic forgetting; a full model copy per variant |
| **LoRA / QLoRA (PEFT)** | Small low-rank adapter matrices (~0.1–1% of params) | Low (often 1 GPU) | **The default.** Adapters are megabytes, swappable at serving time; QLoRA trains on a quantized base for consumer-GPU budgets |
| **Provider API fine-tuning** | Managed (opaque) | Per-token fee | No infra; only for that provider's models; check data-use terms ([governance](data-governance.md)) |

## Data is the whole game

Typical need: **500–10,000 high-quality prompt→response examples** in the exact format you'll use in production (including your system prompt). Quality dominates quantity — see [data quality](data-quality-and-curation.md#fine-tuning-data-quality). Sources: curated production logs (best), expert-written examples, outputs of a stronger model (distillation). Hold out 10–20% for evaluation; decontaminate against your eval set.

## Process checklist

1. Build the [eval set](evaluation.md) *first*; baseline the prompted model.
2. Prepare and version the training dataset (immutable snapshot, lineage).
3. Train (LoRA first); track loss but **judge by eval metrics**, not loss.
4. Compare against baseline on the eval set *and* spot-check for regressions on general ability.
5. Register model + dataset + config in your model registry; deploy behind the same [gateway](reference-architecture.md) with canary rollout.
6. Plan the treadmill: base model deprecations force re-tuning — keep data and pipeline reproducible.

## Related

- [Alignment](alignment.md)
- [Model serving](model-serving.md)
- [LLMOps overview](llmops-overview.md)
