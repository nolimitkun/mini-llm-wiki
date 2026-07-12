---
title: Transformer architecture
category: fundamentals
updated: 2026-07-12
---

# Transformer architecture

The **Transformer** (Vaswani et al., 2017, *"Attention Is All You Need"*) is the architecture behind virtually every modern LLM. Its core innovation — **self-attention** — lets every token attend to every other token in parallel, replacing the sequential processing of RNNs.

## The pipeline, end to end

```
text → tokenizer → token IDs → embedding lookup (+ position info)
     → N × Transformer blocks (attention + MLP)
     → output projection → probability over vocabulary → sample next token
```

## Core components

### Self-attention
Each token computes a **query (Q)**, **key (K)**, and **value (V)** vector. Attention scores = softmax(QKᵀ/√d) weight how much each token "looks at" every other token. **Multi-head attention** runs several attention operations in parallel so different heads can capture different relationships (syntax, coreference, long-range dependencies).

Decoder-only LLMs use **causal (masked) attention**: a token may only attend to earlier tokens, which is what makes autoregressive generation possible.

### Feed-forward network (MLP)
After attention, each position independently passes through a two-layer MLP (typically 4× the hidden width). Most of a model's parameters — and much of its "knowledge" — live here.

### Residual connections & normalization
Each sub-layer is wrapped in a residual connection with layer normalization (modern models use pre-norm, e.g. RMSNorm), enabling stable training of very deep stacks.

### Position encoding
Attention itself is order-agnostic, so position must be injected. Modern models mostly use **RoPE** (rotary position embeddings), which also underpins many [context-window extension](context-windows.md) techniques.

## Architectural variants

| Variant | Attention pattern | Examples | Typical use |
|---|---|---|---|
| Decoder-only | Causal | GPT, Claude, Llama | Generation (dominant for LLMs) |
| Encoder-only | Bidirectional | BERT | [Embeddings](embeddings.md), classification |
| Encoder-decoder | Both | T5, translation models | Seq-to-seq tasks |
| Mixture-of-Experts (MoE) | Causal + routed MLPs | Mixtral, DeepSeek | More capacity per FLOP |

## Why platform engineers should care

- **KV cache.** During generation, K/V vectors of past tokens are cached. The cache grows linearly with sequence length and dominates GPU memory at serving time — the key constraint in [inference optimization](inference-optimization.md).
- **Quadratic attention cost.** Attention is O(n²) in sequence length; long-context requests are disproportionately expensive ([context windows](context-windows.md), [cost](cost-optimization.md)).
- **Parallelism.** Training parallelizes across tokens; generation does not (one token at a time). This asymmetry shapes serving infrastructure — batching strategies, prefill vs. decode phases.

## Related

- [Tokenization](tokenization.md)
- [Model serving](model-serving.md)
- [Pretraining](pretraining.md)
