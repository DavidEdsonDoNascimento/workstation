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

readonly BRUNO_KEYRING="/etc/apt/keyrings/bruno.gpg"
readonly BRUNO_REPOSITORY="/etc/apt/sources.list.d/bruno.list"
readonly BRUNO_KEY_URL="https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x9FA6017ECABE0266"
readonly BRUNO_REPOSITORY_URL="http://debian.usebruno.com/"

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

    echo \
      "deb [signed-by=${DBEAVER_KEYRING}] https://dbeaver.io/debs/dbeaver-ce /" |
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

install_bruno() {
  if command_exists bruno; then
    success "Bruno já está instalado"
    return
  fi

  log "Instalando dependências necessárias para o Bruno"

  sudo apt-get update
  sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg

  sudo mkdir -p /etc/apt/keyrings

  if [[ ! -f "$BRUNO_KEYRING" ]]; then
    log "Adicionando chave do repositório do Bruno"

    curl \
      --fail \
      --silent \
      --show-error \
      --location \
      "$BRUNO_KEY_URL" |
      gpg --dearmor |
      sudo tee "$BRUNO_KEYRING" >/dev/null

    sudo chmod 0644 "$BRUNO_KEYRING"
  else
    success "Chave do repositório do Bruno já configurada"
  fi

  if [[ ! -f "$BRUNO_REPOSITORY" ]]; then
    log "Adicionando repositório oficial do Bruno"

    echo \
      "deb [arch=amd64 signed-by=${BRUNO_KEYRING}] ${BRUNO_REPOSITORY_URL} bruno stable" |
      sudo tee "$BRUNO_REPOSITORY" >/dev/null
  else
    success "Repositório do Bruno já configurado"
  fi

  log "Instalando Bruno API Client"

  sudo apt-get update
  sudo apt-get install -y bruno

  command_exists bruno ||
    fail "Bruno não foi encontrado após a instalação"

  success "Bruno instalado com sucesso"
}

main() {
  log "Configurando aplicações gráficas"

  install_dbeaver
  install_bruno

  success "Aplicações gráficas configuradas"
}

main "$@"
