---
title: Alignment (RLHF & friends)
category: training-adaptation
updated: 2026-07-12
---

# Alignment (RLHF & friends)

**Alignment** (post-training) turns a raw [pretrained](pretraining.md) text-completer into a helpful, safe assistant. It's why chat models follow instructions, refuse harmful requests, and say "I don't know." Platform teams rarely *run* alignment, but its effects shape everything you build on top.

## The standard recipe

1. **Supervised fine-tuning (SFT)** — train on curated (instruction → good response) demonstrations. Teaches format and instruction-following.
2. **Preference optimization** — collect human (or AI) rankings of candidate responses, then optimize toward preferred ones:
   - **RLHF**: train a reward model on preferences, optimize the LLM against it with RL (PPO). The classic approach.
   - **DPO** and successors: optimize directly on preference pairs, skipping the reward model — simpler and now widespread.
   - **RLAIF / Constitutional AI**: AI feedback guided by written principles replaces most human labeling.
3. **Reasoning-focused RL** (newer): RL against verifiable rewards (math, code tests) — the technique behind "reasoning models" that think step-by-step before answering.

## Why this matters when you *consume* models

- **Refusals & tone are trained-in.** Over-refusal on benign domain queries (medical, security, legal) is an alignment artifact; you handle it with prompt context ("you are assisting licensed clinicians…"), not by "jailbreaking".
- **Sycophancy.** Preference-trained models tend to agree with users; don't build validation flows that ask the model "am I right?".
- **Verbosity bias.** Preference data rewards thorough-looking answers; be explicit about brevity in prompts.
- **Instruction hierarchy.** Models are trained to prioritize system prompts over user messages — the foundation of your [prompt-injection defenses](security-and-privacy.md), though it's probabilistic, not a guarantee.
- **Model updates change behavior.** Providers re-align continuously; a version bump can shift refusal boundaries and formats — pin versions and [re-run evals on upgrades](evaluation.md).

## Alignment ≠ your guardrails

Provider alignment is generic. Your application still needs its own policy layer:

- Input/output filters for *your* rules (topics, PII, compliance wording),
- [Grounding requirements](rag-overview.md) for factual claims,
- Domain-specific refusal behavior defined in system prompts and tested in [evals](evaluation.md).

Think of alignment as the factory safety settings; your platform adds the site-specific interlocks.

## Related

- [Pretraining](pretraining.md)
- [Fine-tuning](fine-tuning.md)
- [Security & privacy](security-and-privacy.md)
