#!/usr/bin/env bash
# Starts this project's `uat` workflow through the CircleCI API and blocks until
# it finishes, so the calling workflow can gate on the result.
set -euo pipefail

env_name="${1:?usage: trigger-and-wait.sh <staging|production> [is_release]}"
is_release="${2:-false}"
token="${CIRCLE_TOKEN:?CIRCLE_TOKEN must be set}"
slug="${CIRCLE_PROJECT_SLUG:-gh/${CIRCLE_PROJECT_USERNAME:?}/${CIRCLE_PROJECT_REPONAME:?}}"
branch="${CIRCLE_BRANCH:-main}"
api="https://circleci.com/api/v2"
timeout_seconds="${E2E_TIMEOUT_SECONDS:-3600}"

body="$(jq -n --arg branch "$branch" --arg env "$env_name" --argjson release "$is_release" \
  '{branch: $branch, parameters: {run_e2e: true, e2e_target_environment: $env, is_release: $release}}')"

pipeline="$(curl -fsS -X POST "$api/project/$slug/pipeline" \
  -H "Circle-Token: $token" -H "Content-Type: application/json" \
  -d "$body")"
pipeline_id="$(jq -r '.id' <<<"$pipeline")"
pipeline_number="$(jq -r '.number' <<<"$pipeline")"
# The web app spells VCS prefixes out in full; API slugs abbreviate them.
ui_slug="$(sed -e 's#^gh/#github/#' -e 's#^bb/#bitbucket/#' <<<"$slug")"
echo "Triggered pipeline $pipeline_id (uat, $env_name)"
echo "Follow it at https://app.circleci.com/pipelines/$ui_slug/$pipeline_number"

deadline=$(( $(date +%s) + timeout_seconds ))
while (( $(date +%s) < deadline )); do
  sleep 15
  workflows="$(curl -fsS "$api/pipeline/$pipeline_id/workflow" -H "Circle-Token: $token")"
  status="$(jq -r '.items[] | select(.name == "uat") | .status' <<<"$workflows")"
  echo "uat workflow status: ${status:-pending}"
  case "$status" in
    success) exit 0 ;;
    failed|error|canceled|unauthorized|not_run) exit 1 ;;
  esac
done

echo "Timed out after ${timeout_seconds}s waiting for pipeline $pipeline_id"
exit 1
