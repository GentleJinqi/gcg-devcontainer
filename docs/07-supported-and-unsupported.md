# Supported and unsupported configuration

[Home](../README.md) | [简体中文](../zh-cn/docs/07-supported-and-unsupported.md)

GCG uses Envbuilder 1.3.0 inside Kubernetes. It is not a local Docker daemon and
does not implement every VS Code Dev Containers feature.

| Configuration | Status | What to do |
| --- | --- | --- |
| Clean Git URL | Supported | Never embed username/password in the URL |
| Git HTTP username/password form fields | Supported, unmasked and persistent | Use only for private HTTP(S) Git; values enter trusted state and Pod spec |
| `build.dockerfile`, `build.context` | Supported | Keep paths relative to the Dev Container directory |
| Compatible public or GCG `FROM` image | Supported | Image must satisfy the platform contract |
| Compatible third-party private image | Requires Registry authentication | Ask an administrator; never commit credentials |
| Concrete mutable tag | Supported | Commit the intended Dockerfile update to re-evaluate it; verify cold builds |
| `recommended`, `latest` channel tag | Supported but moving | Read channel meaning before use; `latest` is not automatically safest |
| Immutable `@sha256:` digest | Supported | Use for a reviewed base that must not move |
| `containerUser`, `remoteUser` | Supported with constraints | Both names must resolve to the selected image's UID/GID 1000 account |
| Image-provided HOME | Required | Must exist and be writable; path/name is not fixed |
| Non-secret `containerEnv` | Supported | Commit only public values |
| `postCreateCommand` | Optional | Keep short, repeat-safe and non-destructive; not required for `.venv` |
| Dockerfile distribution packages | Supported | Use commands matching the selected distribution |
| `name`, `updateRemoteUserUID` | Ignored by Envbuilder 1.3.0 | Omit both |
| `workspaceFolder`, `workspaceMount` | Unsupported here | Platform owns `/workspaces`; omit both |
| `mounts`, host paths, Docker socket | Unsupported and unsafe | Use `/workspaces` and `/shared` |
| `runArgs`, `--gpus`, device mounts | Unsupported | Platform allocates and injects the GPU |
| `privileged`, `capAdd`, `securityOpt` | Unsupported | Do not request them |
| Docker Compose and sidecars | Unsupported | Use one development container |
| `initializeCommand`, `postAttachCommand` | Unsupported | Keep setup explicit or use a reviewed post-create command |
| `forwardPorts`, `appPort` | Not implemented by this Template | Ask for a Coder application design if needed |
| `hostRequirements` | Ignored | Select CPU/memory in the Coder form |
| `customizations.vscode.extensions` | Not automatically installed | Install an approved extension through the editor UI |
| Dev Container Features | Avoid | Put explicit dependencies in Dockerfile or project files |
| Docker-in-Docker or Docker-outside-of-Docker | Unsupported | No Docker/containerd socket is exposed |

## Fixed platform values

- Git checkout and per-workspace persistent root: `/workspaces`
- Per-user persistent shared root: `/shared`
- Effective runtime UID/GID: `1000:1000`
- Default Dev Container directory in the Coder form: `.devcontainer`

The username and HOME path are **not** fixed. Python, uv, Conda, `nvcc`,
`requirements.txt` and `.venv` are optional project/image choices.

Git HTTP credential parameters are intentionally not masked. Coder stores them
in trusted Terraform state and the workspace Pod specification for cache lookup
and Envbuilder, then removes them from the Coder agent environment before user
login. Do not put them in a Git URL, repository or image.

## Reproducibility has layers

An immutable digest fixes a base image. It does not freeze external package
repositories or unpinned project dependencies. A mutable tag can move without
a Git change, while an existing workspace cache can continue using its earlier
built result.

For controlled work, review the exact image reference, pin language
dependencies, commit every environment change and verify the resulting cold
build before using RTX 5090.

## References for maintainers

- [Envbuilder Dev Container support](https://github.com/coder/envbuilder/blob/v1.3.0/docs/devcontainer-spec-support.md)
- [Development Container Specification](https://github.com/devcontainers/spec/blob/main/docs/specs/devcontainer-reference.md)

The stricter GCG contract in this starter takes precedence for GCG workspaces.
