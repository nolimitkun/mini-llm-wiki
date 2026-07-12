---
title: Pretraining
category: training-adaptation
updated: 2026-07-12
---

# Pretraining

**Pretraining** is the first and most expensive phase of building an LLM: training a [Transformer](transformer-architecture.md) from random weights on trillions of tokens with a next-token-prediction objective. The result is a **base model** — a powerful text completer with broad knowledge but no instruction-following behavior (that comes from [alignment](alignment.md)).

Very few organizations pretrain from scratch; for a platform team the value is understanding **what pretraining implies about the models you consume**.

## What goes in

- **Data**: web crawls (heavily filtered), code, books, academic text, curated high-quality sources. Data curation — dedup, quality filtering, mixture weighting — is a major differentiator between models, echoing the same [quality principles](data-quality-and-curation.md) as any data platform, at extreme scale.
- **Compute**: thousands of accelerators for weeks/months; frontier runs cost tens to hundreds of millions of dollars.
- **Scaling laws**: loss falls predictably with parameters, data, and compute (Chinchilla-style laws guide the ratio — many production models are trained on far more tokens than "optimal" to make them cheaper to *serve*).

## What pretraining implies downstream

- **Knowledge cutoff.** The model knows nothing after its training data ends — the root reason [RAG](rag-overview.md) exists.
- **Distributional strengths.** Models are best at what was plentiful in training data (English, popular languages/frameworks) and weaker at the rare (niche domains, low-resource languages) — a driver for [fine-tuning](fine-tuning.md) or heavy retrieval in specialized domains.
- **Memorization & leakage.** Verbatim training data can resurface; providers mitigate but it informs [privacy posture](security-and-privacy.md).
- **Biases** in the corpus become biases in the model; evaluation on *your* population matters more than leaderboard scores.

## Continued pretraining (domain-adaptive pretraining)

The one pretraining-adjacent activity enterprises sometimes do: take an open-weights base model and continue next-token training on a large domain corpus (legal, biomedical, internal code — typically billions of tokens). Sits between pretraining and [fine-tuning](fine-tuning.md); expensive, requires ML expertise, and usually only justified when the domain vocabulary/style is far from the base distribution and RAG + fine-tuning have hit their ceiling.

## Base vs. instruct models

| | Base | Instruct/chat |
|---|---|---|
| Behavior | Completes text | Follows instructions, converses |
| Produced by | Pretraining | Pretraining + [alignment](alignment.md) |
| Platform use | Fine-tuning starting point, research | Everything user-facing |

If a model answers your question with another question or rambles into a fake dialogue, you're probably holding a base model.

## Related

- [Alignment](alignment.md)
- [Fine-tuning](fine-tuning.md)
- [Build vs. buy](build-vs-buy.md)
