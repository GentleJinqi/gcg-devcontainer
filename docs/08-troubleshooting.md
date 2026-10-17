# Troubleshooting

[Home](../README.md) | [简体中文](../zh-cn/docs/08-troubleshooting.md)

Do not repair a workspace by adding administrator access, privileged mode,
host mounts, Docker sockets, device mounts or Registry credentials. Match the
symptom and fix the repository source.

## Workspace does not open

### RTX 5090 says Running but the agent says Connecting

It is probably waiting in the FIFO GPU queue. Wait. Deleting and recreating it
loses its queue position, and deletion removes `/workspaces` for that workspace.

### Build cannot find `devcontainer.json` or Dockerfile

Confirm the selected Git ref contains `.devcontainer/devcontainer.json` and the
file referenced by `build.dockerfile`. The Coder directory field must be exactly
`.devcontainer`. Commit and push hidden files before starting.

### A private HTTP(S) Git repository cannot be cloned

Keep **Git Repository** as a clean URL. Enter the provider's username/password
or token values in **Git HTTP username** and **Git HTTP password**. These fields
are intentionally unmasked and persist in trusted Coder/Terraform state and the
workspace Pod specification. Do not embed credentials in the URL or repository.

### Build cannot pull the base image

Check the exact `FROM` spelling and tag in the image matrix. A third-party
private Registry needs authentication arranged by an administrator. Never put
a Registry username or password in Git, Dockerfile or the Git HTTP credential
fields; those fields authenticate Git, not an image Registry.

### Build says `setpriv`, `base64`, `mktemp` or `/bin/sh` is missing

The selected image does not meet the minimum contract. Choose a compatible
image or add the required utilities during its image build. Do not install them
in a Pre-launch Script.

## Workspace opens but the contract check fails

### UID or GID is not 1000

`containerUser` and `remoteUser` do not identify the required account, or the
image created it with different numeric IDs. Fix the image and both user fields.
Do not run a recursive ownership or permission command.

### HOME is unset, missing or not writable

The image must set HOME for its UID/GID 1000 account and create that directory
with correct ownership. HOME does not have to be `/home/ubuntu`. Fix Dockerfile;
do not redirect HOME to `/shared`.

### `/workspaces` or `/shared` is missing or not writable

Remove repository-defined `workspaceMount`, `mounts` and host paths. The
platform owns both persistent mounts. If the untouched starter still fails,
contact an administrator.

### `nvidia-smi` fails

Restart once without changing repository files. If it still fails, report the
workspace name and UTC time. Do not install a driver or add device mounts.

## Optional project tools are missing

### Python, uv, Conda or `nvcc` is missing

Read the selected repository family in the image matrix. These tools are
optional image choices, not platform requirements. Choose the matching family
or add a reviewed distribution package in Dockerfile.

### `.venv` is missing

The starter no longer creates `.venv` automatically. If the project uses
Python, follow exactly one manual recipe in
[Customize the environment](04-customize-your-environment.md).

### `.venv` uses the wrong Python or contains removed packages

Use File Browser to rename `.venv`, create a new environment manually, and
verify it before removing the renamed directory. Never copy a bulk deletion
command.

## Image or files seem stale

### A mutable tag moved but the workspace did not change

A cache hit can continue using the image built for the existing Git commit.
Record the intended update next to `FROM` in Dockerfile, commit and push it,
then verify the resulting cold build in the shared Template. Repeated workspace
deletion is not an update mechanism.

### A terminal-installed tool disappeared after restart

The running root filesystem and an arbitrary HOME are not platform-persistent.
Put system tools in Dockerfile, project files under `/workspaces`, and
cross-workspace data under `/shared`.

### A pushed configuration change is ignored

Confirm the Coder Git Repository field selects the ref containing the new
commit and the Dev Container directory is `.devcontainer`. Unpushed files
cannot affect Envbuilder.

## Storage is full

**TERMINAL — run inside the Coder workspace:**

```bash
df -h /workspaces /shared /dev/shm
```

Use File Browser and delete only files you recognize. Never run a bulk deletion
command copied from a forum, chat or model answer.

## Run the safe diagnostic

**TERMINAL — run inside the Coder workspace:**

```bash
cd "$(git rev-parse --show-toplevel)"
sh scripts/check-environment.sh
```

This script does not modify the workspace, require optional project tools or
print the complete environment. Share only its output and the first relevant
build error.
