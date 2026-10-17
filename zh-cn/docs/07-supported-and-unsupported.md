# 受支持和不受支持的配置

[首页](../README.md) | [English](../../docs/07-supported-and-unsupported.md)

GCG 在 Kubernetes 内使用 Envbuilder 1.3.0。它不是本地 Docker daemon，也不能实现
VS Code Dev Containers 的每一项功能。

| 配置 | 状态 | 应该怎么做 |
| --- | --- | --- |
| 干净的 Git URL | 支持 | 绝对不要在 URL 中嵌入 username/password |
| Git HTTP username/password 表单字段 | 支持、未遮罩且持久 | 仅用于私有 HTTP(S) Git；值会进入受信 state 和 Pod spec |
| `build.dockerfile`, `build.context` | 支持 | 保持路径相对于 Dev Container 目录 |
| 兼容的 public 或 GCG `FROM` 镜像 | 支持 | 镜像必须满足平台契约 |
| 兼容的第三方私有镜像 | 需要 Registry 认证 | 联系管理员；绝对不要提交凭据 |
| 具体可变 tag | 支持 | 提交预期的 Dockerfile 更新以重新解析；验证冷构建 |
| `recommended`、`latest` channel tag | 支持但会移动 | 使用前阅读 channel 语义；`latest` 不会自动成为最安全的选择 |
| 不可变 `@sha256:` digest | 支持 | 用于绝对不能移动的已审查基础镜像 |
| `containerUser`, `remoteUser` | 在约束下支持 | 两个名称都必须解析为所选镜像的 UID/GID 1000 账户 |
| 镜像提供的 HOME | 必需 | 必须存在且可写；路径/名称不固定 |
| 非机密 `containerEnv` | 支持 | 只能提交公开值 |
| `postCreateCommand` | 可选 | 保持简短、可重复且不破坏数据；`.venv` 不需要它 |
| Dockerfile 发行版软件包 | 支持 | 使用与所选发行版匹配的命令 |
| `name`, `updateRemoteUserUID` | Envbuilder 1.3.0 会忽略 | 两者都不要设置 |
| `workspaceFolder`, `workspaceMount` | 在这里不受支持 | 平台管理 `/workspaces`；两者都不要设置 |
| `mounts`、host path、Docker socket | 不受支持且不安全 | 使用 `/workspaces` 和 `/shared` |
| `runArgs`、`--gpus`、device mount | 不受支持 | GPU 由平台分配和注入 |
| `privileged`、`capAdd`、`securityOpt` | 不受支持 | 不要请求这些设置 |
| Docker Compose 和 sidecar | 不受支持 | 使用一个开发容器 |
| `initializeCommand`, `postAttachCommand` | 不受支持 | 保持显式配置，或使用经过审查的 post-create 命令 |
| `forwardPorts`, `appPort` | 此 Template 尚未实现 | 如有需要，请申请 Coder application 设计 |
| `hostRequirements` | 忽略 | 在 Coder 表单中选择 CPU/内存 |
| `customizations.vscode.extensions` | 不会自动安装 | 通过编辑器 UI 安装经过批准的 extension |
| Dev Container Features | 避免使用 | 将明确的依赖写入 Dockerfile 或项目文件 |
| Docker-in-Docker 或 Docker-outside-of-Docker | 不受支持 | 不会暴露 Docker/containerd socket |

## 固定的平台值

- Git checkout 和按工作区分配的持久根目录：`/workspaces`
- 按用户分配的持久共享根目录：`/shared`
- 有效 runtime UID/GID：`1000:1000`
- Coder 表单中默认的 Dev Container directory：`.devcontainer`

用户名和 HOME 路径**不固定**。Python、uv、Conda、`nvcc`、`requirements.txt` 和
`.venv` 都是可选的项目/镜像选择。

Git HTTP 凭据参数被有意设置为不遮罩。Coder 会将它们存入受信的 Terraform state 和
workspace Pod specification，供 cache lookup 和 Envbuilder 使用，然后在用户登录前
从 Coder agent environment 中移除。不要将它们写入 Git URL、仓库或镜像。

## 可复现性具有多个层次

不可变 digest 会固定基础镜像。它不会冻结外部软件包仓库或未固定版本的项目依赖。
可变 tag 可以在没有 Git 修改时移动，而已经存在的 workspace cache 仍可能继续使用
之前构建的结果。

对于受控工作，请审查准确的镜像 reference，固定语言依赖，提交每一项环境修改，并在
使用 RTX 5090 前验证产生的冷构建。

## 供维护者使用的参考资料

- [Envbuilder 对 Dev Container 的支持](https://github.com/coder/envbuilder/blob/v1.3.0/docs/devcontainer-spec-support.md)
- [Development Container Specification](https://github.com/devcontainers/spec/blob/main/docs/specs/devcontainer-reference.md)

对于 GCG 工作区，本 starter 中更严格的 GCG 契约优先适用。
