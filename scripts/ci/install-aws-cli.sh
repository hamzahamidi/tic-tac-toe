#!/usr/bin/env bash
# Installs AWS CLI v2 into Debian-based CI images that lack it (e.g. cypress/browsers).
set -euo pipefail

if command -v aws >/dev/null; then
  aws --version
  exit 0
fi

apt-get update
apt-get install -y --no-install-recommends ca-certificates curl unzip

tmp="$(mktemp -d)"
curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-$(uname -m).zip" -o "$tmp/awscliv2.zip"
unzip -q "$tmp/awscliv2.zip" -d "$tmp"
"$tmp/aws/install"
rm -rf "$tmp"
aws --version
