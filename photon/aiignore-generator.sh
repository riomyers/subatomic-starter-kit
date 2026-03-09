#!/bin/bash
# Photon — .aiignore Generator
# Analyzes project and generates optimized .aiignore
# Usage: ./aiignore-generator.sh [project-dir] [--dry-run] [--preset <type>]

set -euo pipefail

PROJECT_DIR="${1:-.}"
DRY_RUN=false
PRESET=""
OUTPUT_FILE="${PROJECT_DIR}/.aiignore"

# Parse flags
shift 2>/dev/null || true
while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=true; shift ;;
    --preset) PRESET="$2"; shift 2 ;;
    --output) OUTPUT_FILE="$2"; shift 2 ;;
    *) shift ;;
  esac
done

echo "Photon .aiignore Generator"
echo "========================="
echo "Project: $PROJECT_DIR"
echo ""

# ============================================================
# DETECTION: Scan project for framework/tooling signals
# ============================================================

RULES=()

# Always ignore
RULES+=("# === Universal (always ignore) ===")
RULES+=("node_modules/")
RULES+=(".git/")
RULES+=("dist/")
RULES+=("build/")
RULES+=(".next/")
RULES+=(".nuxt/")
RULES+=(".svelte-kit/")
RULES+=(".cache/")
RULES+=("coverage/")
RULES+=("*.min.js")
RULES+=("*.min.css")
RULES+=("*.map")
RULES+=("*.lock")
RULES+=("package-lock.json")
RULES+=("pnpm-lock.yaml")
RULES+=("yarn.lock")
RULES+=("*.wasm")
RULES+=("*.pyc")
RULES+=("__pycache__/")
RULES+=(".env*")
RULES+=("")

# Lock files (huge token waste)
if [ -f "$PROJECT_DIR/package-lock.json" ]; then
  echo "  Detected: package-lock.json ($(wc -c < "$PROJECT_DIR/package-lock.json" | awk '{printf "%.0fKB", $1/1024}') — major token waste)"
fi
if [ -f "$PROJECT_DIR/pnpm-lock.yaml" ]; then
  echo "  Detected: pnpm-lock.yaml ($(wc -c < "$PROJECT_DIR/pnpm-lock.yaml" | awk '{printf "%.0fKB", $1/1024}'))"
fi

# Framework-specific
if [ -f "$PROJECT_DIR/next.config.js" ] || [ -f "$PROJECT_DIR/next.config.mjs" ] || [ -f "$PROJECT_DIR/next.config.ts" ]; then
  echo "  Detected: Next.js project"
  RULES+=("# === Next.js ===")
  RULES+=(".next/")
  RULES+=(".vercel/")
  RULES+=("out/")
  RULES+=("")
fi

if [ -f "$PROJECT_DIR/vite.config.js" ] || [ -f "$PROJECT_DIR/vite.config.ts" ]; then
  echo "  Detected: Vite project"
  RULES+=("# === Vite ===")
  RULES+=("dist/")
  RULES+=(".vite/")
  RULES+=("")
fi

if [ -f "$PROJECT_DIR/svelte.config.js" ]; then
  echo "  Detected: SvelteKit project"
  RULES+=("# === SvelteKit ===")
  RULES+=(".svelte-kit/")
  RULES+=("")
fi

if [ -f "$PROJECT_DIR/pyproject.toml" ] || [ -f "$PROJECT_DIR/setup.py" ]; then
  echo "  Detected: Python project"
  RULES+=("# === Python ===")
  RULES+=("__pycache__/")
  RULES+=("*.pyc")
  RULES+=("*.pyo")
  RULES+=(".venv/")
  RULES+=("venv/")
  RULES+=("*.egg-info/")
  RULES+=(".mypy_cache/")
  RULES+=(".ruff_cache/")
  RULES+=("")
fi

if [ -f "$PROJECT_DIR/Cargo.toml" ]; then
  echo "  Detected: Rust project"
  RULES+=("# === Rust ===")
  RULES+=("target/")
  RULES+=("Cargo.lock")
  RULES+=("")
fi

if [ -f "$PROJECT_DIR/go.mod" ]; then
  echo "  Detected: Go project"
  RULES+=("# === Go ===")
  RULES+=("vendor/")
  RULES+=("")
fi

# Large generated files
RULES+=("# === Generated/Binary ===")
if [ -d "$PROJECT_DIR/public" ]; then
  RULES+=("public/*.ico")
  RULES+=("public/*.woff*")
  RULES+=("public/*.ttf")
  RULES+=("public/*.eot")
fi
RULES+=("*.png")
RULES+=("*.jpg")
RULES+=("*.jpeg")
RULES+=("*.gif")
RULES+=("*.svg")
RULES+=("*.ico")
RULES+=("*.woff")
RULES+=("*.woff2")
RULES+=("*.ttf")
RULES+=("*.eot")
RULES+=("*.mp4")
RULES+=("*.mp3")
RULES+=("*.pdf")
RULES+=("")

# Documentation that confuses more than helps
RULES+=("# === Docs (optional — uncomment if causing confusion) ===")
RULES+=("# CHANGELOG.md")
RULES+=("# CONTRIBUTING.md")
RULES+=("# LICENSE")
RULES+=("")

echo ""

# ============================================================
# OUTPUT
# ============================================================

if [ "$DRY_RUN" = true ]; then
  echo "=== DRY RUN: Would write to $OUTPUT_FILE ==="
  echo ""
  printf '%s\n' "${RULES[@]}"
  
  # Estimate savings
  TOTAL_IGNORED=0
  for rule in "${RULES[@]}"; do
    [[ "$rule" == "#"* || -z "$rule" ]] && continue
    MATCHED=$(/usr/bin/find "$PROJECT_DIR" -path "*/${rule%/}" -type f 2>/dev/null | head -100 | wc -l | tr -d ' ')
    TOTAL_IGNORED=$((TOTAL_IGNORED + MATCHED))
  done
  echo ""
  echo "Estimated files excluded: ~${TOTAL_IGNORED}"
else
  printf '%s\n' "${RULES[@]}" > "$OUTPUT_FILE"
  echo "Written to: $OUTPUT_FILE"
  echo "Rules: $(echo "${RULES[@]}" | tr ' ' '\n' | grep -v '^#' | grep -v '^$' | wc -l | tr -d ' ') patterns"
fi
