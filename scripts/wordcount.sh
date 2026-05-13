#!/usr/bin/env bash
# scripts/wordcount.sh
# Body word count for offline / CI use (Overleaf has its own live counter
# via preamble/wordcount.tex).
#
# Excludes: front matter, working-notes pages, appendices, captions,
# table cells, figure floats.

set -euo pipefail
cd "$(dirname "$0")/.."

# Body files — keep in sync with content/body-sections.tex.
BODY_FILES=(
    sections/01_introduction.tex
    sections/02_market.tex
    # Append new sections here as the report grows.
)

if ! command -v texcount &> /dev/null; then
    echo "error: texcount not found. Install with:"
    echo "  Ubuntu/Debian: sudo apt install texlive-extra-utils"
    echo "  macOS:         brew install texcount  (or via MacTeX)"
    exit 1
fi

echo "=========================================="
echo "Body word count (rubric-assessed content)"
echo "=========================================="
echo

total=0
for f in "${BODY_FILES[@]}"; do
    if [[ ! -f "$f" ]]; then
        printf "  %-50s  (missing)\n" "$f"
        continue
    fi
    count=$(texcount -1 -sum -merge "$f" 2>/dev/null | awk '{print $1}')
    printf "  %-50s %5d\n" "$f" "$count"
    total=$((total + count))
done

echo "  --------------------------------------------------  -----"
printf "  %-50s %5d\n" "TOTAL" "$total"
echo

# Read total limit from meta/project.tex
limit=$(grep -oE '\\newcommand\{\\wclimitTotal\}\{[0-9]+\}' meta/project.tex \
       | grep -oE '[0-9]+' || echo 5000)
echo "  Limit:    $limit words"
echo "  Headroom: $((limit - total)) words"
echo

if [ "$total" -gt "$limit" ]; then
    echo "  STATUS: OVER LIMIT"
    exit 1
elif [ "$total" -gt "$((limit * 95 / 100))" ]; then
    echo "  STATUS: approaching limit (95% used)"
else
    echo "  STATUS: within limit"
fi
