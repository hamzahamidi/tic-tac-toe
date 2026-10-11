#!/usr/bin/env bash
set -euo pipefail

env_name="${1:?usage: build.sh <staging|production>}"
root="$(cd "$(dirname "$0")/../.." && pwd)"
out="$root/dist/$env_name"

# BUILD_VERSION wins if set; otherwise the CI build number (BUILD_NUMBER) and
# short commit SHA, so the served page identifies exactly which build it is.
sha="$(git -C "$root" rev-parse --short HEAD 2>/dev/null || echo nosha)"
version="${BUILD_VERSION:-${BUILD_NUMBER:-local}-$sha}"

rm -rf "$out"
mkdir -p "$out"
sed -e "s/__ENV_NAME__/$env_name/g" -e "s/__BUILD_VERSION__/$version/g" \
  "$root/app/index.html" > "$out/index.html"
echo "Built $out/index.html ($env_name, $version)"
