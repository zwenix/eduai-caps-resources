#!/bin/bash
# Validates that all PDFs in the repo follow the naming convention
# Usage: bash scripts/validate-naming.sh

PATTERN="^(gr[R0-9]{1,2})-([\w-]+)-(lesson-plan|worksheet|homework|assessment|rubric|report|learning-plan)-term[1-4]-([\w-]+)\.(pdf|docx)$"

echo "Checking file naming convention..."
ERRORS=0

while IFS= read -r -d '' file; do
  filename=$(basename "$file")
  if [[ ! "$filename" =~ $PATTERN && "$filename" != ".gitkeep" ]]; then
    echo "❌ Invalid filename: $file"
    ERRORS=$((ERRORS + 1))
  fi
done < <(find grades resources-by-type -type f -print0)

if [ "$ERRORS" -eq 0 ]; then
  echo "✅ All filenames are valid!"
else
  echo ""
  echo "$ERRORS file(s) have invalid names. Please rename them."
  echo "See CONTRIBUTING.md for the naming convention."
fi
