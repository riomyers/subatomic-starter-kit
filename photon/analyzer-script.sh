#!/bin/bash
# Photon Token Analyzer v1.0
# Analyzes your project to show token costs per file and directory
# Usage: bash analyzer-script.sh [directory] [--top N] [--format json|table]
#
# Token estimation: ~4 chars per token (standard BPE approximation)

set -euo pipefail

# Defaults
TARGET_DIR="${1:-.}"
TOP_N=20
FORMAT="table"
CHARS_PER_TOKEN=4

# Parse flags
shift || true
while [ $# -gt 0 ]; do
    case "$1" in
        --top) TOP_N="$2"; shift 2 ;;
        --format) FORMAT="$2"; shift 2 ;;
        --help|-h)
            echo "Usage: photon-analyze [directory] [--top N] [--format table|json]"
            echo "  Analyzes token costs per file in your project"
            exit 0
            ;;
        *) shift ;;
    esac
done

# Common ignore patterns (same as what AI tools ignore)
IGNORE_DIRS="node_modules|.git|.next|dist|build|out|.nuxt|.output|__pycache__|.pytest_cache|.mypy_cache|.tox|.venv|venv|env|.env|coverage|.coverage|.nyc_output|.cache|.parcel-cache|.turbo|.vercel|.netlify|target|vendor|Pods|.gradle|.idea|.vscode"
IGNORE_FILES="package-lock.json|pnpm-lock.yaml|yarn.lock|Cargo.lock|poetry.lock|Pipfile.lock|composer.lock|Gemfile.lock|go.sum|bun.lockb"
IGNORE_EXTS="png|jpg|jpeg|gif|svg|ico|webp|avif|mp4|mp3|wav|woff|woff2|ttf|eot|otf|zip|tar|gz|bz2|rar|7z|pdf|exe|dll|so|dylib|o|a|pyc|pyo|class|jar|war|wasm|map|min.js|min.css|chunk.js|chunk.css"

echo "==================================="
echo "  Photon Token Analyzer v1.0"
echo "==================================="
echo ""
echo "Scanning: $(cd "$TARGET_DIR" && pwd)"
echo ""

# Count files and calculate tokens
TOTAL_CHARS=0
TOTAL_FILES=0
TEMP_FILE=$(mktemp)

# Find all text files, excluding common non-code directories and files
find "$TARGET_DIR" -type f \
    -not -path "*/.git/*" \
    -not -path "*/node_modules/*" \
    -not -path "*/.next/*" \
    -not -path "*/dist/*" \
    -not -path "*/build/*" \
    -not -path "*/__pycache__/*" \
    -not -path "*/.venv/*" \
    -not -path "*/venv/*" \
    -not -path "*/.cache/*" \
    -not -path "*/.turbo/*" \
    -not -path "*/coverage/*" \
    -not -path "*/target/*" \
    -not -path "*/vendor/*" \
    2>/dev/null | while read -r file; do

    BASENAME=$(basename "$file")

    # Skip lock files
    case "$BASENAME" in
        package-lock.json|pnpm-lock.yaml|yarn.lock|Cargo.lock|poetry.lock|bun.lockb|go.sum)
            continue ;;
    esac

    # Skip binary/media files by extension
    EXT="${BASENAME##*.}"
    case "$EXT" in
        png|jpg|jpeg|gif|svg|ico|webp|avif|mp4|mp3|wav|woff|woff2|ttf|eot|otf)
            continue ;;
        zip|tar|gz|bz2|rar|7z|pdf|exe|dll|so|dylib|o|a|pyc|pyo|class|jar|war|wasm)
            continue ;;
        map)
            continue ;;
    esac

    # Skip minified files
    case "$BASENAME" in
        *.min.js|*.min.css|*.chunk.js|*.chunk.css)
            continue ;;
    esac

    # Get file size in characters (fast check: if file > 1MB, probably not code)
    SIZE=$(wc -c < "$file" 2>/dev/null || echo "0")
    if [ "$SIZE" -gt 1048576 ]; then
        continue
    fi

    # Check if it's a text file (quick heuristic: first 512 bytes)
    if ! head -c 512 "$file" 2>/dev/null | LC_ALL=C grep -qP '[\x00-\x08\x0E-\x1F]' 2>/dev/null; then
        CHARS=$(wc -m < "$file" 2>/dev/null || echo "0")
        TOKENS=$(( CHARS / CHARS_PER_TOKEN ))
        REL_PATH=$(python3 -c "import os; print(os.path.relpath('$file', '$TARGET_DIR'))" 2>/dev/null || echo "$file")
        echo "$TOKENS $CHARS $REL_PATH" >> "$TEMP_FILE"
    fi
