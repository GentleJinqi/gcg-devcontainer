# 选择基础镜像

[首页](../README.md) | [English](../../docs/03-choose-a-base-image.md)

starter 的 GCG 镜像只是一项便利选择，并不是限制。请按照这个顺序选择：操作系统、
所需的 CUDA toolkit、所需的 Python manager，最后选择可变 tag 或不可变 digest。

## 只选择确实需要的工具

| 需求 | GCG family suffix |
| --- | --- |
| 只有常用开发工具 | 无 suffix |
| 添加 uv | `-uv` |
| 添加 Conda | `-conda` 或仓库名称 `ubuntu-conda` |
| 添加 Conda 和 uv | `-conda-uv` |
| 添加 CUDA Toolkit | 使用 `cuda` 仓库族 |

`nvidia-smi` 来自平台的 NVIDIA runtime。只有 CUDA 镜像才有 `nvcc`。GPU 可见并不
要求每个项目都安装 toolkit。

默认 Dockerfile 使用以下具体可变 tag：

**文件内容——Dockerfile 的 `FROM` 行；不要在终端中运行：**

```Dockerfile
FROM registry.gcg.cardiff.zhuoling.space/platform/coder/golden/ubuntu-cuda-uv:24.04-cuda12.8
```

请查看[完整镜像矩阵](reference/image-matrix.md)，了解每一个仓库族和全部 41 个
Ubuntu/CUDA tuple。

## 支持可变 tag

可变 tag 容易阅读，并且可以移动到重新构建的内容。这种便利性以严格可复现性为代价：

- `24.04-cuda12.8` 之类的具体 tag 会保留命名的 OS/toolkit tuple，但其内容可能被
  原地重新构建；
- `recommended` 是指向广泛推荐 tuple 的移动 GCG channel；
- `latest` 是指向目录中最新 tuple 的移动 GCG channel，对某个项目而言可能过新；以及
- workspace cache hit 并不保证会察觉上游 tag 已移动。

如果要有意获取已经移动的 tag，请在 Dockerfile 的 `FROM` 附近记录这次更新，提交并
推送该修改，然后在 **GCG Dev Container** 中进行冷构建并验证。反复删除工作区不是
更新机制。

## 支持不可变 digest

当经过审查的基础镜像绝对不能移动时，请使用完整的 `@sha256:` reference。请让管理员
从 `40-coder/images/images.lock.json` 提供当前 digest。切换到新 digest 必须形成
经过审查的 Git commit。

digest 只固定基础镜像。Ubuntu/Rocky 软件包仓库和未固定版本的项目依赖，在以后的
构建中仍可能发生变化。请固定经过审查的语言依赖，并验证每一次冷构建。

## Channel 语义

| Channel | Ubuntu CPU 仓库族 | Ubuntu CUDA 仓库族 | Rocky 9 仓库族 |
| --- | --- | --- | --- |
| `recommended` | Ubuntu 24.04 | Ubuntu 24.04 + CUDA 12.8 | Rocky 9 镜像 tag `9-v2` |
| `latest` | Ubuntu 26.04 | Ubuntu 26.04 + CUDA 13.3 | Rocky 9 镜像 tag `9-v2` |
| 版本 tag | `20.04`、`22.04`、`24.04`、`26.04` | `<ubuntu>-cuda<cuda>` | `9-v2` |

对于 Rocky，`9-v2` 表示 Rocky Linux major version 9 使用第 2 代 GCG 镜像 recipe。
它**不**表示 Rocky Linux 9.2。Rocky alias `9`、`recommended` 和 `latest` 当前都解析
到 `9-v2`。

## 使用任意兼容镜像

Dockerfile 可以使用 public 镜像、其他 GCG 镜像或第三方 Registry 中的镜像。它必须
通过[平台契约](02-platform-contract.md)中的检查表。尤其是，它必须提供 UID/GID
1000 账户、有效可写 HOME、POSIX shell 和必需工具。

第三方私有 Registry 需要管理员单独配置认证。平台的 GCG Registry 凭据不能访问其他
Registry。绝对不要把 Registry 密码写入 Git、Dockerfile build arg 或
`devcontainer.json`。

不要通过添加 host NVIDIA driver、Docker-in-Docker、device mount、privileged mode
或 host path 来强行启动不兼容的镜像。
