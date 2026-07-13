---
title: Retrieval-Augmented Generation (RAG)
category: genai-platform
updated: 2026-07-13
sources: [sources/2026-07-open-source-project-comparisons.md, sources/2026-07-commercial-product-comparisons.md]
---

# Retrieval-Augmented Generation (RAG)

**RAG** grounds an LLM in your data: retrieve the most relevant content at query time, place it in the prompt, and the model answers from evidence instead of memory. It's the pattern that turns the platform's document estate into an answerable knowledge base — with freshness by index update, citations by construction, and per-user access control (which fine-tuning can never give).

## The two pipelines

**Offline (indexing)** — a standard [ingestion pipeline](data-ingestion.md) with extra stages:

```
documents → parse → clean/dedupe → chunk → embed → index (vector + keyword)
```

**Online (query)**:

```
query → rewrite → hybrid retrieve (top ~50) → ACL filter → rerank (top 5–10)
      → prompt assembly → LLM → answer + citations
```

## Quality levers, in ROI order

1. **Extraction & chunking** — most failures trace to mangled PDF parsing or chunks that split answers apart. Defaults: structure-aware splitting, 400–800 tokens, heading path prepended to each chunk; never split tables; retrieve small units but hand the LLM the parent section.
2. **Hybrid retrieval** — vectors miss exact terms (IDs, error codes, names); pair with BM25 keyword search, fuse with reciprocal rank fusion. Vector-only is a prototype smell.
3. **Reranking** — a cross-encoder rescoring the top ~50 candidates down to 5–10 is the biggest single quality win; more chunks in the prompt is *not* better.
4. **Metadata filtering** — tenant, recency, doc type, and **ACLs enforced here, in the retrieval layer** ([data-security-and-privacy.md](data-security-and-privacy.md)) — never rely on the model to withhold what it can see.
5. **Grounding prompt** — answer only from context, cite sources, say "not found" when retrieval comes back weak.

## Evaluation: measure the two halves separately

Build a golden set (50–200 real questions + expected answers + source docs, including *unanswerable* ones):

- **Retrieval**: recall@k — is the needed content in what you send? Generation can't recover from retrieval misses.
- **Generation**: faithfulness (claims supported by context — the hallucination metric), answer relevance, citation accuracy, refusal correctness — scored by a calibrated LLM judge ([llmops.md](llmops.md)).

Re-run on every config change; mine production failures back into the set.

## Failure modes → fixes

| Symptom | Usual cause → fix |
|---|---|
| Right doc exists, not retrieved | Vocabulary mismatch / bad chunks → hybrid search, re-chunk |
| Retrieved but answer wrong | Too much noise in prompt → rerank harder, fewer chunks |
| Confident answer, no support | Corpus gap → coverage analysis, refusal instructions |
| Stale answers | Index lag, deletions not propagated → freshness SLO ([data-quality.md](data-quality.md)) |
| Restricted content leaked | Missing query-time ACL filter → fix before launch, not after |

## Variants

**Agentic RAG** (the model iterates search→read→refine — [agents-and-mcp.md](agents-and-mcp.md)); **GraphRAG** (retrieval over an extracted knowledge graph for multi-hop questions); **text-to-SQL** (retrieval over schema/metrics — best via the [semantic layer](semantic-layer.md)); and **long-context stuffing** (viable for small stable corpora; RAG wins on cost, freshness, and scale).

## Open source project comparison

| Project | RAG role | Watch-outs |
|---|---|---|
| **LlamaIndex** | Data connectors, indexes, retrieval pipelines, document-centric RAG workflows | Useful abstractions; keep ingestion, ACLs, and evals explicit |
| **LangChain** | Chains/tools/integrations and broad application framework ecosystem | Flexibility can obscure ownership boundaries; avoid framework lock-in around core data |
| **Haystack** | Pipeline-oriented RAG/search systems with production-minded components | Smaller mindshare than LangChain/LlamaIndex, but cleaner for some retrieval pipelines |
| **LangGraph** | Stateful multi-step/agentic retrieval workflows | Use when loops/branching are real; fixed workflows are easier to test |
| **Unstructured / Docling / Apache Tika** | Parsing PDFs, Office docs, HTML, and messy enterprise content | Parsing quality often dominates RAG quality; benchmark on your ugly documents |
| **FlagEmbedding / cross-encoder rerankers** | Reranking top candidates for relevance | Adds latency/cost; usually worth it for answer quality |

Frameworks accelerate assembly, but RAG quality usually comes from parsing, chunking, hybrid search, reranking, ACLs, and evals--not the framework name.

## Commercial product comparison

| Product | RAG role | Watch-outs |
|---|---|---|
| **OpenAI Assistants/Responses + file/search tooling** | Fast managed RAG/application assembly around OpenAI models | Convenience can hide retrieval controls; verify citations, ACLs, and exportability |
| **Azure AI Search + Azure OpenAI** | Enterprise RAG in Microsoft/Azure estates with search, identity, and model access | Strong integrated path; keep per-user ACLs and index freshness explicit |
| **Vertex AI Agent Builder / Search** | GCP-native RAG/search/agent building over enterprise content | Best in GCP; evaluate retrieval transparency and customization depth |
| **Amazon Bedrock Knowledge Bases / Agents** | AWS-native managed RAG and agent workflows across model providers | Convenient but opinionated; test chunking, retrieval, and eval integration |
| **Databricks Mosaic AI Vector Search + Model Serving** | RAG close to lakehouse data, Unity Catalog, and enterprise governance | Strong if knowledge assets are governed in Databricks |
| **Glean / Hebbia / Perplexity Enterprise-style products** | End-user enterprise search/answer products over workplace knowledge | Product value is high; less suitable when you need platform-level primitives for custom apps |

Managed RAG products speed delivery, but the non-negotiables stay yours: ACLs, citations, freshness, evals, and deletion propagation.

## Related

- [vector-databases.md](vector-databases.md)
- [embeddings.md](embeddings.md)
- [llms-on-the-platform.md](llms-on-the-platform.md)
