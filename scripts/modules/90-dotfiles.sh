#!/usr/bin/env bash

set -Eeuo pipefail

ROOT_DIR="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/../.." &&
  pwd
)"

# shellcheck source=scripts/lib/common.sh
source "$ROOT_DIR/scripts/lib/common.sh"

BACKUP_TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR="$HOME/.local/state/workstation/backups/$BACKUP_TIMESTAMP"

backup_target() {
  local target="$1"
  local resolved=""
  local relative=""
  local backup=""

  if [[ ! -e "$target" && ! -L "$target" ]]; then
    return
  fi

  resolved="$(readlink -f "$target" 2>/dev/null || true)"

  if [[ "$resolved" == "$ROOT_DIR"* ]]; then
    return
  fi

  relative="${target#"$HOME"/}"
  backup="$BACKUP_DIR/$relative"

  mkdir -p "$(dirname "$backup")"
  mv "$target" "$backup"

  warning "Backup criado: $backup"
}

log "Preparando configurações pessoais"

backup_target "$HOME/.config/fish"
backup_target "$HOME/.config/starship.toml"

mkdir -p "$HOME/.config"

log "Criando links simbólicos com GNU Stow"

stow \
  --dir="$ROOT_DIR/dotfiles" \
  --target="$HOME" \
  --restow \
  fish \
  starship

success "Dotfiles aplicados"
