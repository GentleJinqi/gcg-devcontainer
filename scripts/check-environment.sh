#!/bin/sh
# Read-only platform checks. Python, uv, nvcc and .venv are deliberately not
# required: those are choices made by the selected image and project.
set -eu

fail() {
  echo "ERROR: $1" >&2
  exit 1
}

[ "$(id -u)" = 1000 ] || fail "user UID is not 1000"
[ "$(id -g)" = 1000 ] || fail "user GID is not 1000"
[ -n "${HOME:-}" ] || fail "HOME is not set by the selected image"
[ -d "$HOME" ] || fail "HOME does not exist: $HOME"
[ -w "$HOME" ] || fail "HOME is not writable: $HOME"
[ -d /workspaces ] || fail "/workspaces does not exist"
[ -w /workspaces ] || fail "/workspaces is not writable"
[ -d /shared ] || fail "/shared does not exist"
[ -w /shared ] || fail "/shared is not writable"
[ -d /dev/shm ] || fail "/dev/shm does not exist"
[ -w /dev/shm ] || fail "/dev/shm is not writable"

for command_name in base64 mktemp setpriv git nvidia-smi; do
  command -v "$command_name" >/dev/null 2>&1 \
    || fail "required command is missing: $command_name"
done

echo "Workspace identity: $(id -un) (UID 1000, GID 1000)"
echo "Image-provided HOME: $HOME"
echo "Persistent workspace: /workspaces"
echo "Persistent shared data: /shared"
echo "Visible GPU:"
nvidia-smi \
  --query-gpu=name,driver_version,memory.total \
  --format=csv,noheader
echo "OK: the GCG Dev Container contract is satisfied."
