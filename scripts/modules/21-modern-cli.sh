#!/usr/bin/env bash

set -Eeuo pipefail

ROOT_DIR="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/../.." &&
  pwd
)"

# shellcheck source=scripts/lib/common.sh
source "$ROOT_DIR/scripts/lib/common.sh"

log "Instalando ferramentas modernas de terminal"

sudo apt-get install -y eza

success "Ferramentas modernas de terminal instaladas"
