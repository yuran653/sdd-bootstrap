#!/bin/sh
# Copies assets/project/ into a target directory, preserving paths.
# Existing files are never overwritten; they are reported as skipped.
# Usage: sh bootstrap.sh [target-dir]   (default: current directory)

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
src="$script_dir/../assets/project"
target=${1:-.}

if [ ! -d "$src" ]; then
    echo "error: template directory not found: $src" >&2
    exit 1
fi
if [ ! -d "$target" ]; then
    echo "error: target is not a directory: $target" >&2
    exit 1
fi

created=0
skipped=0

# The file list goes through a temp file so the loop runs in this shell
# and the counters survive it.
list=$(mktemp)
trap 'rm -f "$list"' EXIT
(cd "$src" && find . -type f | sort) > "$list"

while IFS= read -r rel; do
    rel=${rel#./}
    dest="$target/$rel"
    if [ -e "$dest" ]; then
        echo "skipped  $rel"
        skipped=$((skipped + 1))
    else
        mkdir -p "$(dirname -- "$dest")"
        cp "$src/$rel" "$dest"
        echo "created  $rel"
        created=$((created + 1))
    fi
done < "$list"

echo "done: $created created, $skipped skipped"
