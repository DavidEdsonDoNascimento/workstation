#!/usr/bin/env bash

set -Eeuo pipefail

ROOT_DIR="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/../.." &&
  pwd
)"

# shellcheck source=scripts/lib/common.sh
source "$ROOT_DIR/scripts/lib/common.sh"

TPM_DIR="$HOME/.tmux/plugins/tpm"
TMUX_CONFIG="$HOME/.config/tmux/tmux.conf"

if [[ ! -x "$TPM_DIR/bin/install_plugins" ]]; then
  fail "O instalador do TPM não foi encontrado."
fi

if [[ ! -f "$TMUX_CONFIG" ]]; then
  fail "A configuração do Tmux não foi encontrada em $TMUX_CONFIG."
fi

log "Instalando plugins do Tmux"

"$TPM_DIR/bin/install_plugins"

success "Plugins do Tmux instalados"
