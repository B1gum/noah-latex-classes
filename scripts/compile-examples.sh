#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

examples=(
  noahnotes
  noahassignment
  rdproject
  noah-matlab
)

# Do NOT use "$repo_root//" here: recursive TeX lookup can mix auxiliary
# files between examples because every document is named main.tex.
export TEXINPUTS="$repo_root:${TEXINPUTS:-}"

for example in "${examples[@]}"; do
  echo "==> Compiling ${example}"

  (
    cd "$repo_root/examples/$example"
    latexmk -gg \
      -jobname="$example" \
      -r ../../latexmkrc \
      main.tex
  )
done
