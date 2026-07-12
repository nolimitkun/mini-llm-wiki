---
title: RAG overview
category: rag
updated: 2026-07-12
---

# RAG overview

**Retrieval-Augmented Generation (RAG)** grounds an LLM in your data: at query time, retrieve the most relevant content from a corpus and place it in the prompt, so the model answers from evidence instead of parametric memory.

## Why RAG

- **Knowledge beyond training data** — private, domain-specific, or post-cutoff information.
- **Freshness** — update the index, not the model.
- **Hallucination reduction** — grounding + "answer only from the provided context" instructions.
- **Citations** — retrieved chunks give you attributable sources.
- **Access control** — retrieval can enforce per-user permissions ([governance](data-governance.md)); a fine-tuned model cannot.

Compare with alternatives: [long context](context-windows.md) (small stable corpora) and [fine-tuning](fine-tuning.md) (teaches *behavior/style*, not facts — the two are complementary, not competing).

## Anatomy of a RAG system

**Offline (indexing)** — see [data pipelines](data-pipelines-for-llms.md):

```
documents → parse → clean → chunk → embed → index (vector + keyword)
```

**Online (query)**:

```
user query → [rewrite/expand] → retrieve top-k (hybrid) → [rerank]
           → assemble prompt (instructions + chunks + query) → LLM → answer + citations
```

## Quality levers, in order of typical ROI

1. **Extraction & [chunking](chunking-strategies.md)** — most failures trace back to bad parsing or chunks that split answers apart.
2. **[Hybrid retrieval + reranking](retrieval-techniques.md)** — vector-only search misses exact terms (IDs, error codes, names).
3. **Metadata filtering** — scope by recency, doc type, tenant before similarity.
4. **Query understanding** — rewrite conversational queries into standalone ones; decompose multi-part questions.
5. **Prompt design** — clear grounding instructions, citation format, explicit "say you don't know" escape hatch.
6. **[Evaluation](rag-evaluation.md)** — you can't tune what you don't measure; build a golden set early.

## Failure modes to design for

| Failure | Typical cause | Mitigation |
|---|---|---|
| Right doc exists, not retrieved | Vocabulary mismatch, bad chunking | Hybrid search, query rewriting, re-chunk |
| Retrieved but wrong answer | Context ignored or misread | Reranking (fewer, better chunks), stronger grounding prompt |
| Confident answer with no support | No relevant docs in corpus | Coverage analysis ([curation](data-quality-and-curation.md)), refusal instructions |
| Stale answer | Index lag, no deletion propagation | Freshness SLOs in pipeline |
| Leaked restricted content | Missing ACL filters | Query-time permission filtering ([governance](data-governance.md)) |

## Variants you'll encounter

- **Agentic RAG** — an [agent](agents.md) decides when/what to search, possibly iterating (search → read → refine query).
- **GraphRAG** — retrieval over a knowledge graph built from the corpus; helps multi-hop and "summarize themes across everything" questions.
- **SQL-RAG / text-to-SQL** — retrieval over schema + metadata to generate warehouse queries; the "talk to your data" pattern for structured data.

## Related

- [Chunking strategies](chunking-strategies.md)
- [Retrieval techniques](retrieval-techniques.md)
- [Evaluating RAG systems](rag-evaluation.md)
