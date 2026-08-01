#!/usr/bin/env bash

set -Eeuo pipefail

ROOT_DIR="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/../.." &&
  pwd
)"

# shellcheck source=scripts/lib/common.sh
source "$ROOT_DIR/scripts/lib/common.sh"

DOCKER_KEYRING="/etc/apt/keyrings/docker.asc"
DOCKER_SOURCE="/etc/apt/sources.list.d/docker.sources"

remove_conflicting_packages() {
  local packages=(
    docker.io
    docker-compose
    docker-compose-v2
    docker-doc
    docker-buildx
    podman-docker
    containerd
    runc
  )

  local installed=()
  local package=""

  # Não remova dependências se o Docker oficial já estiver instalado.
  if dpkg-query -W -f='${Status}' docker-ce 2>/dev/null |
    grep -Fq "install ok installed"; then
    success "Docker CE oficial já está instalado"
    return
  fi

  for package in "${packages[@]}"; do
    if dpkg-query -W -f='${Status}' "$package" 2>/dev/null |
      grep -Fq "install ok installed"; then
      installed+=("$package")
    fi
  done

  if [[ "${#installed[@]}" -gt 0 ]]; then
    log "Removendo pacotes conflitantes"

    sudo apt-get remove -y "${installed[@]}"
  else
    success "Nenhum pacote conflitante encontrado"
  fi
}

configure_repository() {
  local architecture=""
  local codename=""

  architecture="$(dpkg --print-architecture)"

  # shellcheck disable=SC1091
  source /etc/os-release

  codename="${UBUNTU_CODENAME:-${VERSION_CODENAME:-}}"

  if [[ -z "$codename" ]]; then
    fail "Não foi possível identificar o codename do Ubuntu."
  fi

  log "Configurando repositório oficial do Docker"

  sudo apt-get update
  sudo apt-get install -y ca-certificates curl

  sudo install -m 0755 -d /etc/apt/keyrings

  sudo curl \
    --fail \
    --silent \
    --show-error \
    --location \
    https://download.docker.com/linux/ubuntu/gpg \
    --output "$DOCKER_KEYRING"

  sudo chmod a+r "$DOCKER_KEYRING"

  sudo tee "$DOCKER_SOURCE" >/dev/null <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $codename
Components: stable
Architectures: $architecture
Signed-By: $DOCKER_KEYRING
EOF

  sudo apt-get update

  success "Repositório oficial do Docker configurado"
}

install_docker() {
  log "Instalando Docker Engine, Compose e Buildx"

  sudo apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

  sudo systemctl enable --now docker

  success "Docker instalado"
}

configure_user() {
  if ! getent group docker >/dev/null 2>&1; then
    sudo groupadd docker
  fi

  if id -nG "$USER" |
    tr ' ' '\n' |
    grep -Fxq docker; then
    success "Usuário $USER já pertence ao grupo docker"
  else
    sudo usermod -aG docker "$USER"

    warning "Usuário adicionado ao grupo docker."
    warning "Será necessário sair e entrar novamente na sessão."
  fi
}

main() {
  log "Preparando Docker"

  remove_conflicting_packages
  configure_repository
  install_docker
  configure_user

  success "Docker preparado"
}

main "$@"

