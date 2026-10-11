#!/usr/bin/env bash
# Runs the @uat scenarios against a deployed environment. Specs are passed in
# by the CI provider so it can split them across parallel runners.
set -euo pipefail

env_name="${1:?usage: run-uat.sh <staging|production> [spec,spec,...]}"
specs="${2:-}"
root="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$root"

CYPRESS_BASE_URL="$(scripts/ci/site-url.sh "$env_name")"
export CYPRESS_BASE_URL
echo "Running UAT against $CYPRESS_BASE_URL"

args=(--browser "${CYPRESS_BROWSER:-electron}" --expose "tags=@uat,ENV_NAME=$env_name")
if [[ -n "$specs" ]]; then
  args+=(--spec "$specs")
fi

rm -rf cypress/results
exec npx cypress run "${args[@]}"
