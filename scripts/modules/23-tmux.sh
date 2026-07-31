#!/usr/bin/env bash

set -Eeuo pipefail

ROOT_DIR="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/../.." &&
  pwd
)"

# shellcheck source=scripts/lib/common.sh
source "$ROOT_DIR/scripts/lib/common.sh"

TPM_DIR="$HOME/.tmux/plugins/tpm"

log "Instalando Tmux e integração com o clipboard"

sudo apt-get install -y \
  tmux \
  xsel \
  wl-clipboard

if [[ -d "$TPM_DIR/.git" ]]; then
  success "TPM já está instalado"
elif [[ -e "$TPM_DIR" ]]; then
  fail "O caminho $TPM_DIR já existe, mas não contém uma instalação válida do TPM."
else
  log "Instalando Tmux Plugin Manager"

  mkdir -p "$(dirname "$TPM_DIR")"

  git clone \
    --depth 1 \
    https://github.com/tmux-plugins/tpm \
    "$TPM_DIR"

  success "TPM instalado"
fi

success "Tmux preparado"
