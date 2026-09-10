#!/usr/bin/env bash

set -Eeuo pipefail

if (( $# > 1 )); then
  printf 'Usage: %s [host]\n' "$0" >&2
  exit 2
fi

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
local_host="$(hostname --short)"
host="${1:-${local_host}}"
log_file="${repo_root}/.nixos-switch.log"
flake="${repo_root}#${host}"
lock_flags=(--no-update-lock-file --no-write-lock-file)

if [[ "${host}" != "${local_host}" ]]; then
  printf 'Refusing to switch %s using the configuration for %s.\n' "${local_host}" "${host}" >&2
  exit 1
fi

cd -- "${repo_root}"

if ! declared_host="$(
  nix eval \
    "${lock_flags[@]}" \
    --raw \
    ".#nixosConfigurations.${host}.config.networking.hostName"
)"; then
  printf 'Unknown or invalid NixOS host: %s\n' "${host}" >&2
  exit 1
fi

if [[ "${declared_host}" != "${local_host}" ]]; then
  printf 'Configuration %s declares hostname %s; expected %s.\n' \
    "${host}" \
    "${declared_host}" \
    "${local_host}" >&2
  exit 1
fi

printf 'Building NixOS configuration for %s...\n' "${host}"
nix build \
  "${lock_flags[@]}" \
  --no-link \
  --show-trace \
  ".#nixosConfigurations.${host}.config.system.build.toplevel" \
  2>&1 | tee "${log_file}"

printf 'Switching NixOS configuration for %s...\n' "${host}"
sudo nixos-rebuild switch \
  "${lock_flags[@]}" \
  --show-trace \
  --flake "${flake}" \
  2>&1 | tee -a "${log_file}"
