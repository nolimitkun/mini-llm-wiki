---
title: LLMOps
category: genai-platform
updated: 2026-07-13
sources: [sources/2026-07-open-source-project-comparisons.md]
---

# LLMOps

**LLMOps** is [MLOps](mlops.md) adapted to systems where you don't own the model, outputs are free text, and the unit of change is a prompt or retrieval config. The operating loop is the same — evaluate, gate, deploy, monitor, learn — but every station is rebuilt for nondeterminism.

## The config surface (version all of it, together)

An LLM application's behavior = prompt template × model+version × sampling params × retrieval config ([RAG](rag.md): embedding model, chunking, k, reranker) × tool definitions ([agents-and-mcp.md](agents-and-mcp.md)) × guardrail config. A change to any one is a **release** and goes through the eval gate. A logged output is reproducible only if all of them were logged with it.

## Evaluation

- **Golden dataset** (50–200 cases, grown from production failures): real queries, expected outputs or rubrics, hard cases, should-refuse cases.
- **Deterministic checks first**: schema validation, exact match for classification/extraction, executable tests for generated code/SQL.
- **LLM-as-judge for free text**: one criterion per call (correctness, groundedness, tone), rubric + examples in the judge prompt, pairwise comparison for change decisions, **calibrated against human labels** (≥80–90% agreement) before trusting trends.
- **Evals as CI**: prompt/model/retrieval PRs run the suite; regressions block; canary after. Provider model upgrades are dependency bumps — re-run everything.
- Public benchmarks shortlist models; only *your* golden set decides.

## Monitoring

Route all model traffic through one **gateway** and log per request: full config versions, input/output (per [data policy](data-governance.md) — these logs contain user data), retrieved chunk IDs, tool calls, tokens, cost, latency, user feedback. Four signal layers:

1. **System**: availability, time-to-first-token, rate-limit rejections.
2. **Cost**: spend per feature/team, anomaly alerts — runaway loops surface here first ([finops.md](finops.md)).
3. **Quality**: judge-scored production samples (1–5%), thumbs-up/down, regenerate rate, refusal rate, retrieval-score distributions (falling p50 = corpus losing coverage).
4. **Safety**: guardrail trigger rates, injection flags ([data-security-and-privacy.md](data-security-and-privacy.md)).

Close the loop: low-scored samples → human review → golden set. That flow is the difference between logging and learning.

## Prompt management

Prompts are production code in English: versioned in git/a registry with the model version they were tested against; templated with typed variables (log the *rendered* prompt — template bugs that drop context produce confident hallucinations); deployed decoupled from app releases but always through the eval gate. Anti-patterns: prompts inline in code, one mega-prompt serving five features, instruction accretion after every incident until 4k tokens of contradictions — periodically rewrite against the eval set.

## Open source project comparison

| Project | LLMOps role | Watch-outs |
|---|---|---|
| **Langfuse** | Traces, prompt management, datasets, evals, cost/latency visibility | Strong OSS default; self-hosting includes Postgres/ClickHouse/Redis-style ops |
| **Phoenix / OpenInference** | Tracing, evaluation, retrieval analysis, OpenTelemetry-adjacent AI observability | Strong for observability workflows; prompt/product management differs from Langfuse |
| **MLflow Tracing / AI Gateway** | Teams already standardizing MLflow for classic ML and GenAI together | Good shared spine; depth varies by LLMOps feature |
| **LiteLLM** | Gateway logs, budgets, routing, provider abstraction | Operational control point, not a complete eval/trace product |
| **DeepEval / Ragas / promptfoo** | Offline eval suites for RAG, prompts, and model comparisons | Great CI tools; production feedback loops still need tracing and review workflow |
| **OpenTelemetry** | Standard traces/metrics/logs across app and model calls | Standard substrate; LLM-specific semantics need conventions or wrappers |

Langfuse is the practical OSS center; add eval libraries for CI and OpenTelemetry when platform-wide observability standardization matters.

## Related

- [mlops.md](mlops.md)
- [rag.md](rag.md)
- [finops.md](finops.md)
