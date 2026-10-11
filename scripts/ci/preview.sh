#!/usr/bin/env bash
set -euo pipefail

env_name="${1:?usage: preview.sh <staging|production>}"
npx cdk diff "TicTacToe-$env_name"
