#!/usr/bin/env bash

set -Eeuo pipefail

ROOT_DIR="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/../.." &&
  pwd
)"

# shellcheck source=scripts/lib/common.sh
source "$ROOT_DIR/scripts/lib/common.sh"

NODE_VERSION="24"
PNPM_VERSION="latest-11"
FNM_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/fnm"

install_fnm() {
  if [[ -x "$FNM_DIR/fnm" ]]; then
    success "fnm já está instalado"
    return
  fi

  log "Instalando fnm"

  curl -fsSL https://fnm.vercel.app/install |
    bash -s -- \
      --install-dir "$FNM_DIR" \
      --skip-shell

  success "fnm instalado"
}

configure_fnm() {
  export PATH="$FNM_DIR:$PATH"

  if [[ ! -x "$FNM_DIR/fnm" ]]; then
    fail "O executável do fnm não foi encontrado."
  fi

  eval "$("$FNM_DIR/fnm" env --shell bash)"
}

install_node() {
  log "Instalando Node.js $NODE_VERSION LTS"

  fnm install "$NODE_VERSION"
  fnm default "$NODE_VERSION"
  fnm use "$NODE_VERSION"

  success "Node.js $(node --version) configurado"
}

install_pnpm() {
  log "Instalando Corepack e pnpm"

  npm install --global corepack@latest

  corepack enable
  corepack prepare "pnpm@$PNPM_VERSION" --activate

  success "pnpm $(pnpm --version) configurado"
}

main() {
  log "Preparando ambiente Node.js"

  sudo apt-get install -y \
    curl \
    unzip

  install_fnm
  configure_fnm
  install_node
  install_pnpm

  success "Ambiente Node.js preparado"
}

main "$@"
