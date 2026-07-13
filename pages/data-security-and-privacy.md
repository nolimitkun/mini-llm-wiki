---
title: Data security & privacy
category: governance-quality
updated: 2026-07-13
sources: [sources/2026-07-open-source-project-comparisons.md]
---

# Data security & privacy

Security on a data platform has a defining asymmetry: the platform exists to *concentrate* data — which concentrates risk. The blast radius of one over-permissioned analyst account or leaked service key is the whole business. Privacy adds the legal layer: personal data carries obligations (minimization, purpose limitation, erasure) that must be *engineered*, not memoed ([data-governance.md](data-governance.md)).

## Access control, in increasing granularity

- **RBAC**: roles → grants on schemas/tables; the baseline. Watch role explosion.
- **ABAC/policy-based**: rules over attributes ("EU-analysts see EU rows") — scales better; policy-as-code.
- **Row-level security**: filter predicates applied per user (tenant isolation, regional partitions).
- **Column-level control + masking**: sensitive columns hidden or dynamically masked (last-4 SSN) per role.

Enforcement point matters: on the [lakehouse](lakehouse.md), fine-grained control lives in the catalog/governance layer — raw object-store access bypasses it, so lock the bucket down to the engines.

## Protecting the data itself

- **Encryption**: at rest and in transit everywhere (table stakes); key management with rotation; envelope encryption for the truly sensitive.
- **Tokenization/pseudonymization**: replace identifiers with tokens; analytics proceed, re-identification is gated.
- **De-identification for lower environments**: prod PII never lands raw in dev/test; use masking or synthetic data.
- **Secrets hygiene**: pipeline credentials in a secrets manager, short-lived tokens over static keys, per-pipeline identities — the [orchestrator](orchestration.md) is a favorite attack target because it holds credentials to everything.

## Privacy engineering specifics

- **Right to erasure at platform scale**: deletes must propagate through raw zones, derived tables, caches, backups (by expiry), and AI artifacts (indexes re-built, embeddings dropped) — [lineage](data-catalog-and-lineage.md) is the map; [table-format deletes](table-and-file-formats.md) are the mechanism.
- **Data minimization**: don't ingest what you can't justify; classification at the door ([data-ingestion.md](data-ingestion.md)).
- **Purpose control**: "collected for billing" ≠ "usable for ad targeting"; tag purpose and check at access time.

## The AI-era additions

AI consumers open genuinely new surfaces (detailed in [llmops.md](llmops.md) and [agents-and-mcp.md](agents-and-mcp.md)):

- **Prompt injection**: content the model reads can steer its behavior — assume it succeeds; limit what the model/agent *can do* (least-privilege tools, approval gates, egress controls).
- **Retrieval leaks**: [RAG](rag.md) over an index that ignored source ACLs is a breach generator — enforce permissions at query time in the retrieval layer.
- **Provider egress**: prompts are data transfers; classify what may go to which model provider, log everything. Sovereignty rules may force private serving for sensitive prompts ([hybrid-cloud.md](hybrid-cloud.md)).
- **Model artifacts remember**: fine-tuned weights and embeddings derived from personal data are personal-data derivatives — govern and delete accordingly.

## Audit: the part that saves you later

Log access to sensitive data (who, what, when, via which system — including AI-mediated access), retain per policy, and review anomalies. When the regulator or the incident comes, the audit log is the difference between a bad week and a bad year.

## Open source project comparison

| Project | Security/privacy role | Watch-outs |
|---|---|---|
| **Open Policy Agent (OPA)** | Policy-as-code decisions for services, gateways, and custom data access paths | Needs integration with identity, catalogs, logs, and engines |
| **Apache Ranger** | Central policy administration and auditing for supported big-data engines | Strong in Hadoop/lake ecosystems; coverage varies across modern lakehouse engines |
| **Keycloak** | OSS identity provider for SSO/OIDC/SAML in self-hosted stacks | Identity provider, not data authorization; pair with engine/catalog enforcement |
| **Vault / OpenBao** | Secrets management, dynamic credentials, encryption workflows | Secrets hygiene only works if pipelines stop carrying static keys |
| **Trino/Apache Superset row/column controls** | Engine/application-level access enforcement | Useful last-mile controls; avoid bypass via raw object-store access |

The safe pattern is identity in one place, policy as code, enforcement at engines/catalogs/gateways, and raw storage locked away from direct users.

## Related

- [data-governance.md](data-governance.md)
- [agents-and-mcp.md](agents-and-mcp.md)
- [rag.md](rag.md)
