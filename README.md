# Mini Data/AI Platform Wiki

A practical knowledge base about **data & AI platforms** — storage, pipelines, modeling, governance, ML infrastructure, and the GenAI layer on top — structured as an **agent-maintained wiki** following [Karpathy's llm-wiki pattern](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f): an LLM agent does the bookkeeping (filing, cross-referencing, linting) while humans direct and curate.

## How it's organized

| File / dir | Role |
|---|---|
| **[index.md](index.md)** | Start here — catalog of every page with one-line summaries, by category |
| **[pages/](pages/)** | The wiki: one concept per page, flat, heavily cross-linked |
| **[CLAUDE.md](CLAUDE.md)** | The schema: page conventions and the ingest / query / lint workflows the maintaining agent follows |
| **[log.md](log.md)** | Append-only record of every ingest, query, and lint operation |
| **[sources/](sources/README.md)** | Immutable raw material (papers, articles, notes) the pages draw on |

The three-layer idea: **sources** are the authoritative raw ground truth, **pages** are the LLM-curated synthesis, and the **schema** keeps the agent's maintenance consistent. Categories live in page frontmatter and the index — not directory structure — so pages can be re-shelved without breaking links.

## Coverage

33 pages across 9 categories:

**fundamentals** (what a platform is, OLTP/OLAP, batch/streaming) · **storage** (warehouse, lake, lakehouse, table formats) · **ingestion-processing** (ingestion, transformation, orchestration, streaming) · **modeling-serving** (data modeling, semantic layer, query engines) · **governance-quality** (governance, catalog & lineage, quality, security) · **ml-platform** (ML platform, feature stores, model serving, MLOps) · **genai-platform** (LLMs, embeddings, vector DBs, RAG, LLMOps, agents & MCP) · **platform-architecture** (reference architecture, data mesh, build-vs-buy, FinOps) · **reference** (glossary)

## Using it

- **Read**: browse from [index.md](index.md), or open the folder in Obsidian (links are plain relative Markdown).
- **Ask**: point an agent (e.g. Claude Code) at this repo and ask questions — CLAUDE.md tells it to answer from the wiki with citations.
- **Grow**: drop a paper or article into `sources/` and ask the agent to ingest it; it updates the relevant pages, the index, and the log.
- **Maintain**: periodically ask the agent to run the lint workflow from CLAUDE.md.

## Serving as a site

The wiki lives flat at the repo root (the Karpathy layout); MkDocs needs an
isolated docs dir, so a small script stages it into `docs/` first:

```bash
pip install mkdocs mkdocs-material
./scripts/stage-docs.sh   # copies index.md, log.md, pages/, sources/ → docs/
mkdocs serve
```

Every push to `main` also builds the site and deploys it to **GitHub Pages**
via [`.github/workflows/deploy-docs.yml`](.github/workflows/deploy-docs.yml)
(strict build — a broken link fails CI).
