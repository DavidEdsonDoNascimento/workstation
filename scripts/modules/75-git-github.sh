#!/usr/bin/env bash

set -Eeuo pipefail

ROOT_DIR="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/../.." &&
    pwd
)"

# shellcheck source=scripts/lib/common.sh
source "$ROOT_DIR/scripts/lib/common.sh"

GITHUB_KEYRING="/etc/apt/keyrings/githubcli-archive-keyring.gpg"
GITHUB_SOURCE="/etc/apt/sources.list.d/github-cli.list"
GIT_LOCAL_CONFIG="$HOME/.gitconfig.local"

install_github_cli() {
  if command_exists gh; then
    success "GitHub CLI já está instalado"
    return
  fi

  log "Configurando repositório oficial do GitHub CLI"

  sudo apt-get install -y wget ca-certificates

  sudo mkdir -p -m 0755 /etc/apt/keyrings
  sudo mkdir -p -m 0755 /etc/apt/sources.list.d

  temporary_key="$(mktemp)"

  cleanup() {
    rm -f "$temporary_key"
  }

  trap cleanup RETURN

  wget \
    --quiet \
    --output-document="$temporary_key" \
    https://cli.github.com/packages/githubcli-archive-keyring.gpg

  sudo install \
    -o root \
    -g root \
    -m 0644 \
    "$temporary_key" \
    "$GITHUB_KEYRING"

  printf '%s\n' \
    "deb [arch=$(dpkg --print-architecture) signed-by=$GITHUB_KEYRING] https://cli.github.com/packages stable main" |
    sudo tee "$GITHUB_SOURCE" >/dev/null

  sudo apt-get update
  sudo apt-get install -y gh

  success "GitHub CLI instalado"
}

configure_git_identity() {
  local current_name=""
  local current_email=""
  local git_name=""
  local git_email=""

  if [[ -f "$GIT_LOCAL_CONFIG" ]]; then
    success "Identidade local do Git já está configurada"
    return
  fi

  current_name="$(
    git config --global --includes --get user.name ||
      true
  )"

  current_email="$(
    git config --global --includes --get user.email ||
      true
  )"

  if [[ -n "$current_name" && -n "$current_email" ]]; then
    git_name="$current_name"
    git_email="$current_email"
  elif [[ -t 0 ]]; then
    printf "Nome usado nos commits: "
    read -r git_name

    printf "E-mail usado nos commits: "
    read -r git_email
  else
    warning "Não foi possível configurar a identidade do Git automaticamente."
    warning "Crie posteriormente o arquivo $GIT_LOCAL_CONFIG."
    return
  fi

  if [[ -z "$git_name" || -z "$git_email" ]]; then
    fail "Nome e e-mail do Git são obrigatórios."
  fi

  cat >"$GIT_LOCAL_CONFIG" <<EOF
[user]
    name = $git_name
    email = $git_email
EOF

  chmod 0600 "$GIT_LOCAL_CONFIG"

  success "Identidade do Git salva em $GIT_LOCAL_CONFIG"
}

main() {
  log "Preparando Git e GitHub CLI"

  install_github_cli
  configure_git_identity

  success "Git e GitHub CLI preparados"
}

main "$@"
