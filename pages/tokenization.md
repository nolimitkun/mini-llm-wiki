---
title: Tokenization
category: fundamentals
updated: 2026-07-12
---

# Tokenization

**Tokenization** converts text into the integer IDs a model actually processes. LLMs don't see words or characters — they see **tokens**: subword units learned from data, typically via **Byte-Pair Encoding (BPE)** or similar algorithms.

## How it works

1. A tokenizer is trained on a corpus to find frequent character sequences.
2. Frequent words become single tokens (`" the"` → 1 token); rare words split into pieces (`"tokenization"` → `token` + `ization`).
3. The vocabulary is fixed (commonly 32k–200k tokens) and shipped with the model — **tokenizers are model-specific and not interchangeable**.

Rules of thumb for English: **1 token ≈ 4 characters ≈ 0.75 words**. So 1,000 words ≈ 1,300–1,500 tokens.

## Why tokens matter on a platform

### Cost
API pricing is per token (input and output priced separately). Token counting is the basis of all [cost estimation and chargeback](cost-optimization.md).

### Capacity
[Context windows](context-windows.md) are measured in tokens. Chunk sizes in [RAG pipelines](chunking-strategies.md) must be planned in tokens, not characters.

### Latency
Output latency scales with output token count — generation is one token per forward pass. Verbose prompts asking for verbose answers cost you twice.

### Multilingual & code skew
Tokenizers trained mostly on English encode other languages less efficiently — the same sentence in Thai or Hindi can take 3–10× more tokens, inflating cost and shrinking effective context. Code tokenizes differently from prose; whitespace-heavy formats (pretty-printed JSON, YAML) waste tokens.

## Practical guidance

- **Count tokens with the model's own tokenizer** (e.g., `tiktoken` for OpenAI models, the Anthropic token-counting API, Hugging Face `AutoTokenizer` for open models). Never estimate by character count in production.
- **Budget explicitly.** A request budget = system prompt + retrieved context + conversation history + user input + expected output. Enforce it in the application layer.
- **Minify structured data** before sending it to a model: strip indentation from JSON, drop unused fields, prefer compact formats (CSV/TSV over JSON for tabular data).
- **Watch for token bloat in logs**: base64 blobs, UUIDs, and stack traces are token-expensive and usually low-value context.

## Related

- [Context windows](context-windows.md)
- [Chunking strategies](chunking-strategies.md)
- [Cost optimization](cost-optimization.md)
