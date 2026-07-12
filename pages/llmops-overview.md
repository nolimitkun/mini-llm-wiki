---
title: LLMOps overview
category: llmops
updated: 2026-07-12
---

# LLMOps overview

**LLMOps** is the operational discipline for LLM-powered systems. It inherits from MLOps but differs in kind, not just degree: you usually **don't own the model**, outputs are **non-deterministic free text**, and the "code" that changes most often is a **prompt**.

## How LLMOps differs from MLOps

| | Classic MLOps | LLMOps |
|---|---|---|
| Model | You train & own it | Usually a vendor API or open weights |
| Change unit | Retrained model | Prompt, retrieval config, model version, tools |
| Output | Score/class — easy to check | Free text — needs [judged evaluation](evaluation.md) |
| Failure mode | Drift, skew | Hallucination, injection, regression on provider update |
| Cost model | Infra hours | Per-token, usage-driven ([cost](cost-optimization.md)) |
| Data pipelines | Features | Corpora, chunks, embeddings ([pipelines](data-pipelines-for-llms.md)) |

## The LLMOps loop

```
        ┌───────────── design ─────────────┐
        │  prompts, retrieval, tools,      │
        │  model choice                    │
        └──────┬───────────────────────────┘
               ▼
        offline evaluation  ── gate ──►  deploy (canary)
               ▲                            │
               │                            ▼
        curate failures  ◄──  monitor production
```

Every arrow is a practice with its own page: [evaluation](evaluation.md), [monitoring](monitoring-and-observability.md), [prompt management](prompt-management.md).

## What to version (the config surface)

An LLM application's behavior is the product of *all* of these — version and log them together so any output is reproducible:

- Prompt templates (+ few-shot examples)
- Model + exact version, sampling params (temperature, max_tokens)
- Retrieval config: embedding model, chunking config, k, reranker, filters
- Tool definitions ([tool use](tool-use.md))
- Guardrail/policy config

A change to any one is a **release** and goes through the eval gate.

## Maturity ladder

1. **Ad hoc** — prompts in code, manual spot-checks, no cost attribution. *(Fine for a prototype; dangerous at launch.)*
2. **Instrumented** — every call logged with full config; cost dashboards; golden eval set runs before releases.
3. **Gated** — evals in CI; canary deploys for prompt/model changes; guardrails enforced at a [gateway](reference-architecture.md); provider upgrades tested like dependency bumps.
4. **Continuous** — production sampling feeds judges and human review; failures auto-flow into eval sets and fine-tuning data; routing/cost optimized from live metrics.

Most teams should aim for level 3 before scaling traffic.

## Organizational note

LLMOps sits naturally with the **platform team**: centralize the gateway, logging, evaluation harness, and guardrails once; let product teams own their prompts, corpora, and eval sets on top of it. The split mirrors how data platforms centralize warehouses while teams own their models/dashboards.

## Related

- [Evaluation](evaluation.md)
- [Monitoring & observability](monitoring-and-observability.md)
- [Reference architecture](reference-architecture.md)
