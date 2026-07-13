---
title: Data catalog & lineage
category: governance-quality
updated: 2026-07-13
sources: [sources/2026-07-open-source-project-comparisons.md, sources/2026-07-commercial-product-comparisons.md]
---

# Data catalog & lineage

The **catalog** is the platform's searchable inventory — every dataset, its schema, owner, docs, classification, and quality status. **Lineage** is the dependency graph — what feeds what, from source system to dashboard (and now to [model and RAG index](llms-on-the-platform.md)). Together they answer the two questions every data consumer asks: *"what data do we have and can I trust it?"* and *"if I change/break this, what downstream burns?"*

## Catalog: what good looks like

- **Automated harvesting**: schemas, usage stats, and freshness scraped from warehouses, lakes, BI tools — a manually-curated catalog is stale by week two.
- **Human enrichment where it counts**: descriptions, ownership, classification on tier-1 assets; [transformation frameworks](data-transformation.md) let docs live with code and publish automatically.
- **Social signals**: query counts, top users, linked dashboards — popularity is a trust heuristic.
- **Deprecation workflow**: marking an asset deprecated with a pointer to its replacement; catalogs that only add become landfills.

Tools: DataHub, OpenMetadata, Collibra/Alation/Atlan, cloud-native (Unity Catalog, Dataplex, Purview). Note the convergence: lakehouse *technical* catalogs ([lakehouse.md](lakehouse.md)) increasingly merge with *discovery* catalogs into one governance plane.

## Lineage: the dependency graph

```
source DB → raw table → core models → mart → dashboard
                          ↘ feature view → model → predictions
                          ↘ chunks → embeddings → RAG index → AI app
```

What it unlocks:

- **Impact analysis**: "who breaks if I drop this column?" answered before the incident, not by it.
- **Root-cause**: dashboard wrong → walk upstream to the failed [ingestion](data-ingestion.md) job in minutes.
- **Governance propagation**: classification and access policy inherited along edges ([data-governance.md](data-governance.md)); right-to-erasure traced to every derivative.
- **AI provenance**: which documents fed the index that produced this answer — increasingly a compliance requirement, not a nicety.

**Column-level** lineage is where real value lives (table-level is too coarse for impact analysis); get it from SQL parsing (warehouse query logs) and framework metadata, stitched via **OpenLineage** — the emerging exchange standard worth demanding from vendors.

## Adoption honesty

Catalogs fail socially, not technically: bought, populated, ignored. What works — wire the catalog into workflows (search from the IDE/BI tool, ownership pings on quality incidents), start with the 50 assets people actually fight over, and let [AI assistants query the catalog](agents-and-mcp.md) so documentation pays rent as machine context, not just human reading.

## Open source project comparison

| Project | Best fit | Watch-outs |
|---|---|---|
| **OpenMetadata** | All-in-one OSS catalog with schemas, owners, docs, lineage, quality, and governance workflows | Easier to adopt as a visible product; still needs curation on tier-1 assets |
| **DataHub** | Metadata graph, streaming metadata, API-first integration, large platform teams | Powerful substrate; may need more platform engineering to shape the user experience |
| **OpenLineage** | Standard lineage events emitted by Airflow, Spark, dbt, and other tools | Event standard, not a catalog UI; pair with DataHub/OpenMetadata/Marquez |
| **Marquez** | Lightweight lineage collection and visualization around OpenLineage | Good lineage-only start; limited discovery/governance compared with full catalogs |
| **Amundsen** | Search/discovery-oriented legacy OSS catalog pattern | Less momentum than newer OpenMetadata/DataHub paths |

Default to OpenMetadata when you want an integrated catalog product; choose DataHub when metadata graph extensibility and streaming ingestion are central.

## Commercial product comparison

| Product | Best fit | Watch-outs |
|---|---|---|
| **Atlan** | Active metadata, collaboration, lineage, and modern catalog UX across tools | Validate depth for your most important engines and BI tools |
| **Alation** | Analyst discovery, query intelligence, stewardship, and broad enterprise cataloging | Strong adoption story; policy enforcement still depends on connected systems |
| **Collibra** | Formal governance, data office workflows, glossary, compliance reporting | Heavyweight; value depends on stewardship process maturity |
| **Microsoft Purview** | Microsoft/Azure catalog, scanning, classification, and compliance | Best when Microsoft is the platform center |
| **Databricks Unity Catalog** | Technical catalog, permissions, lineage, and discovery for Databricks lakehouse assets | Not a universal catalog unless most assets live in Databricks |
| **Google Dataplex / Data Catalog, AWS Glue/Lake Formation** | Cloud-native catalog/governance inside GCP or AWS | Good local defaults; multi-cloud discovery often needs another layer |

Pick a catalog by where metadata is created and where users work. The best catalog is the one wired into pull requests, BI, incidents, and access requests.

## Related

- [data-governance.md](data-governance.md)
- [data-quality.md](data-quality.md)
- [semantic-layer.md](semantic-layer.md)
