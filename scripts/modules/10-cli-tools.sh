#!/usr/bin/env bash

set -Eeuo pipefail

ROOT_DIR="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/../.." &&
  pwd
)"

# shellcheck source=scripts/lib/common.sh
source "$ROOT_DIR/scripts/lib/common.sh"

packages=(
  ca-certificates
  curl
  wget
  git
  build-essential
  unzip
  zip
  jq
  tree
  fzf
  ripgrep
  fd-find
  bat
  tmux
  fish
  stow
  gnupg
  software-properties-common
)

log "Instalando ferramentas essenciais"

sudo apt-get install -y "${packages[@]}"

success "Ferramentas essenciais instaladas"
