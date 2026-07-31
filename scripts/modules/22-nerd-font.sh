#!/usr/bin/env bash

set -Eeuo pipefail

ROOT_DIR="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/../.." &&
  pwd
)"

# shellcheck source=scripts/lib/common.sh
source "$ROOT_DIR/scripts/lib/common.sh"

FONT_NAME="JetBrainsMono Nerd Font"
FONT_DIR="$HOME/.local/share/fonts/JetBrainsMonoNerdFont"
FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz"

log "Preparando a fonte $FONT_NAME"

sudo apt-get install -y fontconfig xz-utils

current_font="$(
  fc-match -f '%{family}\n' "$FONT_NAME" 2>/dev/null ||
  true
)"

if [[ "$current_font" == *"JetBrainsMono Nerd Font"* ]]; then
  success "$FONT_NAME já está instalada"
  exit 0
fi

temporary_dir="$(mktemp -d)"

cleanup() {
  rm -rf "$temporary_dir"
}

trap cleanup EXIT

log "Baixando $FONT_NAME"

curl \
  --fail \
  --location \
  --show-error \
  --silent \
  "$FONT_URL" \
  --output "$temporary_dir/JetBrainsMono.tar.xz"

mkdir -p "$FONT_DIR"

tar \
  --extract \
  --xz \
  --file="$temporary_dir/JetBrainsMono.tar.xz" \
  --directory="$FONT_DIR"

fc-cache -f "$FONT_DIR"

success "$FONT_NAME instalada"
