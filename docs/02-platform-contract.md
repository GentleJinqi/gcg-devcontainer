# Understand the platform contract

[Home](../README.md) | [简体中文](../zh-cn/docs/02-platform-contract.md)

Keep three responsibilities separate. A working starter choice is not
automatically a platform requirement.

| Owner | Guarantees or chooses |
| --- | --- |
| GCG platform | `/workspaces`, `/shared`, `/dev/shm`, Git checkout, GPU runtime and Coder agent |
| Base image author | Linux AMD64, required utilities, UID/GID 1000 account, valid HOME, optional language/toolchain |
| Project author | Base image, user names, Dockerfile packages, Python environment, mutable tag or immutable digest |

## Persistent paths supplied by the platform

- `/workspaces` is the per-workspace persistent SSD root. The Git checkout is
  `/workspaces/<repo-name>`.
- `/shared` is quota-controlled, per-user persistent HDD storage shared by that
  user's workspaces.
- `/dev/shm` is memory-backed temporary space for the current run.

Do not declare those mounts again in `devcontainer.json`. Do not add
`workspaceMount`, host paths or Docker sockets.

## Identity: numeric IDs are fixed, names are not

The effective workspace account must have numeric UID 1000 and primary GID
1000. `containerUser` and `remoteUser` must identify that account in the
selected image. The username is not fixed by the platform.

This starter's image uses `ubuntu`. Another compatible image may use `vscode`,
`coder` or another name. Change both user fields together when changing images.
Do not leave the final container running as root.

## HOME belongs to the image

The platform does not create, mount, repair or persist HOME for an arbitrary
image. The UID/GID 1000 account must set `HOME` to an existing writable
directory. It may be `/home/ubuntu`, `/home/vscode` or another valid path.

A directory does not become persistent merely because it is HOME. Put project
files under `/workspaces`, cross-workspace data under `/shared`, and repeatable
shell configuration in the Dockerfile. Do not use `/shared` as HOME.

## Minimum compatible image checklist

Any public, GCG or third-party image is usable when it provides all of these:

- Linux AMD64 and a POSIX `/bin/sh`;
- `base64`, `mktemp`, `setpriv`, Git and common core utilities;
- a non-root account whose UID and primary GID are both 1000;
- a valid writable HOME for that account; and
- no dependency on privileged mode, host mounts, Docker socket or host devices.

Python, uv, Conda and a CUDA compiler are optional. The platform injects the
NVIDIA driver runtime; do not install a host NVIDIA kernel driver in the image.
