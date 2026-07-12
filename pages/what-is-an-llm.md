---
title: What is an LLM?
category: fundamentals
updated: 2026-07-12
---

# What is an LLM?

A **Large Language Model (LLM)** is a neural network — almost always a [Transformer](transformer-architecture.md) — trained on massive text corpora to predict the next [token](tokenization.md) in a sequence. From that single objective emerge capabilities like summarization, translation, code generation, reasoning, and tool use.

## Key properties

| Property | What it means in practice |
|---|---|
| Autoregressive | Generates one token at a time, each conditioned on everything before it |
| Probabilistic | Same prompt can yield different outputs; controlled via temperature/top-p |
| Frozen knowledge | Knows nothing after its training cutoff unless you supply context ([RAG](rag-overview.md)) |
| Context-bounded | Can only "see" what fits in its [context window](context-windows.md) |
| Stateless | No memory between API calls; state must be managed by the application |

## The LLM lifecycle

1. **Pretraining** — next-token prediction over trillions of tokens ([details](pretraining.md)).
2. **Post-training / alignment** — instruction tuning and preference optimization make a raw model useful and safe ([details](alignment.md)).
3. **Adaptation** — [fine-tuning](fine-tuning.md), prompting, or retrieval to specialize for a domain.
4. **Serving** — hosting the model behind an API ([details](model-serving.md)).
5. **Operation** — [evaluation](evaluation.md), [monitoring](monitoring-and-observability.md), iteration.

## Why LLMs matter for data platforms

LLMs change what a data platform must provide:

- **Unstructured data becomes first-class.** Documents, tickets, transcripts, and logs are now queryable assets — they need [pipelines](data-pipelines-for-llms.md), [quality checks](data-quality-and-curation.md), and [governance](data-governance.md) just like tables.
- **New storage primitives.** [Embeddings](embeddings.md) and [vector databases](vector-databases.md) join the warehouse and lake.
- **New ops discipline.** Non-deterministic outputs require [LLMOps](llmops-overview.md) practices distinct from classic MLOps.

## Common misconceptions

- *"The model looks things up."* — It doesn't. Generation is pattern completion from learned weights plus whatever is in the prompt.
- *"Bigger is always better."* — Smaller models with good retrieval and prompting often beat larger ones on domain tasks at a fraction of the [cost](cost-optimization.md).
- *"Hallucinations are bugs to be patched."* — They're inherent to probabilistic generation; you mitigate them with grounding, evaluation, and guardrails, not a fix.

## Related

- [Transformer architecture](transformer-architecture.md)
- [Reference architecture for an LLM platform](reference-architecture.md)
- [Glossary](glossary.md)
