# Wiki schema

This repository is an **agent-maintained wiki** about LLMs on data/AI platforms, following the pattern in [Karpathy's llm-wiki gist](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f): raw sources are immutable, the wiki is the LLM-curated layer on top, and this file is the schema that tells the agent (you) how to maintain it.

## Layout

```
CLAUDE.md      ← this schema: structure, conventions, workflows
index.md       ← catalog of every page, one line each, by category
log.md         ← append-only operation log
sources/       ← raw source material (papers, articles, notes) — immutable
pages/         ← the wiki itself: one concept per page, flat, kebab-case
README.md      ← human-facing intro
mkdocs.yml     ← optional site rendering
```

## Page conventions

- **One concept per page**, flat in `pages/`, kebab-case filename matching the concept (`vector-databases.md`).
- Every page starts with frontmatter:

  ```yaml
  ---
  title: Vector databases
  category: data-platform        # one of the categories in index.md
  updated: YYYY-MM-DD            # bump on any substantive edit
  sources: [sources/foo.pdf]     # optional: raw sources this page draws on
  ---
  ```

- Body: `# Title`, a one-paragraph definition first (it doubles as the index summary), then the substance. Target under ~150 lines; split pages that outgrow it.
- **Cross-link aggressively** — links are the wiki's value. Pages are siblings, so link with the bare filename: `embeddings.md`. Every page ends with a `## Related` section (2–4 links).
- Prefer vendor-neutral explanations; name specific tools only in clearly-scoped comparison tables or "Tooling" notes.
- Categories: `fundamentals`, `data-platform`, `rag`, `training-adaptation`, `inference-serving`, `llmops`, `agents-integration`, `platform-architecture`, `reference`. Add a new category only when several pages don't fit existing ones; update index.md headings when you do.

## Workflows

### Ingest (new source or fact arrives)
1. If it's a document, save the raw file under `sources/` (never edit sources afterward).
2. Read it; decide which existing pages it updates vs. what new page it justifies. **Prefer updating existing pages over creating new ones.**
3. Apply edits: integrate the information where it belongs, add cross-references both ways, bump `updated`, record the source in frontmatter `sources:` when applicable.
4. Update `index.md` if pages were added/renamed/re-scoped.
5. Append one line to `log.md` with the `INGEST:` prefix.

### Query (answering questions from the wiki)
1. Start from `index.md` to locate candidate pages; read those pages (and their Related links) before answering.
2. Answer with citations to wiki pages (`pages/foo.md`).
3. If the answer required synthesis not written down anywhere, consider filing it back as a page edit or new page (then follow the ingest steps 3–5). Log noteworthy queries with `QUERY:`.

### Lint (periodic audit)
Check and fix, logging a `LINT:` line with findings:
- Broken relative links (every relative `.md` link must resolve; inline-code examples in this schema are exempt).
- Orphan pages (not reachable from `index.md`).
- Index/page drift: every page in `pages/` listed exactly once in `index.md`; summaries still accurate.
- Contradictions and stale claims (dated facts older than ~12 months get reviewed; this field moves fast — flag anything that smells outdated with a `> ⚠️ Review:` blockquote rather than silently keeping it).
- Frontmatter present and valid on every page.

## Log conventions

`log.md` is append-only, newest at the bottom, one line per operation:

```
- YYYY-MM-DD INGEST: <what was added/updated and why>
- YYYY-MM-DD QUERY: <question asked → pages used>
- YYYY-MM-DD LINT: <checks run → findings/fixes>
- YYYY-MM-DD REORG: <structural changes>
```

Never rewrite history in `log.md`; corrections get a new line.
