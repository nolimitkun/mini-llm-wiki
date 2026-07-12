---
title: Agents & MCP
category: genai-platform
updated: 2026-07-12
---

# Agents & MCP

An **agent** is an LLM in a loop with tools: it decides an action, your code executes it, the result feeds the next decision — until the task completes. **MCP** (Model Context Protocol) is the open standard for wiring those tools to real systems. Together they're how AI stops summarizing your platform's data and starts *operating* on it — which is exactly why the platform team must own the guardrails.

## Tool use: the mechanism

The model emits a structured call (`{"tool": "query_metrics", "args": {...}}`); **your runtime validates and executes it** — the model never touches anything directly, making your executor the enforcement point. Tool design rules: descriptions are prompts (say when to use and when not); few, distinct tools beat many overlapping ones; return compact results (they consume context); return *helpful* errors so the model self-corrects; validate arguments like the untrusted input they are.

## Agents on the data platform

| Pattern | Tools | The hard part |
|---|---|---|
| Analytics agent ("talk to your data") | [Semantic-layer](semantic-layer.md) metrics, read-only SQL, chart rendering | Metric ambiguity — the agent is only as good as your [modeling](data-modeling.md) and metadata |
| Data-engineering copilot | [Lineage](data-catalog-and-lineage.md) lookup, pipeline status, log search | Great at triage ("why is this table stale?") |
| Document/pipeline agents | Extraction, routing, validation in [pipelines](data-transformation.md) | Output contracts and sampling ([data-quality.md](data-quality.md)) |

Use a fixed **workflow** when steps are predictable; reserve true agent loops for genuinely variable paths — most production "agents" are workflows with small agentic sections.

## MCP: the integration standard

An MCP server exposes **tools**, **resources**, and **prompts** over a standard protocol; any MCP client (Claude, IDEs, custom agents) can use it — solving M×N integration the way JDBC did for databases. For platform teams: **expose the warehouse/semantic layer/catalog once via MCP**, and every AI assistant in the company gets governed access — the MCP server becomes the natural chokepoint for read-only roles, row-level security, query cost caps, and audit logging. Ecosystem servers exist for most data tools; review third-party ones like any dependency (they see your agent's context).

## The safety engineering (non-negotiable)

- **Least privilege**: tools run with the *end user's* permissions, checked at execution time — never a god-mode service account ([data-security-and-privacy.md](data-security-and-privacy.md)).
- **Bound the loop**: max iterations, per-task cost caps, tool-call timeouts — runaway agents are [cost](finops.md) *and* safety incidents.
- **Approval gates** for irreversible actions (writes, sends, deletes); sandbox code execution; egress allowlists.
- **Assume prompt injection succeeds**: any retrieved document or tool result can carry hostile instructions; the defense is limiting what the agent *can do*, not hoping the model ignores them.
- **Trace everything**: every step (prompt, tool, args, result) logged — required for debugging trajectories and for audit ([llmops.md](llmops.md)).
- **Evaluate trajectories**, not just answers: right tool? sane order? recovered from errors? finished within budget?

## Related

- [llms-on-the-platform.md](llms-on-the-platform.md)
- [semantic-layer.md](semantic-layer.md)
- [data-security-and-privacy.md](data-security-and-privacy.md)
