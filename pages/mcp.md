---
title: Model Context Protocol (MCP)
category: agents-integration
updated: 2026-07-12
---

# Model Context Protocol (MCP)

**MCP** is an open protocol (introduced by Anthropic, late 2024; since adopted across the industry) that standardizes how LLM applications connect to external systems. It solves the M×N integration problem: instead of every AI app writing custom connectors for every data source, a source exposes one **MCP server** and any **MCP client** (Claude, IDEs, custom agents) can use it.

Think: **USB-C for AI integrations** — or, for data folks, **what JDBC/ODBC did for databases**.

## Architecture

```
┌────────────┐        ┌─────────────┐       ┌──────────────┐
│ MCP host   │        │ MCP server  │       │ Real system  │
│ (AI app /  │◄──────►│ (connector) │◄─────►│ (warehouse,  │
│  agent)    │  JSON-  │             │  API/ │  wiki, APIs) │
│ + client   │  RPC    │             │  SQL  │              │
└────────────┘        └─────────────┘       └──────────────┘
```

Transports: **stdio** (local process) or **HTTP** (remote, with OAuth). One host can connect many servers simultaneously.

## What a server exposes

| Primitive | What | Analogy |
|---|---|---|
| **Tools** | Functions the model can call ([tool use](tool-use.md)) | POST endpoints |
| **Resources** | Readable data (files, tables, docs) addressed by URI | GET endpoints |
| **Prompts** | Reusable prompt templates the user can invoke | Slash commands |

Clients discover all three at connect time — no hardcoding.

## Why data platform teams should care

MCP is becoming the standard interface between AI assistants and the data stack:

- **Expose once, use everywhere.** One MCP server for your warehouse (schema browsing, read-only SQL, semantic-layer metrics) serves every AI tool in the company — instead of one integration per assistant.
- **Ecosystem servers already exist** for Postgres, Snowflake, BigQuery, dbt, GitHub, Slack, Confluence, and hundreds more — evaluate before building.
- **Governance chokepoint.** A warehouse MCP server is the natural place to enforce read-only roles, row-level security, query cost caps, and audit logging for AI-driven access ([governance](data-governance.md)).

## Building a server: practical notes

- SDKs exist for Python, TypeScript, and most major languages; a minimal tools-only server is an afternoon of work.
- Apply every rule from [tool design](tool-use.md): sharp descriptions, compact results, helpful errors.
- **Security is yours to enforce**: authenticate the caller, scope credentials per user (OAuth passthrough for remote servers), never embed a super-role service account. Treat third-party MCP servers like any dependency — review before install; a malicious server sees your agent's context and can inject instructions ([security](security-and-privacy.md)).
- Version your tool schemas; clients cache them, and silent breaking changes cause confusing agent failures.

## Related

- [Tool use & function calling](tool-use.md)
- [LLM agents](agents.md)
- [Reference architecture](reference-architecture.md)
