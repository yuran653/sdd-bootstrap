#!/bin/sh
# Verifies a bootstrapped repository.
# Fails (exit 1) if any {{PLACEHOLDER}} is still unfilled.
# Lists every [TODO-CLARIFY] so it can be reported; these do not fail the check.
# The literal "[TODO-CLARIFY: <question>]" is the convention's own description
# in AGENTS.md, not an open item, so it is filtered out.
# Usage: sh check.sh [target-dir]   (default: current directory)

set -eu

target=${1:-.}
cd "$target"

paths=""
for p in AGENTS.md CLAUDE.md docs specs; do
    [ -e "$p" ] && paths="$paths $p"
done

if [ -z "$paths" ]; then
    echo "error: no bootstrapped files found in $target" >&2
    exit 1
fi

# shellcheck disable=SC2086
unfilled=$(grep -rn '{{[A-Z_]*}}' $paths || true)
# shellcheck disable=SC2086
todos=$(grep -rn 'TODO-CLARIFY' $paths | grep -v 'TODO-CLARIFY: <question>' || true)

if [ -n "$todos" ]; then
    echo "Open TODO-CLARIFY items:"
    echo "$todos"
else
    echo "Open TODO-CLARIFY items: none"
fi

if [ -n "$unfilled" ]; then
    echo "Unfilled placeholders:"
    echo "$unfilled"
    exit 1
fi

echo "Unfilled placeholders: none"
