#!/usr/bin/env nix-shell
#! nix-shell -i bash --packages bash jq

set -euo pipefail

FLAKE="${1}"

nix path-info --json --derivation "${FLAKE}.config.system.build.toplevel" | jq '{ "path": .[0].path }'
