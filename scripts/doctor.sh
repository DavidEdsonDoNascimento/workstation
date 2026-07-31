#!/usr/bin/env bash

set -Eeuo pipefail
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
  tmux
  fish
  stow
  starship
  zoxide
)

failed=0

printf "\nVerificando a workstation:\n\n"

for tool in "${tools[@]}"; do
  if command -v "$tool" >/dev/null 2>&1; then
    printf "\033[1;32m✓\033[0m %-12s %s\n" \
      "$tool" \
      "$(command -v "$tool")"
  else
    printf "\033[1;31m✗\033[0m %-12s não encontrado\n" "$tool"
    failed=1
  fi
done

printf "\n"

if [[ "$failed" -eq 0 ]]; then
  printf "\033[1;32mTodas as verificações passaram.\033[0m\n"
else
  printf "\033[1;33mAlgumas ferramentas não foram encontradas.\033[0m\n"
fi

exit "$failed"
