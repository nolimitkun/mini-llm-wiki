---
title: LLM agents
category: agents-integration
updated: 2026-07-12
---

# LLM agents

An **agent** is an LLM in a loop with tools: the model decides what action to take, observes the result, and repeats until the task is done. Where a [RAG](rag-overview.md) app runs a fixed pipeline, an agent chooses its own steps.

```
        ┌─────────────────────────────┐
        ▼                             │
goal → LLM: reason, pick action → execute tool → observe result
        │
        └→ done? → final answer
```

## When an agent is (and isn't) the right shape

**Use a workflow (fixed steps)** when the task is predictable: summarize → classify → store. Cheaper, faster, testable, debuggable.

**Use an agent (model-chosen steps)** when the path genuinely varies: open-ended data questions, multi-source research, debugging, tasks where you can't enumerate the steps.

> Most "agent" products in production are mostly workflow with small agentic sections. Start with the least autonomy that solves the problem, and add loops only where the fixed pipeline demonstrably fails.

## Data-platform agents in practice

The patterns platform teams actually build:

- **Analytics agent (talk-to-your-data)**: tools = schema search, SQL execution (read-only!), chart rendering. Hard parts: schema/metric ambiguity — invest in a semantic layer and table documentation; the agent is only as good as your metadata.
- **Data engineering copilot**: tools = lineage lookup, dbt/pipeline runs, log search. Great for triage ("why is this table stale?").
- **Document processing agent**: routes, extracts, and validates across document types within a [pipeline](data-pipelines-for-llms.md).
- **Research/RAG agent**: iterative search-read-refine over corpora ([agentic RAG](rag-overview.md)).

## Engineering an agent responsibly

### Bound the loop
- **Max iterations and max cost per task** — runaway loops are the classic [cost incident](cost-optimization.md).
- Timeouts per tool call and per task.
- Explicit stop conditions ("if the same tool fails twice, report and stop").

### Constrain the blast radius
- Tools get **least privilege**: read-only DB roles, allowlisted APIs, scoped credentials — the agent's permissions are the *user's* permissions, never a super-role ([security](security-and-privacy.md)).
- Human approval gates for irreversible actions (writes, sends, deletes).
- Sandbox code execution.

### Manage context
Long tool outputs flood the [context window](context-windows.md): truncate/summarize observations, keep a compact scratchpad of decisions, paginate big results.

### Evaluate trajectories, not just answers
Agent [evals](evaluation.md) grade the *path*: right tool chosen? Sensible arguments? Recovered from errors? Finished within budget? Full [tracing](monitoring-and-observability.md) of every step is non-negotiable for debugging.

## Multi-agent systems

Orchestrator + specialist sub-agents helps when subtasks need different tools/contexts (research fan-out, code review panels). It multiplies cost and failure modes — reach for it only after a single agent with good tools has hit a ceiling.

## Related

- [Tool use & function calling](tool-use.md)
- [Model Context Protocol](mcp.md)
- [Security & privacy](security-and-privacy.md)
