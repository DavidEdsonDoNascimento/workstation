# Roadmap — Workstation

Ambiente pessoal e reproduzível de desenvolvimento para Ubuntu.

O objetivo é permitir que uma máquina nova seja configurada com um único fluxo:

```bash
git clone git@github.com:DavidEdsonDoNascimento/workstation.git
cd workstation
./install.sh
```

## Legenda

- [x] Concluído
- [ ] Pendente
- [~] Parcialmente implementado

---

## Fase 0 — Fundação

Estrutura inicial, execução modular e segurança básica.

- [x] Criar repositório `workstation`
- [x] Criar instalador principal `install.sh`
- [x] Criar estrutura modular em `scripts/modules`
- [x] Criar biblioteca compartilhada `scripts/lib/common.sh`
- [x] Detectar e validar o Ubuntu
- [x] Executar módulos em ordem numérica
- [x] Criar diagnóstico com `scripts/doctor.sh`
- [x] Criar `.gitignore` para arquivos sensíveis
- [x] Criar documentação inicial
- [x] Garantir que os scripts possam ser executados novamente

---

## Fase 1 — Ferramentas essenciais

Ferramentas básicas de terminal e desenvolvimento.

- [x] Atualizar a lista de pacotes do Ubuntu
- [x] Git
- [x] curl
- [x] wget
- [x] build-essential
- [x] unzip e zip
- [x] jq
- [x] tree
- [x] fzf
- [x] ripgrep
- [x] fd
- [x] bat
- [x] eza
- [x] zoxide
- [x] GNU Stow
- [ ] GitHub CLI

---

## Fase 2 — Terminal

Terminal moderno, produtivo e reproduzível.

- [x] Fish Shell
- [x] Remover mensagem inicial do Fish
- [x] Configuração modular em `conf.d`
- [x] Configurar `~/.local/bin` no PATH
- [x] Starship
- [x] Tema inicial do Starship
- [x] JetBrainsMono Nerd Font
- [x] Abreviações de navegação
- [x] Abreviações do Git
- [x] Tmux
- [x] Configuração versionada do Tmux
- [x] TPM — Tmux Plugin Manager
- [x] tmux-sensible
- [x] tmux-yank
- [x] tmux-resurrect
- [x] tmux-continuum
- [x] Persistência automática de sessões
- [x] Integração com clipboard no X11 e Wayland
- [ ] Revisar aliases do repositório antigo
- [ ] Criar funções pessoais adicionais do Fish

---

## Fase 3 — Git e autenticação

Configuração segura do Git e acesso aos repositórios.

- [x] Git instalado
- [x] Autenticação SSH configurada manualmente nesta máquina
- [x] Configuração versionada do Git
- [x] Solicitar nome e e-mail durante a instalação
- [x] Instalar GitHub CLI
- [x] Criar fluxo assistido para `gh auth login`
- [x] Documentar criação da chave SSH
- [x] Verificar conexão SSH com o GitHub
- [ ] Suportar múltiplas contas GitHub
- [ ] Criar configurações específicas por diretório
- [ ] Garantir que nenhuma chave privada seja versionada

> Chaves SSH, tokens e credenciais não devem ser armazenados no repositório.

---

## Fase 4 — Ambiente de desenvolvimento

Linguagens, gerenciadores de versões e containers.

### Node.js

- [x] Instalar `fnm`
- [x] Integrar o `fnm` com Fish
- [x] Selecionar automaticamente a versão por projeto
- [x] Instalar Node.js 24
- [x] Definir Node.js 24 como padrão
- [x] npm
- [x] Corepack
- [x] pnpm
- [x] Validar versões no `doctor.sh`

### Python

- [x] Python 3
- [x] pip
- [x] pipx
- [x] Ambiente virtual
- [x] Ferramentas de formatação e lint

### Containers

- [x] Docker Engine
- [x] Docker Compose
- [x] Docker Buildx
- [x] Adicionar usuário ao grupo `docker`
- [x] Validar instalação sem `sudo`
- [x] Testar com o container `hello-world`

### Ferramentas futuras

- [ ] Go
- [ ] PHP
- [ ] Java
- [ ] PostgreSQL Client
- [ ] Redis Client
- [ ] AWS CLI
- [ ] Terraform
- [ ] Kubernetes CLI

---

## Fase 5 — Editores

Editores configurados para desenvolvimento diário.

### Neovim

- [x] Instalar Neovim
- [x] Criar binário em `~/.local/bin`
- [x] Instalar Tree-sitter CLI
- [x] Adicionar LazyVim
- [x] Versionar configuração do LazyVim
- [x] Instalar plugins automaticamente
- [x] Versionar `lazy-lock.json`
- [x] Fazer backup de configurações anteriores
- [x] Validar Neovim e LazyVim no `doctor.sh`
- [ ] Habilitar extra de TypeScript
- [ ] Habilitar extra de JSON
- [ ] Habilitar extra de Python
- [ ] Habilitar extra de Docker
- [ ] Habilitar extra de Markdown
- [ ] Configurar Prisma
- [ ] Configurar ESLint
- [ ] Configurar Prettier
- [ ] Configurar atalhos pessoais
- [ ] Criar integração de navegação entre Neovim e Tmux

