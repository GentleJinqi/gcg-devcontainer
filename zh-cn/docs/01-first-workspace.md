# 创建第一个工作区

[首页](../README.md) | [English](../../docs/01-first-workspace.md)

本流程会先证明仓库和所选镜像满足平台契约，之后才允许任何人等待 RTX 5090。

## 打开 Coder 之前

所选 Git ref 必须包含 `.devcontainer/devcontainer.json`。本 starter 会构建
`.devcontainer/Dockerfile`，因此该文件也必须提交。可选的 `requirements.txt` 和
诊断脚本属于本 starter，并不是平台要求。

在 Linux 和 macOS 上，`.devcontainer` 目录会因为名称以点号开头而被隐藏。请在
Git 服务网页中检查。只在自己电脑上看到它是不够的。

不要使用 VS Code 的 Dev Container 生成器。如果它已经生成了文件，请在第一次测试
时用本 starter 替换整个生成的 `.devcontainer` 目录。不要合并未知的 mount、Compose
或 host access 设置。

## 创建工作区

1. 打开 Coder 并选择 **GCG Dev Container**。
2. 将干净的 clone URL 填入 **Git Repository**。绝对不要在该 URL 中嵌入密码。SSH
   会使用由 Coder 管理的 SSH key。
3. 对于私有 HTTP(S) 仓库，请在 **Git HTTP username** 和 **Git HTTP password** 中
   填入服务商要求的 username/password 或 token。public 或 SSH 仓库两项都留空。
4. 在 **Dev Container directory** 中准确输入 `.devcontainer`。不要以 `/` 开头。
5. 选择 8 个 CPU core 和 60 GiB 内存。
6. 将 **Pre-launch Script** 完全留空。
7. 创建工作区并等待。不要为了加速冷构建而创建第二个工作区。

Git HTTP username 和 password 是普通、未遮罩、持久的 Template 参数。为使 cache
lookup 和 Envbuilder 能够 clone 仓库，它们的值会被有意存入受信的
Coder/Terraform state 和 workspace Pod specification。登录前，它们会从 Coder
agent environment 中移除。绝对不要将它们写入 URL、仓库文件或 Dockerfile。

## 只验证平台契约

**终端——在 Coder 工作区内运行：**

```bash
cd "$(git rev-parse --show-toplevel)"
sh scripts/check-environment.sh
```

检查要求 UID/GID 1000、镜像提供的有效 HOME、可写的 `/workspaces`、`/shared` 和
`/dev/shm`、平台工具以及一张可见的 GPU。它特意不要求 Python、uv、Conda、`nvcc`
或 `.venv`。

有效结果会以下面这行结束：

```text
OK: the GCG Dev Container contract is satisfied.
```

如果没有出现这一行，请使用[故障排查](08-troubleshooting.md)。不要使用管理员命令
修补正在运行的容器。

## 只有确实需要时才转到 RTX 5090

先停止验证通过的共享工作区。然后使用相同的仓库 URL/ref 和 `.devcontainer` 目录
创建 **GCG RTX 5090 Dev Container**。两个 Template 会为这些完全相同的输入共享
镜像缓存。

RTX 5090 工作区可能显示 **Running**，同时 agent 显示 **Connecting**。它通常正在
FIFO 队列中等待。删除并重新创建会失去队列位置；删除还会移除该工作区的
`/workspaces` 存储。

## 以后选择 Git ref

Git Repository 字段接受在 URL 后添加 `#` 以及分支、tag 或完整 Git ref。在 Coder
表单中选择 ref；绝对不要粘贴指向别人仓库的文档 URL。每一项环境修改都必须先提交并
推送，再执行 stop/start。
