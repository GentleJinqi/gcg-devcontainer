# GCG Dev Container 入门仓库

[English](../README.md)

> **第一次创建工作区时，请原样使用本仓库。** 不要运行 VS Code 的
> **Add Dev Container Configuration Files（添加 Dev Container 配置文件）**命令。
> 如果帖子或 AI 回答要求获取管理员权限、删除大量文件、挂载 Docker socket 或设备，
> 或者索要 Registry 密码，请勿粘贴其中的命令。请立即停止并联系 GCG 管理员。

本 starter 选择了一种已验证的 GCG 镜像。这并**不**表示该镜像、`ubuntu` 用户名、
Python、CUDA Toolkit、uv 或 `/home/ubuntu` 是平台要求。你可以使用任意兼容的 Linux
AMD64 基础镜像。

## 契约概览

| 平台保证 | 你选择的镜像必须保证 |
| --- | --- |
| 位于 50 GiB 工作区根目录 `/workspaces` 下的 Git checkout | 一个数值 UID 为 1000、primary GID 为 1000 的非 root 账户 |
| 位于 `/shared` 的按用户共享存储 | `HOME` 指向一个已经存在且可写的目录 |
| 位于 `/dev/shm`、由内存支持的临时存储 | POSIX `/bin/sh`、`base64`、`mktemp`、`setpriv`、Git 和常用 core utility |
| GPU 分配、NVIDIA runtime 和 Coder agent | 项目需要的任意可选工具，例如 Python、uv、Conda 或 `nvcc` |

账户名称和 HOME 路径来自镜像。本示例镜像将该账户命名为 `ubuntu`，但另一个兼容镜像
可能将其命名为 `vscode`、`coder` 或其他名称。数值 UID/GID 仍必须是 `1000:1000`。

## 第一个工作区：安全路径

1. 将此文件夹的**全部内容**发布为一个 Git 仓库。必须保留隐藏的 `.devcontainer`
   目录。
2. 创建工作区前必须提交并推送。Coder 无法读取你电脑上尚未推送的文件。
3. 在 Coder 中，首先选择 **GCG Dev Container** 并使用以下值：

   | 字段 | 值 |
   | --- | --- |
   | Git Repository | 干净的 clone URL；绝对不能包含密码 |
   | Git HTTP username/password | 仅用于私有 HTTP(S) 仓库；public 或 SSH 仓库两项都留空 |
   | Dev Container directory | `.devcontainer` |
   | CPU cores | `8` |
   | Memory | `60 GiB` |
   | Pre-launch Script | 完全留空 |

4. 等待 Coder agent 连接。第一次构建可能需要几分钟。
5. **终端——在 Coder 工作区内运行：**

   ```bash
   cd "$(git rev-parse --show-toplevel)"
   sh scripts/check-environment.sh
   ```

   最后一行必须是 `OK: the GCG Dev Container contract is satisfied.`

对于私有 HTTP(S) 仓库，两个 Git HTTP 凭据字段是普通、未遮罩、持久的 Template
参数。这是有意设计：为供 cache lookup 和 Envbuilder 使用，它们会存入受信的
Coder/Terraform state 和 workspace Pod specification。绝对不要将它们嵌入 Git URL
或仓库。

只有检查通过后，才停止共享工作区，并使用完全相同的 Git URL/ref 和 Dev Container
目录创建 **GCG RTX 5090 Dev Container**。这样通常可以让 5090 工作区复用镜像缓存，
避免独占 GPU 被冷构建占用。

## 选择、自定义和保存

- 选择一个 GCG 可变 tag、固定 digest，或使用其他兼容镜像：
  [选择基础镜像](docs/03-choose-a-base-image.md)。
- 添加系统工具，并按需自己创建 Python `.venv`：
  [自定义环境](docs/04-customize-your-environment.md)。
- 将项目文件和手动创建的 `.venv` 保存在 `/workspaces` 下的 checkout 中。
- Template 默认将 pip、uv、Hugging Face 和 Conda 缓存，以及命名 Conda 环境保存在
  `/workspaces` 下。确切的注入变量和覆盖方法见
  [存储、重启和镜像缓存](docs/06-storage-restarts-and-cache.md)。
- 将跨工作区的大型数据保存在 `/shared` 下。
- 不要假设 HOME 是持久的。镜像提供 HOME；只有声明的持久路径有平台存储保证。

绝对不要在 Dockerfile、`devcontainer.json`、requirements 文件或 Git 中写入密码、
token、SSH key、`.env` 内容或 Registry 凭据。私有 HTTPS Git 凭据只能填入 Coder
表单中为它们指定的字段。

## 接下来阅读

1. [创建第一个工作区](docs/01-first-workspace.md)
2. [了解平台契约](docs/02-platform-contract.md)
3. [选择基础镜像](docs/03-choose-a-base-image.md)
4. [自定义环境](docs/04-customize-your-environment.md)
5. [安全使用 GPU 和 RTX 5090](docs/05-gpu-and-rtx5090.md)
6. [了解存储、重启和缓存](docs/06-storage-restarts-and-cache.md)
7. [受支持和不受支持的设置](docs/07-supported-and-unsupported.md)
8. [排查工作区故障](docs/08-troubleshooting.md)
9. [在不泄露凭据的情况下求助](docs/09-ask-for-help.md)
10. [浏览完整的 GCG 镜像矩阵](docs/reference/image-matrix.md)
