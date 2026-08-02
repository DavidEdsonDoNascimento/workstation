# Segurança

Este repositório contém scripts e configurações pessoais de desenvolvimento, mas não deve armazenar credenciais ou informações secretas.

## Nunca versionar

- chaves SSH privadas;
- tokens do GitHub;
- tokens do Claude;
- chaves de APIs;
- senhas;
- cookies e sessões autenticadas;
- credenciais da AWS;
- arquivos `.env`;
- certificados privados;
- arquivos de configuração com segredos.

Exemplos de arquivos que não devem entrar no repositório:

```text
~/.ssh/id_ed25519
~/.ssh/id_rsa
~/.aws/credentials
~/.config/gh/
~/.claude/
~/.gitconfig.local
.env
.npmrc
```
