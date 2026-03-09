# Photon — .aiignore Templates

## What is .aiignore?

`.aiignore` tells AI coding tools which files to exclude from context. Works like `.gitignore` but for AI context windows. Supported by Claude Code, Cursor, and other tools.

Every file NOT in .aiignore gets loaded into the AI's context when relevant, consuming tokens you're paying for.

---

## Universal Base (use for every project)

```gitignore
# === Photon .aiignore — Universal Base ===

# Lock files (huge, auto-generated, never hand-edited)
package-lock.json
pnpm-lock.yaml
yarn.lock
bun.lockb
Cargo.lock
poetry.lock
Pipfile.lock
composer.lock
Gemfile.lock
go.sum

# Build output (generated, not source)
dist/
build/
out/
.next/
.nuxt/
.output/
.vercel/
.netlify/
target/

# Dependencies (massive, never read)
node_modules/
vendor/
.venv/
venv/
env/
Pods/
.gradle/

# Cache and temp
.cache/
.turbo/
.parcel-cache/
__pycache__/
.pytest_cache/
.mypy_cache/
.tox/
*.pyc
*.pyo

# Coverage and test artifacts
coverage/
.coverage
.nyc_output/
test-results/
playwright-report/

# Source maps (generated, large)
*.map

# Minified files (generated, unreadable)
*.min.js
*.min.css
*.chunk.js
*.chunk.css

# Media (binary, not code)
*.png
*.jpg
*.jpeg
*.gif
*.svg
*.ico
*.webp
*.avif
*.mp4
*.mp3
*.wav
*.woff
*.woff2
*.ttf
*.eot
*.otf
*.pdf

# Archives
*.zip
*.tar
*.gz
*.bz2
*.rar
*.7z

# Compiled binaries
*.exe
*.dll
*.so
*.dylib
*.o
*.a
*.class
*.jar
*.war
*.wasm

# IDE
.idea/
.vscode/
*.swp
*.swo
*~

# OS
.DS_Store
Thumbs.db
```

---

## Next.js / React

```gitignore
# Include Universal Base above, plus:

# Next.js specific
.next/
out/
.vercel/

# Storybook build
storybook-static/

# Type declarations (auto-generated)
*.d.ts
!src/**/*.d.ts

# Large config files AI doesn't need
next-env.d.ts
tsconfig.tsbuildinfo
```

---

## Python / Data Science

```gitignore
# Include Universal Base above, plus:

# Jupyter checkpoints
.ipynb_checkpoints/

# Data files (large, not code)
*.csv
*.parquet
*.feather
*.h5
*.hdf5
*.pkl
*.pickle
data/
datasets/

# Model files
*.pt
*.pth
*.onnx
*.safetensors
models/

# Virtualenvs
.venv/
venv/
env/
.conda/

# Migrations (usually auto-generated)
# Uncomment if your migrations are auto-generated:
# migrations/
# alembic/versions/
```

---

## Go

```gitignore
# Include Universal Base above, plus:

# Go specific
go.sum
vendor/

# Test binaries
*.test

# Profiling
*.prof
*.out
```

---

## Monorepo

```gitignore
# Include Universal Base above, plus:

# Turborepo
.turbo/

# Per-package build outputs
apps/*/dist/
apps/*/.next/
apps/*/out/
packages/*/dist/
packages/*/build/

# Per-package node_modules (if hoisted)
# node_modules/ in base covers root

# Changesets
.changeset/

# Auto-generated type packages
packages/*/tsconfig.tsbuildinfo
```

---

## Token Savings Estimates

| Pattern | Typical Savings | Why |
|---------|----------------|-----|
| Lock files | 50K-500K tokens | Lock files are massive JSON, never hand-edited |
| node_modules | 1M+ tokens | Entire dependency tree, thousands of files |
| Build output | 100K-500K tokens | Generated code, already have the source |
| Source maps | 50K-200K tokens | Debug artifacts, larger than source |
| Media files | N/A (binary) | AI tools skip these anyway, but explicit is better |
| Test files | 10K-100K tokens | Only include when actively testing |
| Generated types | 10K-50K tokens | Auto-generated from schema, not hand-written |

**Conservative estimate**: A well-configured .aiignore saves 200K-2M tokens per session on a typical project. At Claude's pricing, that's $3-30 per session in reduced costs.