### Visual Studio Code

- [x] Instalar Visual Studio Code
- [x] Versionar configurações não sensíveis
- [x] Versionar lista de extensões
- [x] ESLint
- [x] Prettier
- [x] GitLens
- [x] Docker
- [x] Prisma
- [x] Tailwind CSS
- [x] Python
- [x] EditorConfig
- [x] Error Lens
- [x] REST Client
- [x] Configurar JetBrainsMono Nerd Font
- [x] Criar script para restaurar extensões

---

## Fase 6 — Ferramentas de IA

Ferramentas usadas no desenvolvimento assistido por inteligência artificial.

- [x] Instalar Claude Code
- [x] Validar Claude Code no `doctor.sh`
- [x] Documentar autenticação
- [x] Versionar somente configurações não sensíveis
- [x] Adicionar regras pessoais do Claude Code
- [x] Adicionar templates de projeto
- [x] Preparar integração com `AGENTS.md`
- [x] Avaliar instalação de outras ferramentas de IA

> Tokens, sessões autenticadas e credenciais não devem ser armazenados no repositório.

---

## Fase 7 — Dotfiles e configuração

Gerenciamento centralizado das configurações pessoais.

- [x] Criar estrutura `dotfiles`
- [x] Gerenciar Fish com GNU Stow
- [x] Gerenciar Starship com GNU Stow
- [x] Gerenciar Tmux com GNU Stow
- [x] Gerenciar Neovim com GNU Stow
- [x] Criar backups antes de substituir configurações
- [x] Armazenar backups fora do repositório
- [ ] Gerenciar Git com GNU Stow
- [ ] Gerenciar VS Code
- [ ] Criar comando para remover os links
- [ ] Criar comando para restaurar backups
- [ ] Detectar conflitos antes de executar o Stow
- [ ] Permitir selecionar quais dotfiles serão aplicados

Os backups ficam em:

```text
~/.local/state/workstation/backups/
```

---

## Fase 8 — Aplicativos

Aplicativos usados diariamente no ambiente de desenvolvimento.

- [ ] Visual Studio Code
- [ ] Google Chrome
- [ ] GitHub CLI
- [ ] LazyGit
- [ ] DBeaver
- [ ] Insomnia ou Bruno
- [ ] Discord
- [ ] Spotify
- [ ] Ferramentas opcionais selecionáveis

---

## Fase 9 — Instalador avançado

Melhorias na experiência de instalação.

- [ ] Permitir executar um módulo específico
- [ ] Adicionar opção `--only`
- [ ] Adicionar opção `--skip`
- [ ] Adicionar opção `--list`
- [ ] Adicionar opção `--dry-run`
- [ ] Adicionar instalação interativa
- [ ] Permitir instalação mínima
- [ ] Permitir instalação completa
- [ ] Detectar pacotes já instalados
- [ ] Registrar logs da instalação
- [ ] Exibir resumo final
- [ ] Informar quando reiniciar ou abrir nova sessão
- [ ] Evitar solicitar `sudo` repetidamente

Exemplos planejados:

```bash
./install.sh
./install.sh --list
./install.sh --only docker
./install.sh --only neovim
./install.sh --skip vscode
./install.sh --dry-run
```

---

## Fase 10 — Diagnóstico e testes

Garantir que a workstation possa ser reproduzida com segurança.

- [x] Criar `scripts/doctor.sh`
- [x] Verificar ferramentas essenciais
- [x] Verificar Fish e Starship
- [x] Verificar Nerd Font
- [x] Verificar Tmux e plugins
- [x] Verificar Neovim e LazyVim
- [x] Verificar Node.js e pnpm
- [ ] Exibir versões de todas as ferramentas
- [ ] Validar links simbólicos
- [ ] Validar configuração do Fish
- [ ] Validar configuração do Tmux
- [ ] Executar `nvim --headless` como teste
- [ ] Testar scripts com ShellCheck
- [ ] Adicionar testes automatizados com Bats
- [ ] Criar pipeline no GitHub Actions
- [ ] Testar instalação em container Ubuntu
- [ ] Testar instalação em máquina virtual limpa

---

## Fase 11 — Manutenção

Atualização e evolução do ambiente.

- [ ] Criar `scripts/update.sh`
- [ ] Atualizar pacotes do sistema
- [ ] Atualizar plugins do Tmux
- [ ] Atualizar plugins do LazyVim
- [ ] Atualizar versões do Node.js
- [ ] Atualizar extensões do VS Code
- [ ] Atualizar ferramentas instaladas manualmente
- [ ] Exibir mudanças antes de atualizar
- [ ] Criar documentação de troubleshooting
- [ ] Registrar decisões técnicas
- [ ] Criar changelog

Comando planejado:

```bash
./scripts/update.sh
```

---

## Fase atual

A fundação, o terminal, o Tmux, o Neovim, o LazyVim, o Node.js e o pnpm estão concluídos.

Próximos passos:

1. Configurar extras do LazyVim.
2. Instalar Docker e Docker Compose.
3. Instalar Visual Studio Code e extensões.
4. Instalar Claude Code.
5. Automatizar GitHub CLI e autenticação.
