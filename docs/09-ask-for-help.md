# Ask for help without exposing credentials

[Home](../README.md) | [简体中文](../zh-cn/docs/09-ask-for-help.md)

Send a small, precise report. Do not post the complete environment, complete
private build log, Git credentials, SSH keys, tokens, `.env` contents or a
Registry password.

## Include these items

1. Workspace name.
2. Exact Template name: **GCG Dev Container** or
   **GCG RTX 5090 Dev Container**.
3. UTC time when the problem happened.
4. Exact base image reference from `FROM`, without any credential.
5. Whether the reference is a mutable tag or immutable digest. If a tag was
   expected to move, say so explicitly.
6. Selected Git branch/tag/ref and whether the changed commit was pushed.
7. Output from the safe check below.
8. A screenshot or short copy of the first relevant error, with private
   repository URLs and credentials hidden.

**TERMINAL — run inside the Coder workspace if it opens:**

```bash
cd "$(git rev-parse --show-toplevel)"
date -u
sh scripts/check-environment.sh
```

The diagnostic safely reports the username, UID/GID, HOME path, persistent
paths and GPU summary. It does not print all environment variables.

If the workspace never opens, provide UTC time from your own clock and only the
first relevant build error.

## State what changed

Name the one file changed immediately before failure:

- `.devcontainer/Dockerfile`;
- `.devcontainer/devcontainer.json`;
- `requirements.txt` or another project dependency file; or
- no repository file changed.

If the problem concerns Python, state whether you manually created `.venv` and
which documented recipe you used. Do not send a credential-bearing clone or
Registry login command.

## Stop if advice asks for any of these

- administrator or root access in the running workspace;
- deletion of a broad directory or files you do not recognize;
- a Docker/containerd socket, host path or host device;
- privileged mode or additional Linux capabilities;
- an NVIDIA host driver installation;
- a token, password, SSH key or Registry login in Git; or
- a command downloaded from the internet and executed immediately.

Those actions are outside the user workspace contract. Ask a GCG administrator
to diagnose the platform instead of trying them.
