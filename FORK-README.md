# Open WebUI Fork — iOS Call Mode Fix

This fork adds a minimal patch to fix iOS Call Mode truncation (~14-20s audio cutoff).

## What's Changed

**File:** `src/lib/components/chat/MessageInput/CallOverlay.svelte`

1. **MediaRecorder heartbeat** — Calls `requestData()` every 2s to prevent Safari/iOS stalling
2. **iOS mimeType preference** — Prefers `audio/mp4;codecs=mp4a.40.2` when supported (better iOS codec)

## Branch Strategy

| Branch | Purpose |
|--------|---------|
| `main` | Auto-synced daily from upstream `open-webui/open-webui` |
| `feature/call-mode-ios-heartbeat` | Contains the iOS fix patch |

## Docker Image

Built automatically on push to `feature/call-mode-ios-heartbeat`:

```
ghcr.io/<your-org>/open-webui:iosfix-main      # Latest
ghcr.io/<your-org>/open-webui:iosfix-<sha>     # Pinned by commit
```

## Railway Deployment

Point your Railway service to:
```
ghcr.io/<your-org>/open-webui:iosfix-main
```

Enable auto-deploy on new image push.

### Rollback

If a build breaks, switch to the last known good `iosfix-<sha>` tag.

## Secrets Required

Add these to GitHub → Settings → Secrets → Actions:

- `GHCR_USERNAME` — Your GitHub username
- `GHCR_TOKEN` — Classic PAT with `repo`, `read:packages`, `write:packages`

## Root Cause

On iPhone, long-running MediaRecorder without periodic data flushing causes the Web Audio analyser to stall around 15-20s, creating false silence detection → premature stop → truncated audio.

The heartbeat keeps data flowing, preventing the stall.
