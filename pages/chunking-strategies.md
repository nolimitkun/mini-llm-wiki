---
title: Chunking strategies
category: rag
updated: 2026-07-12
---

# Chunking strategies

**Chunking** splits documents into the units that get [embedded](embeddings.md) and retrieved. It's the highest-leverage, least-glamorous decision in a [RAG](rag-overview.md) system: chunks too small lose context; too large dilute the embedding and waste [tokens](tokenization.md).

## The core tension

- **Retrieval precision** favors small chunks (a focused chunk embeds crisply and matches queries well).
- **Answer quality** favors large chunks (the LLM needs surrounding context to answer correctly).

Most good strategies decouple the two: **retrieve on small units, hand the LLM something bigger.**

## Strategies

| Strategy | How | When |
|---|---|---|
| **Fixed-size + overlap** | Split every N tokens (e.g., 400–800) with 10–20% overlap | Baseline; unstructured text; start here |
| **Recursive/separator-aware** | Split on paragraphs → sentences, respecting boundaries | Default in most frameworks; strictly better than naive fixed-size |
| **Structure-aware** | Split on headings/sections; keep heading path with each chunk | Docs with real structure (wikis, manuals, contracts) — usually the biggest win |
| **Small-to-big (parent-document)** | Embed small child chunks; return the parent section at generation time | High precision + full context; needs parent storage |
| **Semantic chunking** | Break where embedding similarity between sentences drops | Long unstructured prose; costs an embedding pass |
| **Contextual enrichment** | Prepend an LLM-generated summary/context line to each chunk before embedding | Strong quality lift; adds indexing cost |
| **Element-specific** | Tables, code blocks, FAQs handled as atomic units | Never split a table row from its header |

## Practical defaults

- Start with **structure-aware splitting, target 400–800 tokens, 10–15% overlap**, headings prepended to each chunk (`"Billing > Refunds > Policy: <text>"`).
- Keep chunks **within the embedding model's input limit** with margin.
- Store with each chunk: `doc_id`, `chunk_index`, heading path, char offsets (for citations), and content hash (for [idempotent pipelines](data-pipelines-for-llms.md)).
- **Never split**: tables (serialize as Markdown, keep headers), code blocks, Q&A pairs.
- Re-chunking = re-embedding the corpus. Version your chunking config and batch changes with model upgrades.

## Debugging chunk problems

Symptoms and probable chunking causes:

- Answers cut off mid-thought → answer spans a chunk boundary → increase overlap or use small-to-big.
- Retrieval returns the right doc but useless part → chunks lack heading context → prepend heading paths.
- Table questions fail → tables split or flattened → element-specific handling.
- Everything retrieves mediocrely → chunks too long (diluted embeddings) → shrink retrieval unit.

Measure, don't guess: run your [RAG evaluation set](rag-evaluation.md) against chunking variants.

## Related

- [Embeddings](embeddings.md)
- [Retrieval techniques](retrieval-techniques.md)
- [Data pipelines for LLM workloads](data-pipelines-for-llms.md)
