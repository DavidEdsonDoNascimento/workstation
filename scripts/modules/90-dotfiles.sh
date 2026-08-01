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

backup_neovim_if_needed() {
  local config="$HOME/.config/nvim"
  local resolved=""

  if [[ -e "$config" || -L "$config" ]]; then
    resolved="$(readlink -f "$config" 2>/dev/null || true)"
  fi

  # Já está gerenciado por este repositório.
  if [[ -n "$resolved" && "$resolved" == "$ROOT_DIR"* ]]; then
    return
  fi

  backup_target "$HOME/.config/nvim"
  backup_target "$HOME/.local/share/nvim"
  backup_target "$HOME/.local/state/nvim"
  backup_target "$HOME/.cache/nvim"
}

log "Preparando configurações pessoais"

backup_target "$HOME/.config/fish"
backup_target "$HOME/.config/starship.toml"
backup_target "$HOME/.config/tmux"
backup_target "$HOME/.tmux.conf"
backup_target "$HOME/.config/Code/User/settings.json"
backup_target "$HOME/.gitconfig"

backup_neovim_if_needed

mkdir -p "$HOME/.config"

log "Criando links simbólicos com GNU Stow"

stow \
  --dir="$ROOT_DIR/dotfiles" \
  --target="$HOME" \
  --restow \
  fish \
  starship \
  tmux \
  nvim \
  vscode \
  git

success "Dotfiles aplicados"
