# 了解平台契约

[首页](../README.md) | [English](../../docs/02-platform-contract.md)

必须将三方责任分开。一个可以工作的 starter 选择不会自动成为平台要求。

| 责任方 | 保证或选择的内容 |
| --- | --- |
| GCG 平台 | `/workspaces`、`/shared`、`/dev/shm`、Git checkout、GPU runtime 和 Coder agent |
| 基础镜像作者 | Linux AMD64、必需工具、UID/GID 1000 账户、有效 HOME、可选语言/toolchain |
| 项目作者 | 基础镜像、用户名、Dockerfile 软件包、Python 环境、可变 tag 或不可变 digest |

## 平台提供的持久路径

- `/workspaces` 是每个工作区的持久 SSD 根目录。Git checkout 位于
  `/workspaces/<repo-name>`。
- `/shared` 是受 quota 控制、按用户分配，并由该用户各工作区共享的持久 HDD 存储。
- `/dev/shm` 是当前 run 使用、由内存支持的临时空间。

不要在 `devcontainer.json` 中再次声明这些 mount。不要添加 `workspaceMount`、host path
或 Docker socket。

## 身份：数值 ID 固定，名称不固定

有效的工作区账户必须具有数值 UID 1000 和 primary GID 1000。`containerUser` 和
`remoteUser` 必须指向所选镜像中的这个账户。平台不固定用户名。

本 starter 的镜像使用 `ubuntu`。另一个兼容镜像可能使用 `vscode`、`coder` 或其他
名称。更换镜像时必须同时修改两个 user 字段。不要让最终容器以 root 运行。

## HOME 属于镜像

对于任意镜像，平台不会创建、挂载、修复或持久化 HOME。UID/GID 1000 账户必须将
`HOME` 设置为已经存在且可写的目录。它可以是 `/home/ubuntu`、`/home/vscode` 或其他
有效路径。

一个目录不会仅仅因为是 HOME 就自动持久。将项目文件放在 `/workspaces` 下，将跨
工作区数据放在 `/shared` 下，并将可重复的 shell 配置写入 Dockerfile。不要将
`/shared` 用作 HOME。

## 最低兼容镜像检查表

任意 public、GCG 或第三方镜像都可以使用，但必须提供以下全部内容：

- Linux AMD64 和 POSIX `/bin/sh`；
- `base64`、`mktemp`、`setpriv`、Git 和常用 core utility；
- UID 和 primary GID 都是 1000 的非 root 账户；
- 该账户的有效、可写 HOME；以及
- 不依赖 privileged mode、host mount、Docker socket 或 host device。

Python、uv、Conda 和 CUDA 编译器都是可选项。平台会注入 NVIDIA driver runtime；
不要在镜像中安装 host NVIDIA kernel driver。
