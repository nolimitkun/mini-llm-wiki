---
title: Reference architecture
category: platform-architecture
updated: 2026-07-12
---

# Reference architecture

A composable architecture for running LLM workloads on an enterprise data/AI platform. The parts are independent — adopt the gateway first, grow the rest as usage matures.

## The big picture

```
┌───────────────────────────── applications ─────────────────────────────┐
│  chat assistants │ copilots │ agents │ pipeline jobs (extract/classify) │
└────────┬────────────────────────────────────────────────────┬──────────┘
         │                                                    │
┌────────▼──────────────┐                        ┌────────────▼──────────┐
│   LLM GATEWAY         │                        │  RETRIEVAL SERVICE     │
│ auth / quotas /       │                        │ query processing,      │
│ routing / caching /   │                        │ hybrid search, rerank, │
│ guardrails / logging  │                        │ ACL filtering          │
└────────┬──────────────┘                        └────────────┬──────────┘
         │                                                    │
┌────────▼──────────────┐    ┌───────────────┐   ┌────────────▼──────────┐
│  MODEL LAYER          │    │  LLMOPS       │   │  KNOWLEDGE LAYER       │
│ provider APIs,        │    │ eval harness, │   │ vector DB + keyword    │
│ self-hosted (vLLM),   │    │ tracing,      │   │ index, doc store,      │
│ fine-tuned variants   │    │ prompt reg.,  │   │ embedding pipelines    │
└───────────────────────┘    │ dashboards    │   └────────────┬──────────┘
                             └───────────────┘   ┌────────────▼──────────┐
                                                 │  DATA PLATFORM         │
                                                 │ lake/warehouse, source │
                                                 │ connectors, orchestr., │
                                                 │ catalog & lineage      │
                                                 └───────────────────────┘
```

## Component responsibilities

### LLM gateway — build this first
Single egress point for all model traffic. Provides: authN/Z per app/team, **model routing** (task → model, failover, [cost-based routing](cost-optimization.md)), rate limiting & budgets, prompt/response **caching**, [guardrails](security-and-privacy.md) (PII, injection screening), and full [audit logging](monitoring-and-observability.md). Options: LiteLLM, Portkey, Kong/cloud-native AI gateways, or a thin in-house proxy. Without a gateway, every one of these concerns is re-solved (badly) per team.

### Model layer
Provider APIs, self-hosted open weights ([serving](model-serving.md)), and [fine-tuned](fine-tuning.md) variants — all behind the gateway so applications are model-agnostic. Keep a model registry: which versions are approved, for which data classes ([governance](data-governance.md)).

### Knowledge layer
[Vector + keyword indexes](vector-databases.md) fed by [ingestion pipelines](data-pipelines-for-llms.md), with a **retrieval service** ([techniques](retrieval-techniques.md)) exposing search-as-an-API so every application gets hybrid search, reranking, and **ACL filtering** without reimplementing them. Expose it to agents via [MCP](mcp.md).

### LLMOps layer
[Eval harness](evaluation.md) wired into CI, [tracing/monitoring](monitoring-and-observability.md), [prompt registry](prompt-management.md), cost dashboards.

### Data platform (the foundation you already have)
Warehouse/lake as source of truth, orchestrator running embedding and enrichment jobs, catalog providing the metadata that powers retrieval filters and text-to-SQL, lineage extended to cover derived AI stores.

## Adoption sequence

1. **Gateway + logging + budgets** — control and visibility before anything scales.
2. **First RAG use case end-to-end** — one corpus, one app, with an eval set from day one.
3. **Shared retrieval service** — when the second and third use cases arrive, extract the common pipeline.
4. **Eval-gated CI + guardrails hardening** — before high-stakes or external-facing launches.
5. **Routing/cost optimization, fine-tuning, agents** — maturity features once fundamentals hold.

## Related

- [Build vs. buy](build-vs-buy.md)
- [Security & privacy](security-and-privacy.md)
- [LLMOps overview](llmops-overview.md)
