---
title: Build vs. buy decisions
category: platform-architecture
updated: 2026-07-12
---

# Build vs. buy decisions

LLM platforms involve a stack of build-vs-buy choices, each with its own economics. The recurring theme: **buy models, build the integration to your data, and keep the switching costs low.**

## Decision 1: Model — API vs. self-hosted open weights

| Factor | Provider API | Self-hosted open weights |
|---|---|---|
| Quality ceiling | Frontier | 6–18 months behind frontier; sufficient for many tasks |
| Cost profile | Per-token; zero at zero usage | GPUs + engineers; cheaper only at sustained high utilization |
| Data control | Data leaves your boundary (VPC offerings narrow this) | Full control ([governance](data-governance.md)) |
| Ops burden | None | [Serving](model-serving.md), upgrades, capacity, on-call |
| Customization | Prompting, provider fine-tune APIs | Full [fine-tuning](fine-tuning.md), quantization, any adapter |

Practical guidance:

- **Default: start with APIs.** Time-to-value dominates early; usage data tells you where self-hosting would pay.
- Self-hosting earns its keep when: strict data-residency rules API/VPC offerings can't meet, **sustained** high-volume narrow tasks (classification/extraction at millions of calls/day), or latency needs requiring co-location.
- The middle path many enterprises land on: **cloud-managed open/frontier models in your VPC** (Bedrock, Vertex, Azure) — provider-grade ops with tighter data boundaries.
- Whatever you choose, the [gateway](reference-architecture.md) keeps applications model-agnostic so the decision stays reversible. **Avoiding lock-in is worth real architectural effort; model quality-per-dollar shifts every quarter.**

## Decision 2: Vector store

Covered in [vector databases](vector-databases.md) — short version: extend what you run (pgvector/OpenSearch) until scale or feature needs force a dedicated engine.

## Decision 3: LLMOps tooling

Eval/tracing/prompt-registry tools (LangSmith, Langfuse, Arize, W&B) are cheap relative to building; **buy or adopt OSS**, but insist on OpenTelemetry-compatible export so the data outlives the vendor. Build only the thin glue to your CI and data stack.

## Decision 4: End applications

- **Buy** horizontal assistants (coding copilots, meeting summarizers, enterprise-search products) — vendors iterate faster than you will.
- **Build** where your differentiation lives: assistants over *your* proprietary data and workflows, LLM steps inside *your* [pipelines](data-pipelines-for-llms.md). This is also where your platform investments (retrieval service, governance) compound.

## The TCO trap checklist

Costs commonly missed when the spreadsheet says "build":

- Eval-set creation and continuous maintenance (ongoing, not one-time)
- Model deprecation treadmill (re-tune, re-eval, re-embed on every forced upgrade)
- GPU utilization reality (self-host math at 80% utilization, reality often 20–40%)
- Guardrail/security engineering and incident response
- The second and third use cases: platforms pay off across many; single-use "platforms" don't

## Related

- [Reference architecture](reference-architecture.md)
- [Cost optimization](cost-optimization.md)
- [Model serving](model-serving.md)
