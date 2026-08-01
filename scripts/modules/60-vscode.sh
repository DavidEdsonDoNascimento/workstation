#!/usr/bin/env bash

set -Eeuo pipefail

ROOT_DIR="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/../.." &&
  pwd
)"

# shellcheck source=scripts/lib/common.sh
source "$ROOT_DIR/scripts/lib/common.sh"

MICROSOFT_KEYRING="/usr/share/keyrings/microsoft.gpg"
VSCODE_SOURCE="/etc/apt/sources.list.d/vscode.sources"
EXTENSIONS_FILE="$ROOT_DIR/config/vscode/extensions.txt"

install_vscode() {
  if command_exists code; then
    success "Visual Studio Code já está instalado"
    return
  fi

  log "Configurando repositório oficial do Visual Studio Code"

  sudo apt-get install -y \
    wget \
    gpg \
    apt-transport-https

  temporary_key="$(mktemp)"

  wget -qO- \
    https://packages.microsoft.com/keys/microsoft.asc |
    gpg --dearmor >"$temporary_key"

  sudo install \
    -o root \
    -g root \
    -m 0644 \
    "$temporary_key" \
    "$MICROSOFT_KEYRING"

  rm -f "$temporary_key"

  architecture="$(dpkg --print-architecture)"

  sudo tee "$VSCODE_SOURCE" >/dev/null <<EOF
Types: deb
URIs: https://packages.microsoft.com/repos/code
Suites: stable
Components: main
Architectures: $architecture
Signed-By: $MICROSOFT_KEYRING
EOF

  sudo apt-get update
  sudo apt-get install -y code

  success "Visual Studio Code instalado"
}

install_extensions() {
  if [[ ! -f "$EXTENSIONS_FILE" ]]; then
    fail "Lista de extensões não encontrada: $EXTENSIONS_FILE"
  fi

  log "Instalando extensões do Visual Studio Code"

  while IFS= read -r extension || [[ -n "$extension" ]]; do
    extension="$(
      printf '%s' "$extension" |
        sed 's/^[[:space:]]*//;s/[[:space:]]*$//'
    )"

    if [[ -z "$extension" || "$extension" == \#* ]]; then
      continue
    fi

    if code --list-extensions |
      grep -Fxiq "$extension"; then
      success "Extensão já instalada: $extension"
    else
      code --install-extension "$extension" --force
      success "Extensão instalada: $extension"
    fi
  done <"$EXTENSIONS_FILE"
}

main() {
  log "Preparando Visual Studio Code"

  install_vscode
  install_extensions

  success "Visual Studio Code preparado"
}

main "$@"
