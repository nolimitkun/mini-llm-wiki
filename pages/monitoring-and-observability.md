---
title: Monitoring & observability
category: llmops
updated: 2026-07-12
---

# Monitoring & observability

LLM observability answers two questions classic APM can't: **"what exactly did we send and get back?"** and **"was it any good?"**. You need both the plumbing metrics and the quality signals.

## Instrument at the gateway

Route all model traffic through one [gateway](reference-architecture.md) and log per request:

```
trace_id, timestamp, user/team/app/feature tags,
model + version, prompt template version, sampling params,
full input (or hash, per data policy), retrieved chunk IDs,
tool calls + results, full output, finish_reason,
input/output token counts, cost, TTFT, total latency,
guardrail verdicts, user feedback (if any)
```

For multi-step [agents](agents.md), use **traces with spans** (OpenTelemetry GenAI semantic conventions are the emerging standard) so a bad answer can be debugged step by step: which retrieval, which tool call, which prompt produced it. Purpose-built tools: LangSmith, Langfuse (OSS), Arize Phoenix, W&B Weave — or your existing observability stack with GenAI conventions.

**Log retention is a governance issue** — prompts/outputs contain user data; apply the same classification and retention policy as the underlying sources ([governance](data-governance.md)).

## The four signal layers

### 1. System health
Availability (incl. provider errors), TTFT / latency percentiles, rate-limit rejections, queue depth. Alert like any service.

### 2. Cost
Tokens & spend by app/feature/team, cost per unit of work, anomaly alerts (retry storms and runaway agents show up here first). See [cost optimization](cost-optimization.md).

### 3. Quality (the LLM-specific layer)
- **Sampled judge scoring**: run [LLM-as-judge](evaluation.md) on a sample (e.g., 1–5%) of production traffic — groundedness, relevance, policy compliance — and trend it.
- **User feedback**: thumbs up/down, regenerate-rate, copy-rate, task completion. Sparse but honest.
- **Proxy signals**: refusal rate, "I don't know" rate, output-schema violation rate, retrieval-score distributions, conversation length (frustration shows up as long threads).

### 4. Safety & security
Guardrail trigger rates (PII, injection detection), unusual usage patterns per user, prompts flagged for review ([security](security-and-privacy.md)).

## Drift without model drift

Even with a pinned model, behavior drifts because **inputs drift**: new user intents, corpus growth, seasonal topics. Watch input-side distributions (query clusters, retrieval score percentiles, language mix) — a falling retrieval-score p50 means your corpus is losing coverage ([curation](data-quality-and-curation.md)). And when the provider *does* upgrade the model, treat it as a change event: re-run [evals](evaluation.md), compare production metrics week-over-week.

## Close the loop

Monitoring is only useful if findings flow back: low-scored samples → human review queue → labeled → appended to the golden eval set → next release is tested against them. This loop is the difference between logging and learning.

## Related

- [Evaluation](evaluation.md)
- [Cost optimization](cost-optimization.md)
- [Data governance](data-governance.md)
