#!/usr/bin/env nix-shell
#! nix-shell -i bash --packages bash jq

set -euo pipefail

DIRECTORY="$(realpath "${1}")"
RELEASE="${2}"
REGION="${3}"
SYSTEM="${4}"
VIRTUALIZATION_TYPE="${5}"

nix eval --extra-experimental-features 'nix-command flakes' --no-write-lock-file "${DIRECTORY}#\"${RELEASE}\".\"${REGION}\".\"${SYSTEM}\".\"${VIRTUALIZATION_TYPE}\"" | jq '{ "ami": . }'
