# 在不泄露凭据的情况下求助

[首页](../README.md) | [English](../../docs/09-ask-for-help.md)

请发送简短而准确的报告。不要发布完整环境、完整的私有构建日志、Git 凭据、SSH key、
token、`.env` 内容或 Registry 密码。

## 请提供以下内容

1. 工作区名称。
2. 准确的 Template 名称：**GCG Dev Container** 或
   **GCG RTX 5090 Dev Container**。
3. 问题发生时的 UTC 时间。
4. `FROM` 中准确且不包含任何凭据的基础镜像 reference。
5. 该 reference 是可变 tag 还是不可变 digest。如果原本希望 tag 移动，请明确说明。
6. 所选 Git branch/tag/ref，以及修改后的 commit 是否已经推送。
7. 下方安全检查的输出。
8. 第一条相关错误的截图或简短副本，其中必须隐藏私有仓库 URL 和凭据。

**终端——如果 Coder 工作区可以打开，请在工作区内运行：**

```bash
cd "$(git rev-parse --show-toplevel)"
date -u
sh scripts/check-environment.sh
```

诊断会安全地报告用户名、UID/GID、HOME 路径、持久路径和 GPU 摘要。它不会打印全部
环境变量。

如果工作区始终无法打开，请提供自己时钟上的 UTC 时间，并且只提供第一条相关构建
错误。

## 说明发生了什么修改

指出失败发生前刚刚修改的一个文件：

- `.devcontainer/Dockerfile`；
- `.devcontainer/devcontainer.json`；
- `requirements.txt` 或其他项目依赖文件；或者
- 没有修改任何仓库文件。

如果问题与 Python 有关，请说明是否手动创建了 `.venv`，以及使用了哪一种文档
recipe。不要发送包含凭据的 clone 或 Registry login 命令。

## 如果建议要求以下任何操作，请立即停止

- 在运行中的工作区内获取 administrator 或 root 权限；
- 删除一个范围很大的目录或你无法确认用途的文件；
- 挂载 Docker/containerd socket、host path 或 host device；
- 使用 privileged mode 或额外的 Linux capability；
- 安装 NVIDIA host driver；
- 在 Git 中写入 token、密码、SSH key 或 Registry 登录信息；或者
- 下载互联网命令并立即执行。

这些操作超出了用户工作区契约。请让 GCG 管理员诊断平台，不要自己尝试。
