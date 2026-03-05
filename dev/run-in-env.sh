#!/usr/bin/env bash
set -euo pipefail

# Minimal environment wrapper for workshop use.
# - If micromamba is available, create and run a small env from environment.yml.
# - If not, fall back to running the command directly.

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_NAME="${RUN_ENV_NAME:-r-core}"
SPEC_FILE="${REPO_ROOT}/environment.yml"

if command -v micromamba >/dev/null 2>&1; then
  ROOT_PREFIX="${MAMBA_ROOT_PREFIX:-$HOME/.local/share/mamba}"
  ENV_PATH="${ROOT_PREFIX}/envs/${ENV_NAME}"
  if [[ ! -d "${ENV_PATH}" ]]; then
    echo "Creating micromamba env '${ENV_NAME}' at ${ENV_PATH} from ${SPEC_FILE}"
    mkdir -p "${ROOT_PREFIX}" || true
    micromamba create -y -p "${ENV_PATH}" -f "${SPEC_FILE}"
  fi
  exec micromamba run -p "${ENV_PATH}" "$@"
else
  echo "micromamba not found. Running command directly." >&2
  exec "$@"
fi
