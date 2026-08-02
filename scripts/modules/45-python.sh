#!/usr/bin/env bash

set -Eeuo pipefail

ROOT_DIR="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/../.." &&
  pwd
)"

# shellcheck source=scripts/lib/common.sh
source "$ROOT_DIR/scripts/lib/common.sh"

UV_INSTALLER_URL="https://astral.sh/uv/install.sh"
UV_INSTALL_DIR="$HOME/.local/bin"
UV_BIN="$UV_INSTALL_DIR/uv"
UVX_BIN="$UV_INSTALL_DIR/uvx"

install_python() {
  log "Instalando Python e ferramentas essenciais"

  sudo apt-get install -y \
    python3 \
    python3-dev \
    python3-pip \
    python3-venv \
    pipx

  success "Python, pip, venv e pipx instalados"
}

install_uv() {
  if [[ -x "$UV_BIN" && -x "$UVX_BIN" ]]; then
    success "uv já está instalado: $("$UV_BIN" --version)"
    return
  fi

  local temporary_installer=""

  temporary_installer="$(mktemp)"

  cleanup() {
    rm -f "$temporary_installer"
  }

  trap cleanup EXIT

  log "Baixando instalador oficial do uv"

  curl \
    --fail \
    --silent \
    --show-error \
    --location \
    "$UV_INSTALLER_URL" \
    --output "$temporary_installer"

  log "Instalando uv em $UV_INSTALL_DIR"

  mkdir -p "$UV_INSTALL_DIR"

  env \
    UV_INSTALL_DIR="$UV_INSTALL_DIR" \
    UV_NO_MODIFY_PATH=1 \
    sh "$temporary_installer"

  if [[ ! -x "$UV_BIN" ]]; then
    fail "uv não foi encontrado em $UV_BIN"
  fi

  if [[ ! -x "$UVX_BIN" ]]; then
    fail "uvx não foi encontrado em $UVX_BIN"
  fi

  success "uv instalado: $("$UV_BIN" --version)"
}

validate_python() {
  log "Validando ambiente Python"

  python3 --version
  python3 -m pip --version
  python3 -c "import venv"
  pipx --version
  "$UV_BIN" --version
  "$UVX_BIN" --version

  success "Ambiente Python validado"
}

main() {
  log "Preparando ambiente Python"

  install_python
  install_uv
  validate_python

  success "Ambiente Python preparado"
}

main "$@"