done

# Sort by token count (descending)
sort -rn "$TEMP_FILE" -o "$TEMP_FILE"

# Calculate totals
TOTAL_TOKENS=$(awk '{sum+=$1} END {print sum+0}' "$TEMP_FILE")
TOTAL_CHARS=$(awk '{sum+=$2} END {print sum+0}' "$TEMP_FILE")
TOTAL_FILES=$(wc -l < "$TEMP_FILE" | tr -d ' ')

echo "Summary"
echo "-------"
echo "  Files scanned:  $TOTAL_FILES"
echo "  Total chars:    $(printf "%'d" "$TOTAL_CHARS")"
echo "  Est. tokens:    $(printf "%'d" "$TOTAL_TOKENS")"
echo ""

# Context window usage
echo "Context Window Usage"
echo "--------------------"
CLAUDE_WINDOW=200000
GEMINI_WINDOW=1000000
CLAUDE_PCT=$(( TOTAL_TOKENS * 100 / CLAUDE_WINDOW ))
GEMINI_PCT=$(( TOTAL_TOKENS * 100 / GEMINI_WINDOW ))
echo "  Claude (200K):  ${CLAUDE_PCT}% of context"
echo "  Gemini (1M):    ${GEMINI_PCT}% of context"
echo ""

# Top files by token usage
echo "Top $TOP_N Files by Token Cost"
echo "------------------------------"
printf "  %-8s  %-8s  %s\n" "Tokens" "Chars" "File"
printf "  %-8s  %-8s  %s\n" "------" "-----" "----"
head -n "$TOP_N" "$TEMP_FILE" | while read -r tokens chars path; do
    printf "  %-8s  %-8s  %s\n" "$(printf "%'d" "$tokens")" "$(printf "%'d" "$chars")" "$path"
done

echo ""

# Directory breakdown
echo "Top Directories by Token Cost"
echo "------------------------------"
awk '{
    split($3, parts, "/")
    dir = parts[1]
    if (length(parts) > 1) dir = parts[1] "/" parts[2]
    tokens[dir] += $1
    files[dir] += 1
}
END {
    for (d in tokens) print tokens[d], files[d], d
}' "$TEMP_FILE" | sort -rn | head -10 | while read -r tokens files dir; do
    printf "  %-8s  (%d files)  %s\n" "$(printf "%'d" "$tokens")tk" "$files" "$dir"
done

echo ""

# Suggestions
echo "Optimization Suggestions"
echo "------------------------"

# Check for large generated files
GENERATED=$(awk '$1 > 5000 && ($3 ~ /generated|__generated|\.d\.ts$|\.schema\.|swagger|openapi/)' "$TEMP_FILE" | wc -l | tr -d ' ')
if [ "$GENERATED" -gt 0 ]; then
    echo "  [!] $GENERATED generated/schema files detected (>5K tokens each)"
    echo "      Add to .aiignore: **/generated/*, **/*.d.ts, **/swagger.*, **/openapi.*"
fi

# Check for test files
TESTS=$(awk '$3 ~ /(test|spec|__tests__|\.test\.|\.spec\.)/' "$TEMP_FILE" | awk '{sum+=$1} END {print sum+0}')
if [ "$TESTS" -gt 10000 ]; then
    echo "  [!] Test files using $(printf "%'d" "$TESTS") tokens"
    echo "      Add to .aiignore if not actively testing: **/__tests__/*, **/*.test.*, **/*.spec.*"
fi

# Check for docs
DOCS=$(awk '$3 ~ /(docs\/|documentation\/|\.md$)/' "$TEMP_FILE" | awk '{sum+=$1} END {print sum+0}')
if [ "$DOCS" -gt 5000 ]; then
    echo "  [!] Documentation using $(printf "%'d" "$DOCS") tokens"
    echo "      Add to .aiignore: docs/*, *.md (keep README.md and CLAUDE.md)"
fi

echo ""
echo "Run 'photon-generate' to create an optimized .aiignore"

# Cleanup
rm -f "$TEMP_FILE"
