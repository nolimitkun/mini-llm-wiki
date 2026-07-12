---
title: Tool use & function calling
category: agents-integration
updated: 2026-07-12
---

# Tool use & function calling

**Tool use** (function calling) lets an LLM interact with the world: you describe available functions in the request; the model responds with a structured call (`name` + JSON arguments); **your code executes it** and returns the result for the model to continue with. The model never runs anything itself — your runtime is the enforcement point.

## The loop

```
1. Request:  messages + tool schemas
2. Model:    {"tool": "query_warehouse", "args": {"sql": "SELECT ..."}}
3. Your app: validate → execute → capture result
4. Request:  ... + tool result appended
5. Model:    final answer (or another tool call)
```

## Designing good tools

Tool design is API design where the caller is a probabilistic model. What works:

- **Descriptions are prompts.** The model chooses tools based on names + descriptions. Say what it does, when to use it, when *not* to, and what it returns. Vague descriptions → wrong tool choices.
- **Few, distinct tools.** Overlapping tools confuse selection. Prefer one `search_documents(query, source_type)` over five near-identical search tools. Practical ceiling: ~10–20 well-differentiated tools per agent before selection quality degrades.
- **Forgiving parameters.** Enums over free strings, defaults for optional args, and validation with **helpful error messages returned to the model** — "date must be YYYY-MM-DD, got 'yesterday'" lets it self-correct; a bare 400 doesn't.
- **Token-conscious returns.** Tool results land in the [context window](context-windows.md). Return compact summaries + IDs with a `get_details(id)` follow-up tool, paginate big result sets, strip fields the model doesn't need.
- **Idempotent where possible**; models occasionally repeat calls.

## Structured output — the same machinery

Constraining a model to emit schema-valid JSON (provider "structured output" modes, or one mandatory tool) is the backbone of LLMs in [data pipelines](data-pipelines-for-llms.md): extraction, classification, routing. Always validate server-side anyway and reject-retry on violations ([quality contracts](data-quality-and-curation.md)).

## Security: your code is the boundary

Everything an LLM "does" it does through your executor, so enforce there:

- **Authorization per call**: the *end user's* permissions, checked at execution time — not a service account with god-mode ([security](security-and-privacy.md)).
- **Validate arguments** like untrusted input (they are): SQL gets a read-only role + query allowlist/analysis; file paths get canonicalization; shell is avoided entirely.
- **Treat tool *results* as untrusted too** — a retrieved document or API response can contain prompt-injection text that steers the next model step. Sanitize/flag content crossing into context.
- **Log every call + args + result** for [tracing](monitoring-and-observability.md) and audit.

## Failure modes to test

- Wrong tool for the task (eval with [trajectory tests](agents.md)).
- Hallucinated arguments (nonexistent column/ID — return correcting errors).
- Ignoring tool results and answering from memory (instruct: "base your answer on the tool result").
- Infinite retry of a failing tool (cap attempts, surface the failure in the final answer).

## Related

- [LLM agents](agents.md)
- [Model Context Protocol](mcp.md)
- [Evaluation](evaluation.md)
