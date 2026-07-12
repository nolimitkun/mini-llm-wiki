---
title: Prompt management
category: llmops
updated: 2026-07-12
---

# Prompt management

Prompts are **production code that happens to be English**: they encode business logic, change frequently, and break things when edited casually. Manage them with the same rigor as code — plus a few LLM-specific practices.

## Prompt engineering, the durable 20%

Techniques that keep mattering across model generations:

- **Structure**: role/goal → instructions → constraints → few-shot examples → context → the task. Use delimiters (XML tags, headers) so the model can tell instructions from data — also your first [injection defense](security-and-privacy.md).
- **Few-shot examples** beat abstract instructions for format and edge-case behavior; 2–5 well-chosen examples is the sweet spot.
- **Explicit output contracts**: schema, length, tone, and what to do when unsure ("If the context doesn't contain the answer, say so"). Use provider structured-output/JSON modes rather than begging for valid JSON.
- **Positive instructions** ("respond in formal English") outperform prohibitions ("don't be casual").
- **Reasoning space**: for hard tasks, let the model think before answering (chain-of-thought or native reasoning modes) — but skip it for simple tasks where it just adds [cost](cost-optimization.md).
- **Put static content first** to exploit prompt caching.

## Managing prompts like artifacts

### Version control
Prompts live in git (or a prompt-registry tool that versions them): template + variables, model + params it was tested with, changelog. **A prompt version is meaningless without its model version** — pin and record both ([LLMOps config surface](llmops-overview.md)).

### Separate deploy from code
Decouple prompt releases from app deploys (config service or registry) so prompt iteration doesn't need a full release train — but keep the [eval gate](evaluation.md): every prompt change runs the golden set before rollout, canaries after.

### Templates, not string soup
Use a real template system (Jinja-style) with typed variables. Test the *rendering* too — a template bug that silently drops the retrieved context produces confident hallucinations, and only [tracing](monitoring-and-observability.md) of the final rendered prompt catches it. Always log the rendered prompt (or its hash), not just template + version.

### Registry metadata worth keeping

```yaml
prompt: support-answer
version: 14
model: claude-sonnet-5 (pinned)
params: { temperature: 0.2, max_tokens: 800 }
eval: golden-support-v9 → 0.91 groundedness (baseline 0.89)
owner: support-ai-team
changelog: "Added refusal instruction for legal questions"
```

## Anti-patterns

- Prompts inline in application code, edited in hotfixes, never evaluated.
- One mega-prompt serving five features — split per use case; they'll diverge anyway.
- Copying "prompt hacks" between models — behaviors are model-specific; re-evaluate on your own set.
- Accreting instructions after every incident until the prompt is 4k tokens of contradictory rules — periodically rewrite from scratch against the eval set.

## Related

- [Evaluation](evaluation.md)
- [LLMOps overview](llmops-overview.md)
- [Context windows](context-windows.md)
