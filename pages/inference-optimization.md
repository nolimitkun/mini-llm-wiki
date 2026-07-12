---
title: Inference optimization
category: inference-serving
updated: 2026-07-12
---

# Inference optimization

Techniques to make LLM inference faster and cheaper, mostly relevant when **self-hosting** ([serving basics](model-serving.md)); API consumers get these implicitly and optimize via [cost tactics](cost-optimization.md) instead.

## Where the resources go

For a request on a GPU: model weights are a fixed memory cost; the **KV cache** grows with `batch × sequence-length` and is what actually limits concurrency; **decode is memory-bandwidth-bound**, so speedups come from moving fewer bytes, not more FLOPs.

```
GPU memory = weights + KV cache + activations
             (fixed)   (scales with load — optimize this)
```

## Quantization — the biggest single lever

Store weights (and sometimes KV cache/activations) at lower precision:

| Precision | Memory vs FP16 | Quality impact | Notes |
|---|---|---|---|
| FP16/BF16 | 1× | baseline | Training-native |
| **FP8** | 2× | negligible | Default on H100+-class hardware |
| **INT8** | 2× | negligible–small | Broad support |
| **INT4** (AWQ, GPTQ, GGUF) | 4× | small, task-dependent | 70B model on one 48 GB GPU; **evaluate on your tasks** — quality loss concentrates in reasoning/math |
| KV-cache quantization (FP8/INT8) | 2× cache | small | Directly increases max concurrency |

Rule: quantize until your [evals](evaluation.md) flinch, not until the benchmark table says it's fine.

## Speed techniques

- **Continuous batching + PagedAttention** — table stakes, built into vLLM/SGLang ([serving](model-serving.md)).
- **Speculative decoding** — draft model (or self-drafting variants like Medusa/EAGLE) proposes several tokens; the big model verifies in one pass. 2–3× decode speedup, exact same outputs.
- **Prefix/prompt caching** — reuse KV cache for shared prefixes (system prompts, few-shot blocks, RAG boilerplate). Order prompts static-first to maximize hits.
- **Chunked prefill** — interleave long prefills with ongoing decodes so one big prompt doesn't stall everyone's TPOT.
- **Attention variants** — GQA/MQA (smaller KV cache) and sliding-window attention come baked into the model architecture; prefer models that have them if serving cost matters.

## Parallelism for big models

- **Tensor parallelism** — split each layer across GPUs in one node (NVLink); the standard way to fit 70B+.
- **Pipeline parallelism** — split layers across nodes; adds latency, use when a model exceeds a node.
- Small models: prefer **replicas** over parallelism — simpler and better throughput/GPU.

## Sizing cheat-sheet

Weights ≈ `params × bytes/param` (70B @ FP16 ≈ 140 GB, @ INT4 ≈ 35 GB). KV cache per token ≈ `2 × layers × kv_heads × head_dim × bytes` — for a 70B-class model at FP16, roughly 300 KB/token, so a 32k-token conversation ≈ 10 GB *per request*. This is why KV-cache work matters more than weight compression at high concurrency.

## Decision path

1. Serve with vLLM/SGLang defaults (continuous batching, prefix caching on).
2. Quantize weights to FP8/INT8; INT4 if evals hold.
3. Turn on KV-cache quantization.
4. Add speculative decoding if decode latency dominates.
5. Only then: exotic kernels, TensorRT-LLM, custom hardware.

## Related

- [Model serving](model-serving.md)
- [Cost optimization](cost-optimization.md)
- [Transformer architecture](transformer-architecture.md)
