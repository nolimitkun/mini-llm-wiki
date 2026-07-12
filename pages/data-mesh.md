---
title: Data mesh & team topologies
category: platform-architecture
updated: 2026-07-12
---

# Data mesh & team topologies

**Data mesh** is an organizational architecture: instead of one central team owning all pipelines (and becoming the bottleneck every request queues behind), **domain teams own their data as products**, served on a shared self-serve platform under federated governance. It's a sociotechnical answer to scale — the technology is the easy half.

## The four principles

1. **Domain ownership**: the team closest to the data (orders, payments, marketing) owns its pipelines, quality, and serving — they have the context; central teams never will.
2. **Data as a product**: each dataset has consumers-as-customers, an owner, documentation, [quality SLOs](data-quality.md), and a discoverable interface — the "data product" contract.
3. **Self-serve platform**: a platform team provides the paved road — [ingestion](data-ingestion.md), [transformation](data-transformation.md), [orchestration](orchestration.md), [catalog](data-catalog-and-lineage.md) — so domains ship without reinventing infrastructure ([what-is-a-data-platform.md](what-is-a-data-platform.md)).
4. **Federated computational governance**: global rules (classification, access, interop standards) defined centrally, enforced *by the platform as code*, applied by domains ([data-governance.md](data-governance.md)).

## Honest assessment

Mesh solves an org-scale problem; below that scale it adds coordination cost for nothing:

- **Fits**: many domains, many producing teams, a central team drowning in tickets, domain knowledge lost in translation.
- **Doesn't fit**: one data team of eight — you don't have a mesh problem, you have a backlog. Centralized delivery on good platform tooling is *correct* at small scale.
- **Fails when**: domains get ownership without headcount or skills ("mesh" as cost-shifting); governance federates into anarchy; the platform is too weak for self-service, so every domain rebuilds plumbing badly.

Most successful implementations are pragmatic hybrids: strong central platform + product thinking + domain ownership for the handful of domains with real capacity — not the full doctrine.

## Data contracts: the load-bearing mechanism

Whatever the topology, the enforceable unit is the **contract** at team boundaries: schema, semantics, SLA, owner — versioned, validated at [ingestion](data-ingestion.md), breaking changes negotiated rather than discovered. Contracts matter *more* in the AI era: [agents and RAG systems](agents-and-mcp.md) consume data products at runtime with no human in the loop to notice a silently changed column.

## Related

- [data-governance.md](data-governance.md)
- [what-is-a-data-platform.md](what-is-a-data-platform.md)
- [data-quality.md](data-quality.md)
