---
title: Data quality & curation for LLMs
category: data-platform
updated: 2026-07-12
---

# Data quality & curation for LLMs

"Garbage in, garbage out" is amplified with LLMs: a bad document doesn't just skew a metric — it gets **retrieved and quoted verbatim to users**. Quality work happens at two layers: the corpus feeding retrieval/fine-tuning, and the outputs LLMs write back into the platform.

## Corpus quality (for RAG and fine-tuning)

### Dimensions that matter

| Dimension | Failure mode if ignored |
|---|---|
| **Accuracy / currency** | Model confidently cites the 2022 pricing page |
| **Duplication** | Near-duplicates crowd out diverse results in top-k retrieval |
| **Extraction fidelity** | Mangled tables/OCR noise produce garbled answers |
| **Coverage** | Questions with no supporting docs → hallucination pressure |
| **Authority** | Draft or superseded docs outrank the canonical source |
| **Leakage** | Secrets/PII in the corpus surface in answers ([governance](data-governance.md)) |

### Curation practices

- **Source allowlisting.** Ingest curated spaces, not "the whole wiki". An explicit source registry with owners beats bulk ingestion.
- **Freshness policy.** Expire or down-rank documents past a max age; propagate source deletions to the index ([pipelines](data-pipelines-for-llms.md)).
- **Near-duplicate detection.** MinHash/SimHash or embedding-similarity clustering; keep the canonical copy, link the rest.
- **Extraction QA.** Sample parsed output per source type and eyeball it; track parse-failure rates per connector.
- **Authority metadata.** Tag status (`official | draft | deprecated`) and use it in [retrieval ranking](retrieval-techniques.md).
- **Coverage analysis.** Cluster real user queries; find clusters with poor retrieval scores → that's your content-gap backlog.

## Fine-tuning data quality

For [fine-tuning](fine-tuning.md), quality dominates quantity — 1k excellent examples beat 100k mediocre ones:

- Deduplicate and decontaminate (remove eval-set overlap).
- Verify labels/outputs, ideally with independent review; LLM-as-judge screening helps but sample-audit it.
- Balance formats and difficulty; over-represented patterns get overfit.
- Version datasets like code: immutable snapshots, lineage to sources, changelogs.

## Quality of LLM-*generated* data

When LLMs write data back into the platform (extraction, tagging, summaries — see [pipelines](data-pipelines-for-llms.md)), apply output contracts:

- **Schema validation** on every response (JSON schema / structured output modes); reject-and-retry on violation.
- **Confidence routing**: low-confidence extractions go to human review, not straight to the warehouse.
- **Sampled audits** feeding an [evaluation](evaluation.md) set, so quality is a tracked metric, not a hope.
- **Provenance columns**: mark LLM-derived fields with model + prompt version so they can be recomputed or excluded downstream.

## Related

- [Data pipelines for LLM workloads](data-pipelines-for-llms.md)
- [Data governance for AI](data-governance.md)
- [Evaluating RAG systems](rag-evaluation.md)
