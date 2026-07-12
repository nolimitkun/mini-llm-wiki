---
title: Data pipelines for LLM workloads
category: data-platform
updated: 2026-07-12
---

# Data pipelines for LLM workloads

LLM applications introduce a new class of pipeline to the data platform: **unstructured-data ingestion and enrichment**. The same engineering discipline applies as for warehouse ETL — idempotency, incremental processing, observability — but the stages and failure modes differ.

## The canonical ingestion pipeline (for RAG / search)

```
sources → extract → clean → chunk → enrich → embed → index
 (docs,    (parse    (boiler- (split  (metadata, (vectors) (vector DB
  wikis,    PDF/HTML, plate,   into    PII scan,            + keyword
  tickets,  OCR)      dedup)   units)  classify)            index)
  DBs)
```

### Stage notes

1. **Extract** — parse PDFs, HTML, Office docs, emails. This is where most quality loss happens: broken tables, lost headings, OCR noise. Invest here first; garbage in, garbage retrieved.
2. **Clean** — strip boilerplate (nav bars, footers, signatures), deduplicate near-identical documents, normalize encodings. See [data quality & curation](data-quality-and-curation.md).
3. **Chunk** — split documents into retrieval units ([chunking strategies](chunking-strategies.md)). Preserve structure: keep headings with their sections, don't split tables.
4. **Enrich** — attach metadata (source, author, date, ACLs, document type), run PII detection ([governance](data-governance.md)), optionally classify or summarize with a cheap LLM.
5. **Embed** — call the [embedding model](embeddings.md) in batches; record model + version with every vector.
6. **Index** — upsert into the [vector database](vector-databases.md) and (usually) a keyword index for [hybrid search](retrieval-techniques.md).

## Engineering requirements

- **Idempotent upserts.** Key every chunk by `(document_id, chunk_index, content_hash)` so reruns don't duplicate.
- **Incremental sync.** Detect changed/deleted source documents (CDC, webhooks, modified-time scans) and propagate — **deletions matter**: stale chunks answering from removed documents is a common compliance incident.
- **Freshness SLOs.** Define how quickly a source change must be searchable (e.g., 15 min for support KB, 24 h for archives) and monitor lag like any pipeline.
- **Backfill vs. streaming paths.** Bulk re-embedding (model upgrade, chunking change) is a batch job with rate-limit-aware concurrency; ongoing updates are incremental. Design both from day one.
- **Dead-letter queue.** Unparseable documents shouldn't block the pipeline; quarantine and report them.

## The reverse direction: LLMs *inside* pipelines

LLMs are increasingly pipeline *operators*, not just consumers:

- **Extraction**: unstructured → structured (entities from contracts, fields from invoices).
- **Classification & tagging** at scale where rules fall short.
- **Data cleaning**: canonicalizing names, fixing categories, summarizing free-text fields.

Treat these as you would any UDF with a nondeterministic dependency: pin model versions, sample outputs into [evaluation](evaluation.md), set cost budgets per run, and cache results keyed on input hash so reprocessing is free.

## Orchestration

Use your existing orchestrator (Airflow, Dagster, Prefect, dbt for warehouse-side steps). LLM-specific additions: rate-limit-aware retries with exponential backoff, token/cost accounting per task, and per-stage sampling for quality checks.

## Related

- [Vector databases](vector-databases.md)
- [Data quality & curation](data-quality-and-curation.md)
- [RAG overview](rag-overview.md)
