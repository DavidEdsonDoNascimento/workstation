#!/usr/bin/env bash

set -Eeuo pipefail

ROOT_DIR="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/../.." &&
  pwd
)"

# shellcheck source=scripts/lib/common.sh
source "$ROOT_DIR/scripts/lib/common.sh"

CLAUDE_INSTALLER_URL="https://claude.ai/install.sh"
CLAUDE_BIN="$HOME/.local/bin/claude"

remove_legacy_npm_install() {
  if ! command_exists npm; then
    return
  fi

  if npm list \
    --global \
    --depth=0 \
    @anthropic-ai/claude-code \
    >/dev/null 2>&1; then

    log "Removendo instalação antiga do Claude Code via npm"

    npm uninstall \
      --global \
      @anthropic-ai/claude-code

    success "Instalação npm antiga removida"
  fi
}

install_claude_code() {
  local temporary_installer=""

  temporary_installer="$(mktemp)"

  cleanup() {
    rm -f "$temporary_installer"
  }

  trap cleanup RETURN

  log "Baixando instalador oficial do Claude Code"

  curl \
    --fail \
    --silent \
    --show-error \
    --location \
    "$CLAUDE_INSTALLER_URL" \
    --output "$temporary_installer"

  log "Instalando Claude Code no canal stable"

  bash "$temporary_installer" stable

  if [[ ! -x "$CLAUDE_BIN" ]]; then
    fail "Claude Code não foi encontrado em $CLAUDE_BIN"
  fi

  success "Claude Code instalado: $("$CLAUDE_BIN" --version)"
}

main() {
  log "Preparando Claude Code"

  sudo apt-get install -y \
    curl \
    ripgrep

  mkdir -p "$HOME/.local/bin"

  remove_legacy_npm_install
  install_claude_code

  success "Claude Code preparado"
}

main "$@"
