# Choose a base image

[Home](../README.md) | [简体中文](../zh-cn/docs/03-choose-a-base-image.md)

The starter's GCG image is a convenience, not a restriction. Choose in this
order: operating system, CUDA toolkit if needed, Python manager if needed, then
mutable tag or immutable digest.

## Choose the tools you actually need

| Need | GCG family suffix |
| --- | --- |
| Common developer tools only | no suffix |
| Add uv | `-uv` |
| Add Conda | `-conda` or repository name `ubuntu-conda` |
| Add Conda and uv | `-conda-uv` |
| Add CUDA Toolkit | use a `cuda` repository family |

`nvidia-smi` comes from the platform's NVIDIA runtime. `nvcc` exists only in a
CUDA image. A visible GPU does not require every project to install a toolkit.

The default Dockerfile uses this concrete mutable tag:

**FILE CONTENT — Dockerfile `FROM` line; do not run in a terminal:**

```Dockerfile
FROM registry.gcg.cardiff.zhuoling.space/platform/coder/golden/ubuntu-cuda-uv:24.04-cuda12.8
```

See the [complete image matrix](reference/image-matrix.md) for every family and
all 41 Ubuntu/CUDA tuples.

## Mutable tags are supported

A mutable tag is easy to read and can be moved to rebuilt content. That
convenience trades away strict reproducibility:

- a concrete tag such as `24.04-cuda12.8` keeps the named OS/toolkit tuple but
  may be rebuilt in place;
- `recommended` is a moving GCG channel for the broadly recommended tuple;
- `latest` is a moving GCG channel for the newest catalog tuple, which may be
  too new for a project; and
- a workspace cache hit does not promise to notice that an upstream tag moved.

To deliberately pick up a moved tag, record the intended update next to `FROM`
in Dockerfile, commit and push the change, then cold-build and verify it in
**GCG Dev Container**. Repeatedly deleting a workspace is not an update
mechanism.

## Immutable digests are supported

Use a full `@sha256:` reference when a reviewed base must not move. Ask an
administrator for the current digest from `40-coder/images/images.lock.json`.
Changing to a new digest must be a reviewed Git commit.

A digest fixes only the base image. Ubuntu/Rocky package repositories and
unpinned project dependencies can still change during a later build. Pin
reviewed language dependencies and verify every cold rebuild.

## Channel meanings

| Channel | Ubuntu CPU families | Ubuntu CUDA families | Rocky 9 families |
| --- | --- | --- | --- |
| `recommended` | Ubuntu 24.04 | Ubuntu 24.04 + CUDA 12.8 | Rocky 9 image tag `9-v2` |
| `latest` | Ubuntu 26.04 | Ubuntu 26.04 + CUDA 13.3 | Rocky 9 image tag `9-v2` |
| Version tag | `20.04`, `22.04`, `24.04`, `26.04` | `<ubuntu>-cuda<cuda>` | `9-v2` |

For Rocky, `9-v2` means Rocky Linux major version 9 using generation 2 of the
GCG image recipe. It does **not** mean Rocky Linux 9.2. The Rocky aliases `9`,
`recommended` and `latest` currently resolve to `9-v2`.

## Use any compatible image

The Dockerfile may use a public image, another GCG image or an image from a
third-party Registry. It must pass the checklist in
[Platform contract](02-platform-contract.md). In particular, it must provide a
UID/GID 1000 account, valid writable HOME, POSIX shell and required utilities.

A private third-party Registry needs separate authentication arranged with an
administrator. The platform's GCG Registry credential does not grant access to
another Registry. Never put a Registry password in Git, Dockerfile build args
or `devcontainer.json`.

Do not add host NVIDIA drivers, Docker-in-Docker, device mounts, privileged
mode or host paths to make an incompatible image start.
