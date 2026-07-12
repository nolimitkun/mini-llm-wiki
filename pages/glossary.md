---
title: Glossary
category: reference
updated: 2026-07-12
---

# Glossary

Quick definitions with links to the full pages.

| Term | Definition |
|---|---|
| **Agent** | LLM in a loop that chooses tools/actions until a goal is met → [agents](agents.md) |
| **Alignment** | Post-training that makes a model helpful/safe (SFT, RLHF, DPO) → [alignment](alignment.md) |
| **ANN** | Approximate nearest neighbor — fast similarity search over vectors → [vector databases](vector-databases.md) |
| **BM25** | Classic keyword-ranking algorithm; the "sparse" half of hybrid search → [retrieval](retrieval-techniques.md) |
| **Chunking** | Splitting documents into retrieval units → [chunking](chunking-strategies.md) |
| **Context window** | Max tokens a model processes per request → [context windows](context-windows.md) |
| **Continuous batching** | Serving technique admitting new requests every decode step → [serving](model-serving.md) |
| **Cross-encoder / reranker** | Model scoring query–document pairs jointly for precise ranking → [retrieval](retrieval-techniques.md) |
| **Distillation** | Training a small model on a large model's outputs → [fine-tuning](fine-tuning.md) |
| **DPO** | Direct Preference Optimization — preference tuning without a reward model → [alignment](alignment.md) |
| **Embedding** | Dense vector representing meaning; enables semantic similarity → [embeddings](embeddings.md) |
| **Faithfulness / groundedness** | Whether an answer's claims are supported by the provided context → [RAG evaluation](rag-evaluation.md) |
| **Fine-tuning** | Continuing training on your examples to change model behavior → [fine-tuning](fine-tuning.md) |
| **Function calling** | Model emits structured calls your code executes → [tool use](tool-use.md) |
| **Guardrails** | Input/output/action policy checks around the model → [security](security-and-privacy.md) |
| **Hallucination** | Confident output unsupported by training data or context → [what is an LLM](what-is-an-llm.md) |
| **HNSW** | Graph-based ANN index; the common default → [vector databases](vector-databases.md) |
| **Hybrid search** | Vector + keyword retrieval fused (e.g., RRF) → [retrieval](retrieval-techniques.md) |
| **KV cache** | Cached attention keys/values; dominates serving memory → [inference optimization](inference-optimization.md) |
| **LLM gateway** | Single proxy for all model traffic: auth, routing, logging, guardrails → [reference architecture](reference-architecture.md) |
| **LLM-as-judge** | Using a strong LLM to score outputs against a rubric → [evaluation](evaluation.md) |
| **LLMOps** | Operational discipline for LLM systems → [LLMOps overview](llmops-overview.md) |
| **LoRA / QLoRA** | Parameter-efficient fine-tuning via small adapter matrices → [fine-tuning](fine-tuning.md) |
| **MCP** | Model Context Protocol — standard for connecting AI apps to tools/data → [MCP](mcp.md) |
| **MoE** | Mixture-of-Experts — routed MLPs for more capacity per FLOP → [transformer](transformer-architecture.md) |
| **Prefill / decode** | The two inference phases: prompt processing vs. token-by-token generation → [serving](model-serving.md) |
| **Prompt caching** | Provider discount for reused prompt prefixes → [cost](cost-optimization.md) |
| **Prompt injection** | Attack embedding instructions in content the model reads → [security](security-and-privacy.md) |
| **Quantization** | Lower-precision weights/cache for memory & speed → [inference optimization](inference-optimization.md) |
| **RAG** | Retrieval-Augmented Generation — retrieve context, then generate → [RAG overview](rag-overview.md) |
| **Recall@k** | Fraction of needed content present in top-k retrieval → [RAG evaluation](rag-evaluation.md) |
| **RLHF** | Reinforcement Learning from Human Feedback → [alignment](alignment.md) |
| **RRF** | Reciprocal Rank Fusion — simple method to merge ranked lists → [retrieval](retrieval-techniques.md) |
| **Semantic layer** | Governed business definitions (metrics, dimensions); key for text-to-SQL → [agents](agents.md) |
| **Speculative decoding** | Draft-then-verify generation for 2–3× decode speedup → [inference optimization](inference-optimization.md) |
| **Structured output** | Constraining generation to a schema (JSON) → [tool use](tool-use.md) |
| **Temperature** | Sampling randomness knob; 0 ≈ deterministic-ish → [what is an LLM](what-is-an-llm.md) |
| **Token** | Subword unit models actually process; the billing & capacity unit → [tokenization](tokenization.md) |
| **TTFT / TPOT** | Time-to-first-token / time-per-output-token latency metrics → [serving](model-serving.md) |
| **Vector database** | Store + ANN index for embeddings → [vector databases](vector-databases.md) |
