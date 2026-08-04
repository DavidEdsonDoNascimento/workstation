#!/usr/bin/env bash

set -Eeuo pipefail

FNM_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/fnm"

if [[ -x "$FNM_DIR/fnm" ]]; then
  export PATH="$FNM_DIR:$PATH"
  eval "$("$FNM_DIR/fnm" env --shell bash)"
fi

export PATH="$HOME/.local/bin:$PATH"

tools=(
  git
  curl
  wget
  jq
  tree
  fzf
  rg
  fd
  bat
  eza
  tmux
  fish
  stow
  starship
  zoxide
  fc-list
  xsel
  wl-copy
  nvim
  tree-sitter
  fnm
  node
  npm
  corepack
  pnpm
  docker
  code
  claude
  python3
  pip3
  pipx
  uv
  uvx
  dbeaver
)

failed=0

printf "\nVerificando a workstation:\n\n"

for tool in "${tools[@]}"; do
  if command -v "$tool" >/dev/null 2>&1; then
    printf "\033[1;32m✓\033[0m %-14s %s\n" \
      "$tool" \
      "$(command -v "$tool")"
  else
    printf "\033[1;31m✗\033[0m %-14s não encontrado\n" "$tool"
    failed=1
  fi
done

font_family="$(
  fc-match -f '%{family}\n' "JetBrainsMono Nerd Font" 2>/dev/null ||
    true
)"

if [[ "$font_family" == *"JetBrainsMono Nerd Font"* ]]; then
  printf "\033[1;32m✓\033[0m %-14s %s\n" \
    "Nerd Font" \
    "$font_family"
else
  printf "\033[1;31m✗\033[0m %-14s não encontrada\n" \
    "Nerd Font"
  failed=1
fi

check_path() {
  local path="$1"
  local name="$2"

  if [[ -e "$path" || -L "$path" ]]; then
    printf "\033[1;32m✓\033[0m %-14s %s\n" "$name" "$path"
  else
    printf "\033[1;31m✗\033[0m %-14s não encontrado\n" "$name"
    failed=1
  fi
}

TMUX_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/tmux"
TMUX_PLUGIN_DIR="$TMUX_CONFIG_DIR/plugins"
TPM_DIR="$HOME/.tmux/plugins/tpm"

check_path "$TMUX_CONFIG_DIR/tmux.conf" "tmux.conf"
check_path "$TPM_DIR" "TPM"
check_path "$TMUX_PLUGIN_DIR/tmux-sensible" "sensible"
check_path "$TMUX_PLUGIN_DIR/tmux-yank" "tmux-yank"
check_path "$TMUX_PLUGIN_DIR/tmux-resurrect" "resurrect"
check_path "$TMUX_PLUGIN_DIR/tmux-continuum" "continuum"

check_path "$HOME/.config/nvim/init.lua" "LazyVim config"
check_path "$HOME/.local/share/nvim/lazy/lazy.nvim" "lazy.nvim"
check_path "$HOME/.config/nvim/lazy-lock.json" "lazy-lock"
check_path "$HOME/.config/nvim/lazyvim.json" "LazyVim extras"
check_path \
  "$HOME/.config/Code/User/settings.json" \
  "VS Code config"
check_path "$HOME/.local/bin/claude" "Claude launcher"

check_path "$HOME/.gitconfig" "gitconfig"
check_path "$HOME/.gitconfig.local" "Git pessoal"
check_path "$HOME/.gitconfig.altaa" "Git Altaa"

if command -v node >/dev/null 2>&1; then
  node_major="$(node -p 'process.versions.node.split(".")[0]')"

  if [[ "$node_major" == "24" ]]; then
    printf "\033[1;32m✓\033[0m %-14s %s\n" \
      "Node LTS" \
      "$(node --version)"
  else
    printf "\033[1;31m✗\033[0m %-14s versão encontrada: %s\n" \
      "Node LTS" \
      "$(node --version)"
    failed=1
  fi
fi

if command -v pnpm >/dev/null 2>&1; then
  pnpm_major="$(pnpm --version | cut -d. -f1)"

  if [[ "$pnpm_major" == "11" ]]; then
    printf "\033[1;32m✓\033[0m %-14s %s\n" \
      "pnpm major" \
      "$(pnpm --version)"
  else
    printf "\033[1;31m✗\033[0m %-14s versão encontrada: %s\n" \
      "pnpm major" \
      "$(pnpm --version)"
    failed=1
  fi
fi

