#!/usr/bin/env bash
set -euo pipefail

# Regenerate patch for CallOverlay changes
REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT"
mkdir -p patches

echo "[rebuild-patch] Writing diff to patches/call-mode.patch" >&2
git diff src/lib/components/chat/MessageInput/CallOverlay.svelte > patches/call-mode.patch

echo "[rebuild-patch] Done." >&2
