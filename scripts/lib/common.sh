#!/usr/bin/env bash

set -Eeuo pipefail

WORKSTATION_ROOT="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/../.." &&
  pwd
)"

log() {
  printf "\n\033[1;34m==>\033[0m %s\n" "$*"
}

success() {
  printf "\033[1;32m✓\033[0m %s\n" "$*"
}

warning() {
  printf "\033[1;33m!\033[0m %s\n" "$*" >&2
}

error() {
  printf "\033[1;31m✗\033[0m %s\n" "$*" >&2
}

fail() {
  error "$*"
  exit 1
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

require_ubuntu() {
  if [[ ! -f /etc/os-release ]]; then
    fail "Não foi possível identificar a distribuição Linux."
  fi

  # shellcheck disable=SC1091
  source /etc/os-release

  if [[ "${ID:-}" != "ubuntu" ]]; then
    fail "Esta versão do workstation suporta apenas Ubuntu."
  fi

  success "Ubuntu detectado: ${PRETTY_NAME:-Ubuntu}"
}
