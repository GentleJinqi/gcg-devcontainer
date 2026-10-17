# 自定义环境

[首页](../README.md) | [English](../../docs/04-customize-your-environment.md)

每次只做一项小修改，提交、推送，然后在普通共享工作区中执行冷构建。每次修改镜像后
都运行安全诊断。不要合并多项未经测试的 recipe。

## 明确由哪个文件管理修改

| 修改 | 文件或操作 |
| --- | --- |
| 基础 OS、系统库或编译器 | `.devcontainer/Dockerfile` |
| 镜像账户名称 | `.devcontainer/devcontainer.json` 中的两个 user 字段 |
| 公开环境值 | `devcontainer.json` 中的 `containerEnv` |
| Python 软件包 | 可选的 `requirements.txt` 和手动创建的 `.venv` |
| 大型或跨工作区数据 | `/shared`，绝对不能放进镜像或 Git |

## 向示例 Ubuntu 镜像添加软件包

软件包命令与发行版有关。下面的完整 Dockerfile 只向基于 Ubuntu/Debian 的示例添加
`ffmpeg`。

**文件内容——`.devcontainer/Dockerfile`；不要在终端中运行：**

```Dockerfile
FROM registry.gcg.cardiff.zhuoling.space/platform/coder/golden/ubuntu-cuda-uv:24.04-cuda12.8

USER root

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      ffmpeg \
    && apt-get clean

USER 1000:1000
```

不要将 `apt-get` 粘贴到 Rocky 镜像或运行中的工作区。不要添加未知软件包仓库，也不要
使用下载后立即运行的 installer。

## 向 Rocky 镜像添加软件包

下面是 Rocky Linux 9 的另一份完整示例。它会添加 `strace`。

**文件内容——`.devcontainer/Dockerfile`；不要在终端中运行：**

```Dockerfile
FROM registry.gcg.cardiff.zhuoling.space/platform/coder/golden/rocky-uv:9-v2

USER root

RUN dnf install -y strace \
    && dnf clean all

USER 1000:1000
```

GCG Rocky 账户名为 `rocky`。使用该镜像时，请将 `containerUser` 和 `remoteUser` 都
改为 `rocky`。不要混用 Ubuntu 和 Rocky 软件包示例。

## 使用 uv 手动创建 `.venv`

默认示例镜像包含 Python 和 uv。平台不会替你创建、激活、验证或删除 `.venv`。

先审查 `requirements.txt`，然后自己运行完整的配置流程。

**终端——在 Coder 工作区内运行：**

```bash
cd "$(git rev-parse --show-toplevel)"
uv venv --python /usr/bin/python3 .venv
uv pip install --python .venv/bin/python --requirement requirements.txt
uv pip check --python .venv/bin/python
```

明确使用 `.venv/bin/python`，或在自己的 shell session 中激活它。因为 `.venv` 位于
`/workspaces` 下的 checkout 中，所以 stop/start 会保留它，删除工作区会删除它。

从 `requirements.txt` 删除一行，不会卸载 `.venv` 中已经存在的软件包。如果必须
移除软件包或更改 Python 版本，请使用 File Browser 重命名 `.venv`，用上述命令创建
新环境并进行验证，然后再决定如何处理已重命名的目录。不要使用批量删除命令。

## 使用标准 Python 创建 `.venv`

只有在所选镜像提供 `python3`、标准 `venv` module 和 pip 时，才能使用以下替代
方案。不要对同一个 `.venv` 同时运行两种 recipe。

**终端——在 Coder 工作区内运行：**

```bash
cd "$(git rev-parse --show-toplevel)"
python3 -m venv .venv
.venv/bin/python -m pip install --requirement requirements.txt
.venv/bin/python -m pip check
```

如果缺少某条命令，请选择提供该工具的镜像族，或者在 Dockerfile 中添加与发行版匹配
的软件包。不要在运行中的工作区内使用管理员命令安装缺失的系统工具。

## 添加非机密环境变量

只能提交可以安全公开的值。在 user 字段后，向
`.devcontainer/devcontainer.json` 添加一个 `containerEnv` object。

**文件内容——JSON 属性；不要在终端中运行：**

```json
"containerEnv": {
  "PYTHONUNBUFFERED": "1"
}
```

请在前一个 JSON 属性末尾添加所需的逗号。绝对不要在 `containerEnv`、Dockerfile
`ENV`、Dockerfile `ARG` 或生命周期命令中写入密码、token、SSH key 或包含凭据的
私有 Registry URL。

## 每次修改镜像后

1. 审查 diff 并确认其中不包含凭据。
2. 提交并推送到 Coder 所选的 ref。
3. 对 **GCG Dev Container** 执行 stop/start。
4. **终端——在 Coder 工作区内运行：**

   ```bash
   cd "$(git rev-parse --show-toplevel)"
   sh scripts/check-environment.sh
   ```

5. 只有在共享工作区测试通过后，才使用 RTX 5090。
