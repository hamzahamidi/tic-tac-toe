#!/usr/bin/env bash
set -euo pipefail

env_name="${1:?usage: site-url.sh <staging|production>}"
aws cloudformation describe-stacks \
  --stack-name "TicTacToe-$env_name" \
  --query "Stacks[0].Outputs[?OutputKey=='SiteUrl'].OutputValue" \
  --output text
