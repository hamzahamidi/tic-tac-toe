#!/usr/bin/env bash
# Pushes UAT evidence (JUnit, videos, screenshots) to S3 on release runs only.
set -euo pipefail

env_name="${1:?usage: upload-evidence.sh <staging|production>}"
root="$(cd "$(dirname "$0")/../.." && pwd)"

if [[ "${IS_RELEASE:-false}" != "true" ]]; then
  echo "IS_RELEASE is not true; skipping evidence upload"
  exit 0
fi

bucket="${EVIDENCE_BUCKET:?EVIDENCE_BUCKET must be set}"
run_id="${PIPELINE_ID:-local-$(date -u +%Y%m%dT%H%M%SZ)}"
shard="${SHARD_INDEX:-0}"
prefix="s3://$bucket/$env_name/$run_id/shard-$shard"

for dir in results videos screenshots; do
  src="$root/cypress/$dir"
  [[ -d "$src" ]] || continue
  if [[ -n "${DRY_RUN:-}" ]]; then
    echo "would sync $src -> $prefix/$dir/"
    find "$src" -type f | sed 's/^/  /'
  else
    aws s3 sync "$src" "$prefix/$dir/"
  fi
done
