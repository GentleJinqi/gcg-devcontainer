# 故障排查

[首页](../README.md) | [English](../../docs/08-troubleshooting.md)

不要通过添加管理员权限、privileged mode、host mount、Docker socket、device mount
或 Registry 凭据来修复工作区。请在下面找到相符的现象，并修正仓库源文件。

## 工作区无法打开

### RTX 5090 显示 Running，但 agent 显示 Connecting

它很可能正在 FIFO GPU 队列中等待。请等待。删除后重新创建会失去队列位置，并且删除
会移除该工作区的 `/workspaces`。

### 构建找不到 `devcontainer.json` 或 Dockerfile

确认所选 Git ref 包含 `.devcontainer/devcontainer.json`，以及
`build.dockerfile` 引用的文件。Coder directory 字段必须准确填写 `.devcontainer`。
启动前必须提交并推送隐藏文件。

### 无法 clone 私有 HTTP(S) Git 仓库

将 **Git Repository** 保持为干净 URL。在 **Git HTTP username** 和
**Git HTTP password** 中填入服务商要求的 username/password 或 token。这些字段被
有意设置为未遮罩，并会持久保存在受信的 Coder/Terraform state 和 workspace Pod
specification 中。不要将凭据嵌入 URL 或仓库。

### 构建无法拉取基础镜像

检查镜像矩阵中的准确 `FROM` 拼写和 tag。第三方私有 Registry 需要管理员配置认证。
绝对不要把 Registry 用户名或密码写入 Git、Dockerfile 或 Git HTTP 凭据字段；这些
字段用于认证 Git，而不是镜像 Registry。

### 构建显示缺少 `setpriv`、`base64`、`mktemp` 或 `/bin/sh`

所选镜像不满足最低契约。请选择兼容镜像，或在镜像构建期间添加必需工具。不要在
Pre-launch Script 中安装它们。

## 工作区可以打开，但契约检查失败

### UID 或 GID 不是 1000

`containerUser` 和 `remoteUser` 没有指向必需账户，或者镜像使用了不同数值 ID 创建
该账户。请修复镜像和两个 user 字段。不要运行递归 ownership 或 permission 命令。

### HOME 未设置、不存在或不可写

镜像必须为其 UID/GID 1000 账户设置 HOME，并使用正确 ownership 创建该目录。HOME
不需要是 `/home/ubuntu`。请修复 Dockerfile；不要将 HOME 重定向到 `/shared`。

### `/workspaces` 或 `/shared` 不存在或不可写

删除仓库定义的 `workspaceMount`、`mounts` 和 host path。两个持久 mount 都由平台
管理。如果未修改的 starter 仍然失败，请联系管理员。

### `nvidia-smi` 失败

不要修改仓库文件，先重新启动一次。如果仍然失败，请报告工作区名称和 UTC 时间。
不要安装 driver，也不要添加 device mount。

## 缺少可选项目工具

### 缺少 Python、uv、Conda 或 `nvcc`

请在镜像矩阵中查看所选仓库族。这些工具是可选镜像选择，并不是平台要求。请选择匹配
的仓库族，或在 Dockerfile 中添加经过审查的发行版软件包。

### 缺少 `.venv`

starter 不自动创建 `.venv`。如果项目使用 Python，请严格按照
[自定义环境](04-customize-your-environment.md)中的一种手动 recipe 操作。

### `.venv` 使用错误的 Python 或包含已经移除的软件包

使用 File Browser 重命名 `.venv`，手动创建新环境，并在删除已重命名目录之前完成
验证。绝对不要复制批量删除命令。

## 镜像或文件看起来没有更新

### 可变 tag 已移动，但工作区没有改变

cache hit 可能继续使用为现有 Git commit 构建的镜像。请在 Dockerfile 的 `FROM`
附近记录这次预期更新，提交并推送该修改，然后在共享 Template 中验证产生的冷构建。
反复删除工作区不是更新机制。

### 在终端安装的工具重启后消失

运行中的 root filesystem 和任意 HOME 都没有平台持久保证。将系统工具写入
Dockerfile，将项目文件放在 `/workspaces` 下，将跨工作区数据放在 `/shared` 下。

### 已推送的配置修改被忽略

确认 Coder 的 Git Repository 字段选择了包含新 commit 的 ref，并且 Dev Container
目录是 `.devcontainer`。尚未推送的文件无法影响 Envbuilder。

## 存储已满

**终端——在 Coder 工作区内运行：**

```bash
df -h /workspaces /shared /dev/shm
```

使用 File Browser，并且只删除你能确认用途的文件。绝对不要运行从论坛、聊天或模型
回答中复制的批量删除命令。

## 运行安全诊断

**终端——在 Coder 工作区内运行：**

```bash
cd "$(git rev-parse --show-toplevel)"
sh scripts/check-environment.sh
```

此脚本不会修改工作区，不要求可选项目工具，也不会打印完整环境。只分享它的输出和
第一条相关构建错误。
