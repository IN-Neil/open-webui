#!/usr/bin/env bash
set -euo pipefail

echo "[reapply-patch] Fetching upstream and merging main (fast-forward if possible)" >&2
if git remote get-url upstream >/dev/null 2>&1; then
  git fetch upstream || true
  git merge --ff-only upstream/main || true
else
  echo "[reapply-patch] No upstream remote configured; skipping merge" >&2
fi

echo "[reapply-patch] Applying patches/call-mode.patch with 3-way merge" >&2
git apply --3way patches/call-mode.patch

echo "[reapply-patch] Done." >&2
