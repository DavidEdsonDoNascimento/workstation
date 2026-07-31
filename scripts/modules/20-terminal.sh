#!/usr/bin/env bash

set -Eeuo pipefail

ROOT_DIR="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/../.." &&
  pwd
)"

# shellcheck source=scripts/lib/common.sh
source "$ROOT_DIR/scripts/lib/common.sh"

log "Instalando ferramentas do terminal"

sudo apt-get install -y starship

mkdir -p "$HOME/.local/bin"

if ! command_exists zoxide && [[ ! -x "$HOME/.local/bin/zoxide" ]]; then
  log "Instalando zoxide"

  curl -sSfL \
    https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh |
    sh
else
  success "zoxide já está instalado"
fi

if command_exists fdfind; then
  ln -sfn "$(command -v fdfind)" "$HOME/.local/bin/fd"
  success "Comando fd configurado"
fi

if command_exists batcat; then
  ln -sfn "$(command -v batcat)" "$HOME/.local/bin/bat"
  success "Comando bat configurado"
fi

success "Ferramentas do terminal instaladas"
