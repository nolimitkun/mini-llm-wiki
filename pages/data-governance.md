---
title: Data governance for AI
category: data-platform
updated: 2026-07-12
---

# Data governance for AI

LLM systems stress-test governance because they **move data across boundaries by design**: documents flow into prompts, prompts flow to model providers, outputs flow back to users who may not have had access to the sources. Governance for AI = classic data governance + prompt/output controls.

## The new data flows to govern

```
source docs ──> vector index ──> retrieved context ──> prompt ──> model provider
                                                          │
user input ───────────────────────────────────────────────┘──> output ──> user / downstream tables
```

Each arrow is a policy point: what may cross, who may trigger it, and what gets logged.

## Core controls

### Access control propagation
The most common failure: documents with restricted ACLs get embedded into a shared index, and retrieval leaks them to anyone who asks. Rules:

- Mirror source ACLs as metadata on every chunk; **enforce filters at query time in the retrieval layer** ([vector DB](vector-databases.md)) — never rely on the model to withhold information.
- Re-sync ACL changes with the same freshness SLO as content changes; a revoked permission must revoke retrieval.
- For coarse cases, segregate indexes per sensitivity tier or tenant.

### Classification & PII handling
- Run classification/PII detection at ingestion ([pipeline](data-pipelines-for-llms.md) enrich stage): detect, then **block, mask, or tokenize** per policy before anything is embedded — embeddings of PII are still governed data (and text is partially recoverable from vectors).
- Apply the same scanning to **prompts and outputs** at the gateway if users can paste arbitrary content.

### Provider & residency policy
- Decide which data classes may be sent to which model providers (external API vs. VPC-hosted vs. self-hosted — see [build vs. buy](build-vs-buy.md)).
- Verify provider terms: retention period, training-on-your-data (should be off), region pinning.

### Lineage & provenance
- Track lineage for derived stores: which sources feed which indexes feed which applications. "Delete this document everywhere" must be answerable ([right-to-erasure](data-pipelines-for-llms.md) requires deletion propagation to indexes and caches).
- Mark LLM-generated fields in the warehouse with model/prompt version ([quality](data-quality-and-curation.md)).

### Audit logging
Log per request: user, application, prompt (or its hash where content is too sensitive), retrieved document IDs, model + version, output, cost. This is the substrate for [monitoring](monitoring-and-observability.md), incident response, and compliance review. Define retention for the logs themselves — they now contain the sensitive data too.

## Regulatory context (as of 2026)

- **GDPR/CCPA**: right to erasure extends to derived stores (indexes, caches, fine-tuned models are a hard case — often the answer is retraining or filtering).
- **EU AI Act**: risk-tiered obligations; most internal data-platform assistants are limited/minimal risk but require transparency; keep model and data documentation.
- Sector rules (HIPAA, PCI, FINRA) apply to prompts/outputs exactly as to any data movement.

## Practical starting point

1. Stand up an **LLM gateway** (single egress point) so policy is enforceable in one place ([reference architecture](reference-architecture.md)).
2. Classify sources before ingestion; start with public/internal-only corpora.
3. Implement ACL-filtered retrieval before launch, not after the first leak.
4. Turn on full audit logging from day one.

## Related

- [Security & privacy](security-and-privacy.md)
- [Data quality & curation](data-quality-and-curation.md)
- [Monitoring & observability](monitoring-and-observability.md)
