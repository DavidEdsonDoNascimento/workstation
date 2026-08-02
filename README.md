# Workstation

Configuração reproduzível do meu ambiente pessoal de desenvolvimento no Ubuntu.

O projeto automatiza a instalação e configuração das ferramentas que utilizo diariamente para desenvolvimento backend, frontend, containers e inteligência artificial.

## Status

**Versão 1.0 concluída.**

O projeto está funcional e entra em modo de manutenção. Novas ferramentas serão adicionadas somente quando houver uma necessidade real.

## Compatibilidade

- Ubuntu
- Desenvolvido e validado no Ubuntu 26.04 LTS
- Shell principal: Fish

O instalador verifica a distribuição antes de executar os módulos.

## O que é instalado

### Terminal

- Fish
- Starship
- JetBrainsMono Nerd Font
- Tmux
- TPM
- tmux-sensible
- tmux-yank
- tmux-resurrect
- tmux-continuum
- eza
- bat
- fd
- fzf
- ripgrep
- zoxide
- tree
- jq

### Git e GitHub

- Git
- GitHub CLI
- configuração global do Git
- identidade separada em `~/.gitconfig.local`
- branch padrão `main`
- Neovim como editor padrão
- autenticação Git por SSH

### Desenvolvimento

- Node.js 24
- npm
- pnpm
- Corepack
- fnm
- Python 3
- pip
- pipx
- uv
- uvx
- ambientes virtuais Python

### Containers

- Docker Engine
- Docker Compose
- Docker Buildx

### Editores

- Neovim
- LazyVim
- Tree-sitter CLI
- extras para TypeScript, JSON, Prisma, Python, Docker, Markdown, Tailwind e YAML
- Visual Studio Code
- extensões de desenvolvimento do VS Code

### Inteligência artificial

- Claude Code
- extensão oficial do Claude Code para VS Code

## Pré-requisitos

Uma instalação nova precisa inicialmente de:

- conexão com a internet;
- usuário com permissão para executar `sudo`;
- Git instalado para clonar o repositório.

Caso o Git ainda não esteja instalado:

```bash
sudo apt update
sudo apt install -y git
```

## Instalação

### Usando HTTPS

Útil quando a máquina ainda não possui chave SSH configurada:

```bash
git clone https://github.com/DavidEdsonDoNascimento/workstation.git
cd workstation
./install.sh
```

### Usando SSH

Caso a chave SSH já esteja configurada:

```bash
git clone git@github.com:DavidEdsonDoNascimento/workstation.git
cd workstation
./install.sh
```

O instalador executa os módulos em ordem numérica e pode ser executado novamente sem precisar recriar o ambiente do zero.

## Ações manuais após a instalação

Algumas ações não são automatizadas porque envolvem autenticação ou configurações gráficas.

### 1. Configurar a chave SSH

Confira se já existe uma chave:

```bash
ls -la ~/.ssh
```

Caso necessário, gere uma:

```bash
ssh-keygen -t ed25519 -C "seu-email"
```

No Fish, inicie o agente com:

```fish
ssh-agent -c | source
ssh-add ~/.ssh/id_ed25519
```

Mostre a chave pública:

```bash
cat ~/.ssh/id_ed25519.pub
```

Cadastre essa chave em:

```text
GitHub → Settings → SSH and GPG keys → New SSH key
```

Teste:

```bash
ssh -T git@github.com
```

### 2. Autenticar o GitHub CLI

```bash
gh auth login \
  --hostname github.com \
  --git-protocol ssh \
  --web \
  --skip-ssh-key \
  --clipboard
```

Confirme:

```bash
gh auth status
```

### 3. Autenticar o Claude Code

```bash
claude
```

Siga o fluxo de autenticação pelo navegador.

Para verificar a instalação:

```bash
claude doctor
```

### 4. Atualizar a permissão do Docker

Depois que o instalador adicionar o usuário ao grupo `docker`, encerre completamente a sessão do Ubuntu e entre novamente.

Também é possível aplicar temporariamente com:

```bash
newgrp docker
```

Teste:

```bash
docker run --rm hello-world
```

### 5. Selecionar a Nerd Font

Nas configurações do aplicativo de terminal, selecione:

```text
JetBrainsMono Nerd Font Mono
```

Feche e abra novamente o terminal.

## Diagnóstico

Depois da instalação e das autenticações manuais, execute:

```bash
./scripts/doctor.sh
```

O resultado esperado é:

```text
Todas as verificações passaram.
```

O diagnóstico verifica ferramentas, configurações, links simbólicos, plugins, serviços e autenticações.

## Estrutura do projeto

```text
workstation/
├── config/
│   └── vscode/
├── docs/
├── dotfiles/
│   ├── fish/
│   ├── git/
│   ├── nvim/
│   ├── starship/
│   ├── tmux/
│   └── vscode/
├── scripts/
│   ├── lib/
│   ├── modules/
│   └── doctor.sh
├── install.sh
└── README.md
```

## Dotfiles

Os arquivos de configuração são aplicados com GNU Stow.

São gerenciadas configurações de:

- Fish
- Git
- Neovim
- Starship
- Tmux
- Visual Studio Code

Antes de substituir uma configuração existente, o instalador cria um backup em:

```text
~/.local/state/workstation/backups/
```

## Segurança

Este repositório não deve armazenar:

- chaves SSH privadas;
- tokens;
- senhas;
- credenciais;
- arquivos `.env`;
- sessões autenticadas;
- configurações locais que contenham segredos.

A identidade do Git fica em:

```text
~/.gitconfig.local
```

Esse arquivo não faz parte do repositório.

Consulte também:

```text
docs/SECURITY.md
```

## Uso diário

Atualizar o repositório:

```bash
cd ~/workstation
git pull
```

Aplicar novamente as configurações:

```bash
./install.sh
```

Verificar o ambiente:

```bash
./scripts/doctor.sh
```

## Escopo da versão 1

A versão 1 cobre o ambiente necessário para o trabalho diário.

Não fazem parte desta versão:

- AWS CLI;
- Terraform;
- Kubernetes;
- Helm;
- K9s;
- Go;
- Java;
- PHP;
- instalador interativo;
- suporte para outras distribuições;
- múltiplas contas do GitHub;
- uma CLI própria para o projeto.

Esses itens somente serão adicionados quando houver uma necessidade concreta.

## Solução de problemas

Consulte:

```text
docs/TROUBLESHOOTING.md
```

## Manutenção

O projeto entra em modo de manutenção após a versão 1.0.

Alterações devem ser feitas apenas quando:

- alguma instalação deixar de funcionar;
- uma ferramenta utilizada diariamente precisar ser adicionada;
- uma versão precisar ser atualizada;
- uma configuração atual causar problemas.
