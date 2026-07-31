#!/usr/bin/env bash

set -Eeuo pipefail

ROOT_DIR="$(
  cd "$(dirname "${BASH_SOURCE[0]}")" &&
  pwd
)"

# shellcheck source=scripts/lib/common.sh
source "$ROOT_DIR/scripts/lib/common.sh"

main() {
  require_ubuntu

  log "Iniciando configuração da workstation"

  for module in "$ROOT_DIR"/scripts/modules/*.sh; do
    [[ -f "$module" ]] || continue

    module_name="$(basename "$module")"

    log "Executando módulo: $module_name"
    bash "$module"
  done

  success "Configuração da workstation concluída."
}

main "$@"
