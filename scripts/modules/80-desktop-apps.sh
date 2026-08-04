#!/usr/bin/env bash

set -Eeuo pipefail

ROOT_DIR="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/../.." &&
    pwd
)"

# shellcheck source=scripts/lib/common.sh
source "$ROOT_DIR/scripts/lib/common.sh"

readonly DBEAVER_KEYRING="/usr/share/keyrings/dbeaver.gpg.key"
readonly DBEAVER_REPOSITORY="/etc/apt/sources.list.d/dbeaver.list"

install_dbeaver() {
  if command_exists dbeaver; then
    success "DBeaver já está instalado"
    return
  fi

  log "Instalando dependências necessárias para o DBeaver"

  sudo apt-get update
  sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg

  if [[ ! -f "$DBEAVER_KEYRING" ]]; then
    log "Adicionando chave do repositório do DBeaver"

    curl -fsSL https://dbeaver.io/debs/dbeaver.gpg.key |
      sudo gpg --dearmor -o "$DBEAVER_KEYRING"
  else
    success "Chave do repositório do DBeaver já configurada"
  fi

  if [[ ! -f "$DBEAVER_REPOSITORY" ]]; then
    log "Adicionando repositório oficial do DBeaver"

    echo "deb [signed-by=${DBEAVER_KEYRING}] https://dbeaver.io/debs/dbeaver-ce /" |
      sudo tee "$DBEAVER_REPOSITORY" >/dev/null
  else
    success "Repositório do DBeaver já configurado"
  fi

  log "Instalando DBeaver Community"

  sudo apt-get update
  sudo apt-get install -y dbeaver-ce

  command_exists dbeaver ||
    fail "DBeaver não foi encontrado após a instalação"

  success "DBeaver instalado com sucesso"
}

main() {
  log "Configurando aplicações gráficas"

  install_dbeaver
}

main "$@"
