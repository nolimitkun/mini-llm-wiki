---
title: Data governance
category: governance-quality
updated: 2026-07-13
sources: [sources/2026-07-open-source-project-comparisons.md, sources/2026-07-commercial-product-comparisons.md]
---

# Data governance

**Data governance** is the system of ownership, policy, and control that makes data trustworthy and its use defensible: who owns each dataset, who may access it, what it means, how long it lives, and how you prove all of that to an auditor. Done well it's an enablement layer — people find and use data *faster* because the rules are encoded, not tribal.

## The pillars

| Pillar | Question it answers | Machinery |
|---|---|---|
| **Ownership** | Who is accountable for this dataset? | Owner metadata on every asset; escalation paths |
| **Classification** | How sensitive is it? | Tags (public/internal/confidential/PII) applied at [ingestion](data-ingestion.md), inherited through [lineage](data-catalog-and-lineage.md) |
| **Access control** | Who can see/change it? | Role/attribute-based grants, row/column policies ([security](data-security-and-privacy.md)) |
| **Meaning** | What does this column/metric mean? | [Catalog](data-catalog-and-lineage.md) docs, [semantic layer](semantic-layer.md) definitions |
| **Quality** | Can I trust it? | Tests, SLOs, incident process ([data-quality.md](data-quality.md)) |
| **Lifecycle** | How long is it kept? Where? | Retention schedules, residency rules ([hybrid-cloud.md](hybrid-cloud.md)), deletion workflows |

## Regulatory floor (2026)

GDPR/CCPA-family laws (consent, purpose limitation, **right to erasure** — which must propagate to derived tables, caches, and [AI indexes](llms-on-the-platform.md)), sector rules (HIPAA, PCI, SOX/FINRA), and the **EU AI Act** layering obligations on AI systems: data documentation, risk tiers, transparency. The platform implication is always the same: you need *lineage* (what feeds what), *classification* (what's sensitive), and *auditable access logs* — build them once, satisfy many regimes.

## Governance for AI consumers, specifically

AI systems stress governance because they move data across boundaries at runtime:

- Documents flow into prompts and [RAG indexes](rag.md) — source ACLs must propagate to retrieval, enforced at query time, never delegated to the model.
- [Agents](agents-and-mcp.md) act with tool credentials — scope them to the *end user's* permissions.
- Model providers are data processors — approved-provider lists per data classification, no-training terms, region pinning.
- LLM-derived columns need provenance (model + prompt version) so they can be recomputed or excluded ([data-quality.md](data-quality.md)).

## Making it real (not a binder)

- **Policy as code**: access rules, retention, and masking declared in version-controlled config, applied by the platform — not ticket-driven grants that drift.
- **Federated model**: central team sets standards and runs shared tooling; domain teams own their data's classification, quality, and access decisions ([data-mesh.md](data-mesh.md)).
- **Tier your effort**: tier-1 (regulatory, executive-facing, AI-feeding) assets get full rigor; long-tail exploration gets defaults. Uniform maximal governance guarantees circumvention.
- **Measure it**: % assets with owners, classification coverage, access-review completion, time-to-grant. Governance without metrics is vibes.

## Open source project comparison

| Project | Governance role | Watch-outs |
|---|---|---|
| **OpenMetadata** | Catalog, glossary, lineage, owners, quality signals, policy context | Broad platform; success depends on automated harvesting and workflow adoption |
| **DataHub** | Metadata graph, real-time metadata events, APIs, lineage, ownership | Strong integration substrate; governance UX and operating model still need design |
| **Apache Ranger** | Centralized access policies for Hadoop/lakehouse-era engines | Best in supported ecosystems; less universal for modern SaaS/warehouse estates |
| **Open Policy Agent (OPA)** | Policy-as-code decision engine for services, gateways, and custom controls | A policy engine, not a data governance product; you build integration and audit trails |
| **OpenLineage** | Standard lineage event model across orchestrators and engines | Complements catalogs; does not solve discovery, ownership, or policy by itself |

Use catalogs for governance workflow, OPA/Ranger for enforcement where they fit, and OpenLineage as the exchange format between systems.

## Commercial product comparison

| Product | Governance role | Watch-outs |
|---|---|---|
| **Collibra** | Enterprise governance workflows, policy, stewardship, glossary, compliance | Powerful but process-heavy; adoption requires operating-model work |
| **Alation** | Data catalog, stewardship, query intelligence, analyst discovery | Strong discovery/governance experience; enforcement still lives in platforms |
| **Atlan** | Modern active metadata, collaboration, lineage, and workflow integration | Good UX/integrations; confirm coverage for your engines and governance policies |
| **Microsoft Purview** | Microsoft/Azure governance, catalog, classification, and compliance alignment | Best in Microsoft estates; heterogeneous coverage requires validation |
| **Databricks Unity Catalog** | Lakehouse governance, permissions, lineage, discovery inside Databricks | Strong enforcement in-platform; external assets need integration |
| **Snowflake Horizon / governance features** | Snowflake-native governance, lineage, discovery, policy controls | Excellent for Snowflake assets; multi-platform governance needs a broader plane |

Commercial governance succeeds when workflow and enforcement connect. A beautiful catalog without access policy, lineage, and owner accountability becomes shelfware.

## Related

- [data-catalog-and-lineage.md](data-catalog-and-lineage.md)
- [data-security-and-privacy.md](data-security-and-privacy.md)
- [data-quality.md](data-quality.md)
