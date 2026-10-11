#!/usr/bin/env bash
set -euo pipefail

env_name="${1:?usage: deploy.sh <staging|production>}"
npx cdk deploy "TicTacToe-$env_name" --require-approval never
