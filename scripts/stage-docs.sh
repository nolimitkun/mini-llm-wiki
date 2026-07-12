#!/usr/bin/env bash
# Stage the flat wiki into a docs/ directory for MkDocs.
# The repo keeps the Karpathy llm-wiki layout at its root (pages/, index.md,
# log.md, sources/); MkDocs requires an isolated docs_dir, so we copy into one.
# Both local `mkdocs serve` and CI use this. docs/ is gitignored.
set -euo pipefail
cd "$(dirname "$0")/.."

rm -rf docs
mkdir -p docs
# index.md is the site home; README.md is for the GitHub repo view only.
# Copy everything the wiki cross-links to, so links resolve on the site too.
cp index.md log.md CLAUDE.md docs/
cp -r pages docs/pages
cp -r sources docs/sources
echo "Staged $(find docs -name '*.md' | wc -l) markdown files into docs/"
