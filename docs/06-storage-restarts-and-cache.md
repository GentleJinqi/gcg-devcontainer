# Storage, restarts and image cache

[Home](../README.md) | [简体中文](../zh-cn/docs/06-storage-restarts-and-cache.md)

The most important rule is: **stopping preserves persistent data; deleting a
workspace deletes its per-workspace storage.** Persistent storage is still not
a backup.

| Path | Owner and purpose | Stop/start | Delete workspace |
| --- | --- | --- | --- |
| `/workspaces` | 50 GiB per-workspace CephFS SSD; Git checkout and optional `.venv` | Preserved | Deleted |
| `/shared` | Quota-controlled per-user CephFS HDD shared by that user's workspaces | Preserved | Preserved |
| `/dev/shm` | Memory-backed temporary space for the current run | Recreated | Recreated |
| `$HOME` | Supplied by the selected image | Persistent only if deliberately located on a persistent mount | No separate platform guarantee |
| Other root filesystem paths | Container image layers and current Pod changes | Recreated from the image | Recreated |

The `/dev/shm` size limit equals the memory selected in the Coder form. Do not
store durable checkpoints there.

## Where files belong

- Commit source and small configuration to Git.
- Keep the checkout and an optional manual `.venv` under `/workspaces`.
- Keep large datasets and cross-workspace results under `/shared` when quota
  permits.
- Put repeatable shell configuration and system packages in Dockerfile.

Do not assume an arbitrary HOME is persistent. The image must create HOME, but
the platform persists only its declared mounts. Do not use `/shared` as HOME.

## Persistent tool defaults injected by the Template

The Dev Container Templates inject these defaults into build lifecycle commands
and user sessions:

| Variable | Default path | What uses it |
| --- | --- | --- |
| `PIP_CACHE_DIR` | `/workspaces/.cache/pip` | pip download and wheel cache |
| `UV_CACHE_DIR` | `/workspaces/.cache/uv` | uv package cache |
| `HF_HOME` | `/workspaces/.cache/huggingface` | Hugging Face models, datasets and metadata |
| `CONDA_ENVS_PATH` | `/workspaces/.conda/envs` | Named Conda environments |
| `CONDA_PKGS_DIRS` | `/workspaces/.cache/conda/pkgs` | Conda package cache |

These directories survive stop/start and container replacement because they
are below `/workspaces`. Deleting the workspace deletes them. They are not
shared with another workspace and they are not a backup.

These are convenience defaults, not restrictions. A repository may replace a
value in `devcontainer.json` or its own lifecycle/shell configuration. Keep a
manually created project `.venv` inside the repository checkout; the Template
does not create one. For large caches that should be available to several of
your workspaces, choose a deliberate path below `/shared` and check your quota
first.

## Image cache is not user storage

The image cache stores a built environment; it does not contain the live
contents of `/workspaces` or `/shared`. The cache key includes repository URL,
Dev Container directory, resolved Git commit, cache schema and Envbuilder
version.

- a new Git commit intentionally creates a new cache key;
- stop/start can reuse an existing built image;
- deleting a workspace does not mean the Registry cache was deleted; and
- an upstream mutable tag can move while a cache hit keeps using the previously
  built result.

To deliberately re-evaluate a mutable base tag, record the intended update next
to `FROM` in Dockerfile, commit and push that change, and verify the cold build
in the shared Template. A new platform Golden Image release also invalidates
the affected cache automatically. Do not delete and recreate workspaces
repeatedly.

## Check capacity without deleting anything

**TERMINAL — run inside the Coder workspace:**

```bash
df -h /workspaces /shared /dev/shm
```

If storage is full, inspect known folders with File Browser and delete only
files you personally recognize. Never paste a bulk cleanup command from a post,
chat or AI answer. Ask an administrator when ownership is unclear.
