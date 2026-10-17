# 完整 GCG 镜像矩阵

[首页](../../README.md) | [选择镜像](../03-choose-a-base-image.md) | [English](../../../docs/reference/image-matrix.md)

GCG 目录包含 12 个面向用户的仓库族：8 个 Ubuntu 仓库族和 4 个 Rocky Linux 9
仓库族。Ubuntu 目录展开后共有 180 个镜像：4 个 CPU 仓库族各有 4 个 CPU tag，
再加上 4 个 CUDA 仓库族各有 41 个 CUDA tuple。Rocky 另外提供 4 个镜像。

以下每一行使用的 Registry prefix：

```text
registry.gcg.cardiff.zhuoling.space/platform/coder/golden/
```

## 12 个仓库族

| Prefix 后的仓库 | OS | 包含的可选工具 |
| --- | --- | --- |
| `ubuntu` | Ubuntu | 常用开发工具 |
| `ubuntu-uv` | Ubuntu | 常用工具 + uv |
| `ubuntu-conda` | Ubuntu | 常用工具 + Conda |
| `ubuntu-conda-uv` | Ubuntu | 常用工具 + Conda + uv |
| `ubuntu-cuda` | Ubuntu | 常用工具 + CUDA Toolkit |
| `ubuntu-cuda-uv` | Ubuntu | 常用工具 + CUDA Toolkit + uv |
| `ubuntu-conda-cuda` | Ubuntu | 常用工具 + Conda + CUDA Toolkit |
| `ubuntu-conda-cuda-uv` | Ubuntu | 常用工具 + Conda + CUDA Toolkit + uv |
| `rocky` | Rocky Linux 9 | 常用开发工具 |
| `rocky-uv` | Rocky Linux 9 | 常用工具 + uv |
| `rocky-conda` | Rocky Linux 9 | 常用工具 + Conda |
| `rocky-conda-uv` | Rocky Linux 9 | 常用工具 + Conda + uv |

每个兼容的 GCG 镜像还会提供平台要求的 UID/GID 1000 账户和工具。上表的工具列说明
可选的附加工具。

## Ubuntu CPU tag

4 个 Ubuntu CPU 仓库族中的每一个都具有全部 4 个具体 tag。

| Ubuntu release | 具体可变 tag |
| --- | --- |
| 20.04 | `20.04` |
| 22.04 | `22.04` |
| 24.04 | `24.04` |
| 26.04 | `26.04` |

对于全部 4 个 CPU 仓库族，`recommended` 当前指向 `24.04`，`latest` 当前指向
`26.04`。

## 全部 41 个 Ubuntu/CUDA tuple

每一行都存在于全部 4 个 CUDA 仓库族中。具体可变 tag 是 Ubuntu release 后接
`-cuda` 和 CUDA version。

| Ubuntu | CUDA | 具体可变 tag |
| --- | --- | --- |
| 20.04 | 11.0 | `20.04-cuda11.0` |
| 20.04 | 11.1 | `20.04-cuda11.1` |
| 20.04 | 11.2 | `20.04-cuda11.2` |
| 20.04 | 11.3 | `20.04-cuda11.3` |
| 20.04 | 11.4 | `20.04-cuda11.4` |
| 20.04 | 11.5 | `20.04-cuda11.5` |
| 20.04 | 11.6 | `20.04-cuda11.6` |
| 20.04 | 11.7 | `20.04-cuda11.7` |
| 20.04 | 11.8 | `20.04-cuda11.8` |
| 20.04 | 12.0 | `20.04-cuda12.0` |
| 20.04 | 12.1 | `20.04-cuda12.1` |
| 20.04 | 12.2 | `20.04-cuda12.2` |
| 20.04 | 12.3 | `20.04-cuda12.3` |
| 20.04 | 12.4 | `20.04-cuda12.4` |
| 20.04 | 12.5 | `20.04-cuda12.5` |
| 20.04 | 12.6 | `20.04-cuda12.6` |
| 20.04 | 12.8 | `20.04-cuda12.8` |
| 20.04 | 12.9 | `20.04-cuda12.9` |
| 22.04 | 11.7 | `22.04-cuda11.7` |
| 22.04 | 11.8 | `22.04-cuda11.8` |
| 22.04 | 12.1 | `22.04-cuda12.1` |
| 22.04 | 12.2 | `22.04-cuda12.2` |
| 22.04 | 12.3 | `22.04-cuda12.3` |
| 22.04 | 12.4 | `22.04-cuda12.4` |
| 22.04 | 12.5 | `22.04-cuda12.5` |
| 22.04 | 12.6 | `22.04-cuda12.6` |
| 22.04 | 12.8 | `22.04-cuda12.8` |
| 22.04 | 12.9 | `22.04-cuda12.9` |
| 22.04 | 13.0 | `22.04-cuda13.0` |
| 22.04 | 13.1 | `22.04-cuda13.1` |
| 22.04 | 13.2 | `22.04-cuda13.2` |
| 22.04 | 13.3 | `22.04-cuda13.3` |
| 24.04 | 12.5 | `24.04-cuda12.5` |
| 24.04 | 12.6 | `24.04-cuda12.6` |
| 24.04 | 12.8 | `24.04-cuda12.8` |
| 24.04 | 12.9 | `24.04-cuda12.9` |
| 24.04 | 13.0 | `24.04-cuda13.0` |
| 24.04 | 13.1 | `24.04-cuda13.1` |
| 24.04 | 13.2 | `24.04-cuda13.2` |
| 24.04 | 13.3 | `24.04-cuda13.3` |
| 26.04 | 13.3 | `26.04-cuda13.3` |

对于全部 4 个 CUDA 仓库族，`recommended` 当前指向 `24.04-cuda12.8`，`latest`
当前指向 `26.04-cuda13.3`。

## Rocky Linux 9 tag

全部 4 个 Rocky 仓库族使用具体 tag `9-v2`。alias `9`、`recommended` 和 `latest`
当前都指向该 tag。这里的 `v2` 是 GCG 镜像 recipe generation；`9-v2` 并不表示
Rocky Linux 9.2。

## Tag、digest 和兼容性

上面的所有 tag 都是可变的。对于绝对不能移动的基础镜像，请让管理员提供记录在
`40-coder/images/images.lock.json` 中的对应 `@sha256:` reference。

目录中存在某个组合，并不能证明特定 framework 支持该 OS/CUDA/GPU 组合。请先检查
framework 要求，然后在使用 RTX 5090 之前，在 **GCG Dev Container** 中测试准确的
commit。

这 12 个仓库只是便利镜像，不是 allowlist。任何其他 Linux AMD64 镜像只要满足 GCG
平台契约，也可以使用。