if systemctl is-active --quiet docker; then
  printf "\033[1;32m✓\033[0m %-14s %s\n" \
    "Docker service" \
    "active"
else
  printf "\033[1;31m✗\033[0m %-14s %s\n" \
    "Docker service" \
    "inactive"
  failed=1
fi

if docker compose version >/dev/null 2>&1; then
  printf "\033[1;32m✓\033[0m %-14s %s\n" \
    "Docker Compose" \
    "$(docker compose version --short)"
else
  printf "\033[1;31m✗\033[0m %-14s %s\n" \
    "Docker Compose" \
    "não encontrado"
  failed=1
fi

if docker buildx version >/dev/null 2>&1; then
  printf "\033[1;32m✓\033[0m %-14s %s\n" \
    "Docker Buildx" \
    "$(docker buildx version | head -n 1)"
else
  printf "\033[1;31m✗\033[0m %-14s %s\n" \
    "Docker Buildx" \
    "não encontrado"
  failed=1
fi

if id -nG |
  tr ' ' '\n' |
  grep -Fxq docker; then
  printf "\033[1;32m✓\033[0m %-14s %s\n" \
    "Docker group" \
    "sessão atual configurada"
else
  printf "\033[1;31m✗\033[0m %-14s %s\n" \
    "Docker group" \
    "saia e entre novamente na sessão"
  failed=1
fi

if command -v claude >/dev/null 2>&1; then
  claude_path="$(command -v claude)"
  claude_version="$(claude --version 2>/dev/null || true)"

  if [[ "$claude_path" == "$HOME/.local/bin/claude" ]]; then
    printf "\033[1;32m✓\033[0m %-14s %s\n" \
      "Claude native" \
      "$claude_version"
  else
    printf "\033[1;31m✗\033[0m %-14s caminho inesperado: %s\n" \
      "Claude native" \
      "$claude_path"
    failed=1
  fi
fi

git_name="$(
  git config --global --includes --get user.name ||
    true
)"

git_email="$(
  git config --global --includes --get user.email ||
    true
)"

altaa_git_email="$(
  git config \
    --file "$HOME/.gitconfig.altaa" \
    --get user.email 2>/dev/null ||
    true
)"

if [[ "$altaa_git_email" == "dev3@altaa.com.br" ]]; then
  printf "\033[1;32m✓\033[0m %-14s %s\n" \
    "Git Altaa" \
    "$altaa_git_email"
else
  printf "\033[1;31m✗\033[0m %-14s %s\n" \
    "Git Altaa" \
    "e-mail não configurado corretamente"
  failed=1
fi

if [[ -n "$git_name" ]]; then
  printf "\033[1;32m✓\033[0m %-14s %s\n" \
    "Git name" \
    "$git_name"
else
  printf "\033[1;31m✗\033[0m %-14s não configurado\n" \
    "Git name"
  failed=1
fi

if [[ -n "$git_email" ]]; then
  printf "\033[1;32m✓\033[0m %-14s %s\n" \
    "Git email" \
    "$git_email"
else
  printf "\033[1;31m✗\033[0m %-14s não configurado\n" \
    "Git email"
  failed=1
fi

if gh auth status >/dev/null 2>&1; then
  printf "\033[1;32m✓\033[0m %-14s %s\n" \
    "GitHub auth" \
    "autenticado"
else
  printf "\033[1;31m✗\033[0m %-14s %s\n" \
    "GitHub auth" \
    "execute gh auth login"
  failed=1
fi

if python3 -c "import venv" >/dev/null 2>&1; then
  printf "\033[1;32m✓\033[0m %-14s %s\n" \
    "Python venv" \
    "disponível"
else
  printf "\033[1;31m✗\033[0m %-14s %s\n" \
    "Python venv" \
    "não disponível"
  failed=1
fi

if command -v uv >/dev/null 2>&1; then
  uv_python="$(uv python find 2>/dev/null || true)"

  if [[ -n "$uv_python" ]]; then
    printf "\033[1;32m✓\033[0m %-14s %s\n" \
      "uv Python" \
      "$uv_python"
  else
    printf "\033[1;31m✗\033[0m %-14s %s\n" \
      "uv Python" \
      "interpretador não encontrado"
    failed=1
  fi
fi

printf "\n"

if [[ "$failed" -eq 0 ]]; then
  printf "\033[1;32mTodas as verificações passaram.\033[0m\n"
else
  printf "\033[1;33mAlgumas ferramentas não foram encontradas.\033[0m\n"
fi

exit "$failed"
