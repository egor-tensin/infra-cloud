#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail

if [ -z "${ANSIBLE_VAULT_PASSWORD+x}" ]; then
    echo '$ANSIBLE_VAULT_PASSWORD is not defined' >&2
    exit 1
fi

echo "$ANSIBLE_VAULT_PASSWORD"
