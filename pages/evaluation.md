---
title: Evaluation
category: llmops
updated: 2026-07-12
---

# Evaluation

Evaluation is the load-bearing practice of [LLMOps](llmops-overview.md): without it, every prompt tweak, model upgrade, and retrieval change is a guess. The goal is an **eval harness you trust enough to gate releases**.

## Three tiers

| Tier | What | When |
|---|---|---|
| **Offline evals** | Golden dataset scored automatically | Every change, in CI |
| **Human review** | Experts grade samples | Calibrate judges; high-stakes launches |
| **Online signals** | User feedback, task completion, A/B tests | Continuously in production |

## Building the golden dataset

- **50–200 examples** to start; grow it from production failures (every incident becomes a test case).
- Sources: real logs (best), expert-written, LLM-generated + human-reviewed.
- Cover the distribution: easy cases, hard cases, edge cases, adversarial inputs, and **should-refuse** cases.
- Version it; keep it out of any fine-tuning data (decontamination).
- Per-example: input, expected output (or rubric), and metadata (category, difficulty) so you can slice scores.

## Scoring methods

**Deterministic checks (use whenever possible):** exact/regex match for classification & extraction, JSON-schema validation for structured output, unit-test execution for generated code, contains/excludes assertions for policy compliance. Cheap, fast, no calibration needed.

**LLM-as-judge (for free text):** a strong model scores outputs against a rubric. Make it reliable:

- One criterion per judge call (correctness, groundedness, tone — separately), with the rubric and 2–3 scored examples in the judge prompt.
- Prefer **pairwise comparison** (A vs. B) over absolute scores for change decisions — much more stable.
- **Calibrate against human labels** (≥ 80–90% agreement) before trusting it; re-check quarterly.
- Known biases: position (randomize order), verbosity (longer ≠ better), self-preference (judge from a different model family when comparing models).

**Task-specific:** [RAG has its own metric stack](rag-evaluation.md) (retrieval recall + faithfulness); [agents](agents.md) need trajectory-level evals (did it pick the right tools, in a sane order, and finish?).

## Evals as CI

```
PR changes prompt/model/retrieval config
  → run eval suite → score vs. baseline
  → regression beyond threshold? block merge
  → pass? deploy canary → online metrics confirm
```

Practical notes: pin the judge model version; use temperature 0 where supported (and accept residual nondeterminism — run 3× and average on flaky suites); keep the suite under ~15 min so people actually run it; alert on *eval-set staleness* (no new cases added in a month means you're not learning from production).

## Benchmarks vs. your evals

Public benchmarks (MMLU, HumanEval, arena Elo) are useful for **shortlisting models**, useless for **your application** — they're contaminated, generic, and don't include your data. The workflow: shortlist by benchmark + price, decide by running *your* golden set against each candidate.

## Related

- [Evaluating RAG systems](rag-evaluation.md)
- [Monitoring & observability](monitoring-and-observability.md)
- [Prompt management](prompt-management.md)
