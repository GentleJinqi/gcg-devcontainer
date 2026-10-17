# Create the first workspace

[Home](../README.md) | [简体中文](../zh-cn/docs/01-first-workspace.md)

This procedure proves the repository and selected image satisfy the platform
contract before anybody waits for the RTX 5090.

## Before opening Coder

The selected Git ref must contain `.devcontainer/devcontainer.json`. This
starter builds `.devcontainer/Dockerfile`, so that file must also be committed.
The optional `requirements.txt` and diagnostic script belong to this starter;
they are not platform requirements.

The `.devcontainer` directory is hidden on Linux and macOS because its name
starts with a dot. Check it on the Git service's web page. Seeing it only on
your computer is not enough.

Do not use VS Code's Dev Container generator. If it already generated files,
replace the whole generated `.devcontainer` directory with this starter for
the first test. Do not merge unknown mount, Compose or host-access settings.

## Create the workspace

1. Open Coder and choose **GCG Dev Container**.
2. Copy a clean clone URL into **Git Repository**. Never embed a password in
   that URL. SSH uses your Coder-managed SSH key.
3. For a private HTTP(S) repository, fill **Git HTTP username** and
   **Git HTTP password** with the provider's username/password or token values.
   Leave both empty for a public or SSH repository.
4. Enter exactly `.devcontainer` in **Dev Container directory**. Do not begin
   with `/`.
5. Select 8 CPU cores and 60 GiB memory.
6. Leave **Pre-launch Script** completely empty.
7. Create the workspace and wait. Do not create a second workspace to make a
   cold build faster.

The Git HTTP username and password are ordinary, unmasked, persistent Template
parameters. Their values are intentionally stored in trusted Coder/Terraform
state and the workspace Pod specification so cache lookup and Envbuilder can
clone the repository. They are removed from the Coder agent environment before
login. Never put them in the URL, repository files or Dockerfile.

## Verify only the platform contract

**TERMINAL — run inside the Coder workspace:**

```bash
cd "$(git rev-parse --show-toplevel)"
sh scripts/check-environment.sh
```

The check requires UID/GID 1000, a valid image-provided HOME, writable
`/workspaces`, `/shared` and `/dev/shm`, the platform utilities, and one visible
GPU. It deliberately does not require Python, uv, Conda, `nvcc` or `.venv`.

A valid result ends with:

```text
OK: the GCG Dev Container contract is satisfied.
```

If this line is missing, use [Troubleshooting](08-troubleshooting.md). Do not
patch the running container with administrator commands.

## Move to RTX 5090 only when necessary

Stop the verified shared workspace. Then create **GCG RTX 5090 Dev Container**
with the same repository URL/ref and `.devcontainer` directory. The two
Templates share the image cache for those exact inputs.

The RTX 5090 workspace may show **Running** while the agent says
**Connecting**. It is usually waiting in the FIFO queue. Deleting and recreating
it loses its position; deletion also removes that workspace's `/workspaces`
storage.

## Select a Git ref later

The Git Repository field accepts a URL followed by `#` and a branch, tag or
full Git ref. Choose the ref in the Coder form; never paste a documentation URL
that points to somebody else's repository. Commit and push every environment
change before stop/start.
