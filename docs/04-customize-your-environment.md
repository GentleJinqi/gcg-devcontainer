# Customize the environment

[Home](../README.md) | [简体中文](../zh-cn/docs/04-customize-your-environment.md)

Make one small change, commit it, push it and cold-build it in the ordinary
shared workspace. Run the safe diagnostic after every image change. Do not
combine several untested recipes.

## Know which file owns the change

| Change | File or action |
| --- | --- |
| Base OS, system library or compiler | `.devcontainer/Dockerfile` |
| Image account name | Both user fields in `.devcontainer/devcontainer.json` |
| Public environment value | `containerEnv` in `devcontainer.json` |
| Python packages | Optional `requirements.txt` and a manually created `.venv` |
| Large or cross-workspace data | `/shared`, never the image or Git |

## Add a package to the sample Ubuntu image

Package commands are distribution-specific. This complete Dockerfile adds
`ffmpeg` only to the Ubuntu/Debian-based sample.

**FILE CONTENT — `.devcontainer/Dockerfile`; do not run in a terminal:**

```Dockerfile
FROM registry.gcg.cardiff.zhuoling.space/platform/coder/golden/ubuntu-cuda-uv:24.04-cuda12.8

USER root

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      ffmpeg \
    && apt-get clean

USER 1000:1000
```

Do not paste `apt-get` into a Rocky image or running workspace. Do not add an
unknown package repository or a download-and-run installer.

## Add a package to a Rocky image

This is a separate complete example for Rocky Linux 9. It adds `strace`.

**FILE CONTENT — `.devcontainer/Dockerfile`; do not run in a terminal:**

```Dockerfile
FROM registry.gcg.cardiff.zhuoling.space/platform/coder/golden/rocky-uv:9-v2

USER root

RUN dnf install -y strace \
    && dnf clean all

USER 1000:1000
```

The GCG Rocky account is named `rocky`. When using this image, change both
`containerUser` and `remoteUser` to `rocky`. Do not mix the Ubuntu and Rocky
package examples.

## Create `.venv` manually with uv

The default sample image includes Python and uv. The platform does not create,
activate, validate or delete `.venv` for you.

First review `requirements.txt`. Then run the complete setup yourself.

**TERMINAL — run inside the Coder workspace:**

```bash
cd "$(git rev-parse --show-toplevel)"
uv venv --python /usr/bin/python3 .venv
uv pip install --python .venv/bin/python --requirement requirements.txt
uv pip check --python .venv/bin/python
```

Use `.venv/bin/python` explicitly or activate it in your own shell session.
Because `.venv` is inside the checkout below `/workspaces`, stop/start preserves
it and deleting the workspace deletes it.

Removing a line from `requirements.txt` does not uninstall a package already
inside `.venv`. When removal or a Python-version change matters, use the File
Browser to rename `.venv`, create a new one with the commands above, verify it,
then decide what to do with the renamed directory. Do not use a bulk deletion
command.

## Create `.venv` with standard Python

Use this alternative only when the selected image provides `python3`, the
standard `venv` module and pip. Do not run both recipes for the same `.venv`.

**TERMINAL — run inside the Coder workspace:**

```bash
cd "$(git rev-parse --show-toplevel)"
python3 -m venv .venv
.venv/bin/python -m pip install --requirement requirements.txt
.venv/bin/python -m pip check
```

If a command is missing, choose an image family that provides the tool or add
the matching distribution package in Dockerfile. Do not install a missing
system tool with administrator commands in the running workspace.

## Add a non-secret environment variable

Only commit values that are safe to publish. Add one `containerEnv` object to
`.devcontainer/devcontainer.json` after the user fields.

**FILE CONTENT — JSON property; do not run in a terminal:**

```json
"containerEnv": {
  "PYTHONUNBUFFERED": "1"
}
```

Add the required comma to the preceding JSON property. Never put a password,
token, SSH key or private Registry URL credential in `containerEnv`, Dockerfile
`ENV`, Dockerfile `ARG` or a lifecycle command.

## After every image change

1. Review the diff and confirm it contains no credential.
2. Commit and push to the ref selected in Coder.
3. Stop/start **GCG Dev Container**.
4. **TERMINAL — run inside the Coder workspace:**

   ```bash
   cd "$(git rev-parse --show-toplevel)"
   sh scripts/check-environment.sh
   ```

5. Use RTX 5090 only after this shared-workspace test passes.
