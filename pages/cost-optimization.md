---
title: Cost optimization
category: inference-serving
updated: 2026-07-12
---

# Cost optimization

LLM spend surprises teams because it scales with **usage × verbosity**, not instance count. A feature that's cheap in a demo can be ruinous at production traffic. Cost work has three layers: measure, reduce per-request cost, reduce requests.

## 1. Measure first

You cannot optimize unattributed spend:

- **Meter every call** at the [gateway](reference-architecture.md): input tokens, output tokens, model, latency, plus `team / application / feature / user` tags.
- Build a **cost dashboard** per feature ([monitoring](monitoring-and-observability.md)) and unit-economics view: *cost per conversation / per document processed / per ticket deflected*.
- Set **budgets and alerts** per application; runaway agents and retry storms are the classic blowups. Hard caps (per-user, per-session) beat post-hoc invoices.

## 2. Cheaper per request

In rough order of ROI:

1. **Right-size the model per task.** The biggest lever — often 10–100×. Route classification/extraction/routing to small models; save frontier models for hard reasoning. Build **model routing** into the gateway (rule-based routing on task type covers most of the win; learned routers are a refinement). Validate with [evals](evaluation.md), not vibes.
2. **Prompt caching.** Providers discount cached prefix tokens 50–90%. Structure prompts static-first (system prompt, tool defs, few-shot examples), dynamic-last, and keep prefixes byte-stable.
3. **Trim the prompt.** Shorter system prompts, fewer/better [RAG chunks](retrieval-techniques.md) (reranking pays for itself), summarized [conversation history](context-windows.md), minified structured data ([tokenization](tokenization.md)).
4. **Cap and shape output.** Output tokens usually cost 3–5× input. Set `max_tokens`, ask for terse formats (JSON without prose), avoid "explain your reasoning" where you don't need it.
5. **Batch APIs** for async work — ~50% discounts; route [pipeline](data-pipelines-for-llms.md) workloads there by default.
6. **Distill.** For a stable high-volume task, [fine-tune](fine-tuning.md) a small model on the big model's outputs.
7. Self-hosting: [quantization and serving efficiency](inference-optimization.md); at sustained high utilization self-hosted open models undercut APIs, but include engineer time in the math ([build vs. buy](build-vs-buy.md)).

## 3. Fewer requests

- **Response caching** — exact-match on normalized (prompt, model, params) hash; add semantic caching (embedding-similarity lookup) only for genuinely repetitive query streams, with a human check on false-hit risk.
- **Precompute** — if users always ask for a summary, generate it at ingestion, not per view.
- **Debounce and gate** — don't call the model on every keystroke; require explicit action or batch UI events.
- **Kill zombie loops** — cap agent iterations and tool-call counts ([agents](agents.md)).

## Worked example

Support assistant, 10k queries/day: 3k-token prompt (2k of it a static system+tools prefix), 500-token output on a frontier model at $3/M input, $15/M output → `(3k×$3 + 0.5k×$15)/1M ≈ $0.0165/query ≈ $165/day`. Prompt caching on the 2k prefix (90% off) + routing 60% of queries to a small model ($0.25/$1.25) cuts it to roughly **$45/day** — same UX, 3.7× cheaper.

## Related

- [Inference optimization](inference-optimization.md)
- [Monitoring & observability](monitoring-and-observability.md)
- [Build vs. buy](build-vs-buy.md)
