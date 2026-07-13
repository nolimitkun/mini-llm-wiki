---
title: LLMs on the data platform
category: genai-platform
updated: 2026-07-13
sources: [sources/2026-07-open-source-project-comparisons.md]
---

# LLMs on the data platform

Large language models join the platform as a new kind of consumer *and* producer: they read your data at runtime (retrieval, [agents](agents-and-mcp.md)), write derived data back (extraction, classification), and are consumed through prompts and APIs rather than trained in-house. This page is the platform team's working model of LLMs; the deep dives are [rag.md](rag.md), [embeddings.md](embeddings.md), [llmops.md](llmops.md), and [agents-and-mcp.md](agents-and-mcp.md).

## The minimum viable mental model

- LLMs generate text one **token** at a time (≈ 0.75 words); tokens are the unit of **cost, latency, and capacity**.
- The **context window** (128k–1M+ tokens) is all the model "knows" beyond its frozen training data — everything else must be *put there* by your systems. That's why the data platform matters: grounding an LLM is a data engineering problem.
- Outputs are **probabilistic**: same input, varying output; hallucination is inherent and managed (grounding, evaluation, guardrails), not patched.
- Models are **stateless per call** and **change under you** (provider updates): pin versions, evaluate on upgrade ([llmops.md](llmops.md)).

## What LLMs demand from the platform

| Demand | Platform response |
|---|---|
| Runtime access to documents/knowledge | Ingestion of unstructured content, [RAG](rag.md) indexes, [vector databases](vector-databases.md) — with source ACLs enforced at query time ([data-security-and-privacy.md](data-security-and-privacy.md)) |
| Structured data answers | [Semantic layer](semantic-layer.md) + governed SQL access — text-to-SQL over raw schemas fails; over metrics it works |
| Freshness | Index update SLOs in [pipelines](data-ingestion.md); deletion propagation ([data-governance.md](data-governance.md)) |
| Cost control | Token metering, budgets, caching, model routing at a **gateway** ([reference-architecture.md](reference-architecture.md), [finops.md](finops.md)) |

## What LLMs offer the platform (as pipeline operators)

Extraction (unstructured → structured), classification/tagging at scale, summarization, data cleaning — LLM steps inside [transformation pipelines](data-transformation.md). Treat the model as an untrusted producer: schema-validate outputs, pin model+prompt versions, cache on input hash, sample into evaluation, mark provenance columns ([data-quality.md](data-quality.md)).

## Adaptation options, in cost order

1. **Prompting** (+ few-shot examples): always first; most tasks end here.
2. **RAG**: knowledge that's private, fresh, or access-controlled ([rag.md](rag.md)).
3. **Fine-tuning** (usually LoRA adapters): *behavior and format*, not facts — needs 500+ curated examples and an eval set; also used to distill big-model behavior into cheap small models.
4. Self-hosting / continued pretraining: rarely justified — see [build-vs-buy.md](build-vs-buy.md).

## Consuming models well

Provider APIs behind a **gateway** (auth, quotas, logging, routing, caching, failover) are the default; self-hosted open weights (vLLM-class serving — [model-serving.md](model-serving.md)) enter for residency or sustained-volume economics. Either way: pin model versions, stream user-facing responses, meter everything.

## Open source project comparison

| Project | Platform role | Watch-outs |
|---|---|---|
| **vLLM** | High-throughput open-weight LLM serving with continuous batching and KV-cache efficiency | GPU ops and model evaluation remain yours; pair with a gateway and observability |
| **Ollama** | Local development, demos, edge/small self-hosted models | Great ergonomics, not the high-scale serving default |
| **LiteLLM** | Gateway/routing layer across OpenAI-compatible APIs, open models, and providers | Gateway, not model server; enforce auth, budgets, and logs here |
| **Open WebUI** | Internal chat UI over local/provider models | Useful interface, not an enterprise LLM platform by itself |
| **LangChain / LlamaIndex / Haystack / LangGraph** | Application frameworks for RAG, tools, agents, retrieval, workflows | Framework choice should not own your data contracts; keep platform primitives underneath |
| **Mistral/Qwen/Llama/DeepSeek open weights** | Self-hosted or privately deployed foundation models | License, safety, eval quality, and serving cost vary by model family and release |

The platform default is provider APIs behind LiteLLM-style governance; self-host with vLLM when residency, latency, or sustained economics beat API simplicity.

## Related

- [rag.md](rag.md)
- [llmops.md](llmops.md)
- [agents-and-mcp.md](agents-and-mcp.md)
