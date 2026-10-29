# GCG Dev Container starter repository

[简体中文](zh-cn/README.md)

> **Use this repository as-is for your first workspace.** Do not run VS Code's
> **Add Dev Container Configuration Files** command. Do not paste commands from
> posts or AI answers that request administrator access, delete many files,
> mount a Docker socket or device, or ask for a Registry password. Stop and ask
> a GCG administrator instead.

This starter selects one known-good GCG image. It does **not** make that image,
the username `ubuntu`, Python, CUDA Toolkit, uv or `/home/ubuntu` a platform
requirement. You may use any compatible Linux AMD64 base image.

## The contract at a glance

| The platform guarantees | Your selected image must guarantee |
| --- | --- |
| Git checkout below the 50 GiB workspace root `/workspaces` | A non-root account with numeric UID 1000 and primary GID 1000 |
| Per-user shared storage at `/shared` | `HOME` points to an existing writable directory |
| Memory-backed temporary storage at `/dev/shm` | POSIX `/bin/sh`, `base64`, `mktemp`, `setpriv`, Git and common core utilities |
| GPU allocation, NVIDIA runtime and Coder agent | Any optional tools your project needs, such as Python, uv, Conda or `nvcc` |

The account name and HOME path come from the image. This sample image calls the
account `ubuntu`, but another compatible image may call it `vscode`, `coder` or
something else. The numeric UID/GID must still be `1000:1000`.

## First workspace: the safe path

1. Publish the **whole contents** of this folder as a Git repository. Keep the
   hidden `.devcontainer` directory.
2. Commit and push before creating a workspace. Coder cannot read unpushed
   files from your computer.
3. In Coder, choose **GCG Dev Container** first and use these values:

   | Field | Value |
   | --- | --- |
   | Git Repository | The clean clone URL; never include a password |
   | Git HTTP username/password | Private HTTP(S) repository only; leave both empty for public or SSH |
   | Dev Container directory | `.devcontainer` |
   | CPU cores | `8` |
   | Memory | `60 GiB` |
   | Pre-launch Script | Leave completely empty |

4. Wait for the Coder agent to connect. A first build can take several minutes.
5. **TERMINAL — run inside the Coder workspace:**

   ```bash
   cd "$(git rev-parse --show-toplevel)"
   sh scripts/check-environment.sh
   ```

   The final line must be `OK: the GCG Dev Container contract is satisfied.`

For a private HTTP(S) repository, the two Git HTTP credential fields are
ordinary, unmasked, persistent Template parameters. This is intentional: they
are stored in trusted Coder/Terraform state and the workspace Pod specification
for cache lookup and Envbuilder. Never embed them in the Git URL or repository.

Only then stop the shared workspace and create **GCG RTX 5090 Dev Container**
with the exact same Git URL/ref and Dev Container directory. That sequence
normally lets the 5090 workspace reuse the image cache instead of occupying the
exclusive GPU for a cold build.

### Updating an existing workspace (local note)

Envbuilder never re-pulls a checkout that already exists below `/workspaces`
("The repository already exists!"). After pushing a change from another
machine, run `git pull --ff-only` inside the workspace checkout **before**
stop/start. Otherwise the restart builds the old files but files the result
under the new commit's cache key, and every later start, including the RTX 5090
workspace, reuses that stale image. If that already happened, push one more
commit and repeat with the pull first.

### What this repository changes (local note)

HOME is reset on every stop/start, and this workspace shares the 1T disk with
gcg-standard workspaces. So this repository:

- uses the conda image family, so `/opt/conda/bin/python3.12` matches
  gcg-standard and the shared venvs run unchanged;
- links `/home/ubuntu/shared` to `/shared`, so every host reaches the shared
  disk by the same path;
- links `~/.ssh` and `~/.claude` to `/workspaces`, sets `CLAUDE_CONFIG_DIR`, and
  keeps misc and compile caches in `/workspaces/.cache`;
- points `HF_HOME`, `UV_CACHE_DIR` and `TORCH_HOME` at the shared caches.

The rules for working on the shared disk from several hosts live in
`/home/ubuntu/shared/env/RULES.md`.

## Choose, customize and save

- Choose a GCG mutable tag, pin a digest, or use another compatible image:
  [Choose a base image](docs/03-choose-a-base-image.md).
- Add system tools and optionally create Python `.venv` yourself:
  [Customize the environment](docs/04-customize-your-environment.md).
- Keep project files and a manual `.venv` in the checkout below `/workspaces`.
- The Template keeps pip, uv, Hugging Face and Conda caches, plus named Conda
  environments, below `/workspaces` by default. See
  [Storage, restarts and image cache](docs/06-storage-restarts-and-cache.md) for
  the exact injected variables and how to override them.
- Keep large cross-workspace data under `/shared`.
- Do not assume HOME is persistent. The image supplies HOME; only the declared
  persistent paths have platform storage guarantees.

Never put passwords, tokens, SSH keys, `.env` contents or Registry credentials
in Dockerfile, `devcontainer.json`, requirements files or Git. Private HTTPS
Git credentials belong only in their designated Coder form fields.

## Read next

1. [Create the first workspace](docs/01-first-workspace.md)
2. [Understand the platform contract](docs/02-platform-contract.md)
3. [Choose a base image](docs/03-choose-a-base-image.md)
4. [Customize the environment](docs/04-customize-your-environment.md)
5. [Use the GPU and RTX 5090 safely](docs/05-gpu-and-rtx5090.md)
6. [Understand storage, restarts and cache](docs/06-storage-restarts-and-cache.md)
7. [Supported and unsupported settings](docs/07-supported-and-unsupported.md)
8. [Troubleshoot a workspace](docs/08-troubleshooting.md)
9. [Ask for help without exposing credentials](docs/09-ask-for-help.md)
10. [Browse the complete GCG image matrix](docs/reference/image-matrix.md)
