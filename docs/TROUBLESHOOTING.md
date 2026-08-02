# Solução de problemas

## Docker retorna `permission denied`

Erro:

```text
permission denied while trying to connect to the docker API
```

Confirme o grupo:

```bash
getent group docker
id -nG
```

Caso necessário:

```bash
sudo usermod -aG docker "$USER"
```

Depois encerre a sessão do Ubuntu e entre novamente.

Como alternativa temporária:

```bash
newgrp docker
```

Teste:

```bash
docker run --rm hello-world
```

Não use:

```bash
sudo chmod 666 /var/run/docker.sock
```

## O Git não encontra nome ou e-mail

Confira:

```bash
git config --global --includes --get user.name
git config --global --includes --get user.email
```

Verifique os arquivos:

```bash
ls -la ~/.gitconfig
ls -la ~/.gitconfig.local
```

O arquivo `~/.gitconfig` deve apontar para o repositório, enquanto `~/.gitconfig.local` contém a identidade da máquina.

Aplique novamente o dotfile:

```bash
cd ~/workstation

stow \
  --dir="$HOME/workstation/dotfiles" \
  --target="$HOME" \
  --restow \
  git
```

## O Fish rejeita `eval "$(ssh-agent -s)"`

Esse comando usa sintaxe de Bash.

No Fish, use:

```fish
ssh-agent -c | source
ssh-add ~/.ssh/id_ed25519
```

Confirme:

```fish
echo $SSH_AUTH_SOCK
echo $SSH_AGENT_PID
```

## O GitHub CLI abre uma página pedindo código

Execute o login com cópia automática:

```bash
gh auth login \
  --hostname github.com \
  --git-protocol ssh \
  --web \
  --skip-ssh-key \
  --clipboard
```

Cole o código na página aberta pelo navegador.

Depois:

```bash
gh auth status
```

## O LazyVim mostra `nvim-lspconfig` como `not loaded`

Abra primeiro um arquivo compatível dentro de um projeto.

Exemplo:

```bash
cd ~/projeto-typescript
nvim src/index.ts
```

Depois verifique:

```vim
:checkhealth vim.lsp
```

O carregamento do plugin é feito sob demanda.

## O comando `:LspInfo` não existe

Use:

```vim
:checkhealth vim.lsp
```

Também é possível conferir os clientes ativos:

```vim
:lua vim.print(vim.lsp.get_clients({ bufnr = 0 }))
```

## Um item aparece ausente no diagnóstico

Execute novamente:

```bash
cd ~/workstation
./install.sh
./scripts/doctor.sh
```

Caso continue ausente, execute diretamente o módulo responsável dentro de:

```text
scripts/modules/
```

## Conflito ao aplicar dotfiles

As configurações anteriores normalmente são movidas para:

```text
~/.local/state/workstation/backups/
```

Liste os backups:

```bash
find ~/.local/state/workstation/backups -maxdepth 4 -type f
```

Não apague os backups até confirmar que as novas configurações estão funcionando.

## Starship ou ícones aparecem quebrados

Selecione no terminal:

```text
JetBrainsMono Nerd Font Mono
```

Depois feche completamente o terminal e abra novamente.

Confirme a fonte:

```bash
fc-match "JetBrainsMono Nerd Font"
```

## `claude` não é encontrado

Confira:

```bash
type -a claude
ls -la ~/.local/bin/claude
```

Execute novamente:

```bash
cd ~/workstation
bash scripts/modules/70-claude-code.sh
```

Depois:

```bash
exec fish
claude --version
```
