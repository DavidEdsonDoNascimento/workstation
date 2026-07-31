#!/usr/bin/env bash

set -Eeuo pipefail

ROOT_DIR="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/../.." &&
  pwd
)"

# shellcheck source=scripts/lib/common.sh
source "$ROOT_DIR/scripts/lib/common.sh"

NVIM_CONFIG="$HOME/.config/nvim"
NVIM_LOCKFILE="$NVIM_CONFIG/lazy-lock.json"

if ! command_exists nvim; then
  fail "Neovim não foi encontrado."
fi

if [[ ! -f "$NVIM_CONFIG/init.lua" ]]; then
  fail "Configuração do LazyVim não encontrada."
fi

if [[ -f "$NVIM_LOCKFILE" ]]; then
  log "Restaurando plugins conforme o lazy-lock.json"

  nvim --headless "+Lazy! restore" +qa
else
  log "Instalando plugins do LazyVim"

  nvim --headless "+Lazy! sync" +qa
fi

success "Plugins do LazyVim preparados"
