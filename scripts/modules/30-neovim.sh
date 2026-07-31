#!/usr/bin/env bash

set -Eeuo pipefail

ROOT_DIR="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/../.." &&
  pwd
)"

# shellcheck source=scripts/lib/common.sh
source "$ROOT_DIR/scripts/lib/common.sh"

NEOVIM_VERSION="v0.12.4"
TREE_SITTER_VERSION="v0.26.11"

LOCAL_BIN="$HOME/.local/bin"
NEOVIM_ROOT="$HOME/.local/opt/neovim"
NEOVIM_DIR="$NEOVIM_ROOT/$NEOVIM_VERSION"

case "$(uname -m)" in
  x86_64 | amd64)
    NVIM_ARCHIVE="nvim-linux-x86_64.tar.gz"
    NVIM_SHA256="012bf3fcac5ade43914df3f174668bf64d05e049a4f032a388c027b1ebd78628"

    TREE_SITTER_ARCHIVE="tree-sitter-cli-linux-x64.zip"
    TREE_SITTER_SHA256="ff1b7f9863f2faafd78dc0e66d902ee85b37f709b314b22c009f51caf233eebd"
    ;;

  aarch64 | arm64)
    NVIM_ARCHIVE="nvim-linux-arm64.tar.gz"
    NVIM_SHA256="ceb7e88c6b681f0515d135dcdfad54f5eb4373b25ce6172197cd9a69c758063f"

    TREE_SITTER_ARCHIVE="tree-sitter-cli-linux-arm64.zip"
    TREE_SITTER_SHA256="db28509fe6db8902f9d14c43c486858c7486b42c3a96b30e811e73f105762336"
    ;;

  *)
    fail "Arquitetura não suportada: $(uname -m)"
    ;;
esac

NVIM_URL="https://github.com/neovim/neovim/releases/download/$NEOVIM_VERSION/$NVIM_ARCHIVE"
TREE_SITTER_URL="https://github.com/tree-sitter/tree-sitter/releases/download/$TREE_SITTER_VERSION/$TREE_SITTER_ARCHIVE"

TEMP_DIR="$(mktemp -d)"

cleanup() {
  rm -rf "$TEMP_DIR"
}

trap cleanup EXIT

verify_checksum() {
  local directory="$1"
  local filename="$2"
  local checksum="$3"

  (
    cd "$directory"
    printf '%s  %s\n' "$checksum" "$filename" |
      sha256sum --check --status
  ) || fail "Checksum inválido para $filename"
}

install_neovim() {
  if [[ -x "$NEOVIM_DIR/bin/nvim" ]] &&
    "$NEOVIM_DIR/bin/nvim" --version |
      grep -Fq "NVIM $NEOVIM_VERSION"; then
    ln -sfn "$NEOVIM_DIR/bin/nvim" "$LOCAL_BIN/nvim"
    success "Neovim $NEOVIM_VERSION já está instalado"
    return
  fi

  log "Baixando Neovim $NEOVIM_VERSION"

  curl \
    --fail \
    --location \
    --show-error \
    --silent \
    "$NVIM_URL" \
    --output "$TEMP_DIR/$NVIM_ARCHIVE"

  verify_checksum \
    "$TEMP_DIR" \
    "$NVIM_ARCHIVE" \
    "$NVIM_SHA256"

  rm -rf "$NEOVIM_DIR"
  mkdir -p "$NEOVIM_DIR"

  tar \
    --extract \
    --gzip \
    --file="$TEMP_DIR/$NVIM_ARCHIVE" \
    --directory="$NEOVIM_DIR" \
    --strip-components=1

  ln -sfn "$NEOVIM_DIR/bin/nvim" "$LOCAL_BIN/nvim"

  success "Neovim $NEOVIM_VERSION instalado"
}

install_tree_sitter() {
  local expected_version="${TREE_SITTER_VERSION#v}"

  if [[ -x "$LOCAL_BIN/tree-sitter" ]] &&
    "$LOCAL_BIN/tree-sitter" --version |
      grep -Fq "$expected_version"; then
    success "Tree-sitter CLI $TREE_SITTER_VERSION já está instalado"
    return
  fi

  log "Baixando Tree-sitter CLI $TREE_SITTER_VERSION"

  curl \
    --fail \
    --location \
    --show-error \
    --silent \
    "$TREE_SITTER_URL" \
    --output "$TEMP_DIR/$TREE_SITTER_ARCHIVE"

  verify_checksum \
    "$TEMP_DIR" \
    "$TREE_SITTER_ARCHIVE" \
    "$TREE_SITTER_SHA256"

  mkdir -p "$TEMP_DIR/tree-sitter"

  unzip -q \
    "$TEMP_DIR/$TREE_SITTER_ARCHIVE" \
    -d "$TEMP_DIR/tree-sitter"

  tree_sitter_binary="$(
    find "$TEMP_DIR/tree-sitter" \
      -type f \
      -name tree-sitter \
      -print \
      -quit
  )"

  if [[ -z "$tree_sitter_binary" ]]; then
    fail "Binário tree-sitter não encontrado no arquivo baixado."
  fi

  install \
    -m 0755 \
    "$tree_sitter_binary" \
    "$LOCAL_BIN/tree-sitter"

  success "Tree-sitter CLI $TREE_SITTER_VERSION instalado"
}

main() {
  log "Instalando Neovim e suas dependências"

  sudo apt-get install -y \
    build-essential \
    unzip

  mkdir -p "$LOCAL_BIN"
  mkdir -p "$NEOVIM_ROOT"

  install_neovim
  install_tree_sitter

  success "Neovim preparado"
}

main "$@"
