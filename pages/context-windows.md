---
title: Context windows
category: fundamentals
updated: 2026-07-12
---

# Context windows

The **context window** is the maximum number of [tokens](tokenization.md) a model can process in one request — system prompt, conversation history, retrieved documents, tool results, and the generated output all share it.

Typical sizes (2025–2026): 128k–200k tokens for frontier models, with some supporting 1M+. 100k tokens ≈ a 300-page book.

## What fills a context window

```
┌──────────────────────────────────────┐
│ System prompt (instructions, persona)│  ← relatively fixed
│ Tool/function definitions            │  ← fixed per app
│ Retrieved context (RAG)              │  ← per request
│ Conversation history                 │  ← grows over a session
│ Current user message                 │  ← per request
│ ... generated output ...             │  ← counts too
└──────────────────────────────────────┘
```

## Bigger isn't free — three caveats

1. **Cost scales linearly with input tokens.** A 100k-token prompt at every turn is expensive; [prompt caching](cost-optimization.md) mitigates repeated prefixes but not per-request variety.
2. **Latency.** Prefill time grows with input length; time-to-first-token suffers on huge prompts.
3. **Attention quality degrades.** Models recall information at the start and end of context better than the middle (the "lost in the middle" effect). Stuffing 500 documents into context often retrieves *worse* answers than a good [retrieval pipeline](retrieval-techniques.md) selecting the 5 best.

## Long context vs. RAG

| | Long context (stuff everything in) | [RAG](rag-overview.md) (retrieve then generate) |
|---|---|---|
| Corpus size | Bounded by window (~a few books) | Unbounded |
| Cost per query | High (pay for all tokens every time) | Low (pay for top-k chunks) |
| Freshness | Must rebuild the prompt | Update the index |
| Precision | Model must find the needle itself | Retriever pre-filters |
| Engineering effort | Minimal | Pipeline + index + evaluation |

In practice: **long context for small, stable corpora or deep single-document analysis; RAG for large or fast-changing corpora.** Hybrid approaches (retrieve generously, let a long-context model sift) are common.

## Managing context in applications

- **Set a token budget per section** (system, history, retrieval, output) and enforce it before every call.
- **Summarize or truncate history** in long conversations — keep recent turns verbatim, compress older ones.
- **Order matters**: put instructions first, the most important context near the start or end, and the question last.
- **Cache stable prefixes** (system prompt, tool definitions) with provider prompt caching to cut cost and latency.

## Related

- [Tokenization](tokenization.md)
- [RAG overview](rag-overview.md)
- [Cost optimization](cost-optimization.md)
