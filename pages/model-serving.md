---
title: Model serving
category: inference-serving
updated: 2026-07-12
---

# Model serving

**Model serving** is how an LLM becomes an API. Whether you consume a provider API or host open weights yourself, understanding the serving layer explains latency, throughput, and cost behavior.

## The two phases of a request

1. **Prefill** — the prompt is processed in one parallel pass, populating the KV cache. Compute-bound; determines **time-to-first-token (TTFT)**; scales with input length.
2. **Decode** — tokens generate one at a time, each reading the whole KV cache. Memory-bandwidth-bound; determines **tokens/sec**; scales with output length.

This split drives everything: long prompts hurt TTFT, long outputs hurt total latency, and the KV cache (not weights) is usually what limits concurrent requests on a GPU.

## Consuming provider APIs (most teams, most of the time)

Key operational surface:

- **Streaming** — always stream user-facing responses; perceived latency is TTFT, not total time.
- **Rate limits** — requests/min and tokens/min; build client-side queuing, backoff, and per-team quotas into your [gateway](reference-architecture.md).
- **Model versioning** — pin explicit versions; treat provider upgrades as deploys with [eval gates](evaluation.md).
- **Batch APIs** — 50%+ discounts for async workloads ([cost](cost-optimization.md)); route [pipeline](data-pipelines-for-llms.md) jobs there.
- **Failover** — multi-provider or multi-region fallback for availability; beware subtle behavior differences between "equivalent" models.

## Self-hosting open weights

When [build-vs-buy](build-vs-buy.md) lands on self-hosting, you'll run an inference server:

| Engine | Notes |
|---|---|
| **vLLM** | De facto default; PagedAttention, continuous batching, OpenAI-compatible API |
| **SGLang** | Strong at structured output & shared-prefix workloads |
| **TensorRT-LLM** | Peak NVIDIA performance; more build complexity |
| **llama.cpp / Ollama** | CPU/edge/dev boxes, not production fleets |

Core serving techniques (mostly built into the above):

- **Continuous batching** — new requests join the batch at every decode step; the single biggest throughput win over naive batching.
- **PagedAttention** — virtual-memory-style KV-cache management; eliminates fragmentation, enables high concurrency.
- **Prefix caching** — shared system prompts computed once.
- **Speculative decoding** — small draft model proposes tokens, large model verifies; 2–3× decode speedup.
- See [inference optimization](inference-optimization.md) for quantization and hardware sizing.

## SLOs that matter

| Metric | Definition | Typical interactive target |
|---|---|---|
| TTFT | Time to first token | < 1 s |
| TPOT / tokens-sec | Inter-token latency | > 30 tok/s (faster than reading) |
| Goodput | Requests meeting SLO per GPU | The real capacity metric |
| Availability | Incl. provider outages | Design failover for it |

Autoscale on **KV-cache utilization / queue depth**, not CPU. Load-test with realistic token-length distributions — throughput numbers from short-prompt benchmarks are fiction for RAG workloads.

## Related

- [Inference optimization](inference-optimization.md)
- [Cost optimization](cost-optimization.md)
- [Reference architecture](reference-architecture.md)
