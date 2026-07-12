# Index

Catalog of every page in `pages/`, one line each. Maintained per the workflows in [CLAUDE.md](CLAUDE.md).

## fundamentals

- [What is an LLM?](pages/what-is-an-llm.md) — definition, lifecycle, key properties, and why LLMs reshape data platforms.
- [Transformer architecture](pages/transformer-architecture.md) — attention, MLPs, KV cache, and variants; what the architecture implies for serving.
- [Tokenization](pages/tokenization.md) — tokens as the unit of cost, capacity, and latency; practical counting guidance.
- [Embeddings](pages/embeddings.md) — dense vectors for semantic similarity; embeddings as derived data with versioning obligations.
- [Context windows](pages/context-windows.md) — what fills the window, long-context vs. RAG trade-offs, budget management.

## data-platform

- [Data pipelines for LLM workloads](pages/data-pipelines-for-llms.md) — the extract→chunk→embed→index pipeline and its engineering requirements; LLMs as pipeline operators.
- [Vector databases](pages/vector-databases.md) — ANN indexes (HNSW/IVF/quantization), metadata filtering, deployment options, capacity math.
- [Data quality & curation](pages/data-quality-and-curation.md) — corpus curation for RAG/fine-tuning; output contracts for LLM-generated data.
- [Data governance for AI](pages/data-governance.md) — ACL propagation, PII handling, provider policy, lineage, audit logging, regulation.

## rag

- [RAG overview](pages/rag-overview.md) — grounding LLMs in your data: anatomy, quality levers, failure modes, variants.
- [Chunking strategies](pages/chunking-strategies.md) — splitting documents for retrieval: strategies, defaults, debugging chunk problems.
- [Retrieval techniques](pages/retrieval-techniques.md) — the retrieval stack: query processing, hybrid search, filtering, reranking.
- [Evaluating RAG systems](pages/rag-evaluation.md) — golden datasets, retrieval vs. generation metrics, the RAG triad, LLM-as-judge.

## training-adaptation

- [Pretraining](pages/pretraining.md) — how base models are made and what that implies for consumers; continued pretraining.
- [Fine-tuning](pages/fine-tuning.md) — behavior not facts; when to tune, LoRA/QLoRA, data requirements, process checklist.
- [Alignment (RLHF & friends)](pages/alignment.md) — SFT, RLHF/DPO, reasoning RL; trained-in behaviors you inherit and must guard around.

## inference-serving

- [Model serving](pages/model-serving.md) — prefill/decode, consuming APIs well, self-hosting engines, SLOs.
- [Inference optimization](pages/inference-optimization.md) — quantization, KV-cache management, speculative decoding, parallelism, sizing.
- [Cost optimization](pages/cost-optimization.md) — measure→cheaper-per-request→fewer-requests, with a worked example.

## llmops

- [LLMOps overview](pages/llmops-overview.md) — how LLMOps differs from MLOps; the config surface; maturity ladder.
- [Evaluation](pages/evaluation.md) — golden datasets, deterministic checks, LLM-as-judge calibration, evals as CI.
- [Monitoring & observability](pages/monitoring-and-observability.md) — gateway instrumentation, four signal layers, drift, closing the loop.
- [Prompt management](pages/prompt-management.md) — prompts as production code: engineering, versioning, registries, anti-patterns.

## agents-integration

- [LLM agents](pages/agents.md) — the agent loop, workflow-vs-agent choice, data-platform agents, bounding and evaluating them.
- [Tool use & function calling](pages/tool-use.md) — the tool loop, designing tools for probabilistic callers, security at the executor.
- [Model Context Protocol (MCP)](pages/mcp.md) — the standard connecting AI apps to data systems; why platform teams should care.

## platform-architecture

- [Reference architecture](pages/reference-architecture.md) — gateway, model layer, knowledge layer, LLMOps layer; adoption sequence.
- [Build vs. buy](pages/build-vs-buy.md) — API vs. self-hosted models, tooling, applications; the TCO trap checklist.
- [Security & privacy](pages/security-and-privacy.md) — prompt injection, data disclosure, excessive agency; guardrail layers.

## reference

- [Glossary](pages/glossary.md) — one-line definitions of ~40 terms, each linking to its full page.
