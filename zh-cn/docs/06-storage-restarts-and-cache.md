# 存储、重启和镜像缓存

[首页](../README.md) | [English](../../docs/06-storage-restarts-and-cache.md)

最重要的规则是：**停止会保留持久数据；删除工作区会删除其按工作区分配的存储。**
持久存储仍然不是备份。

| 路径 | 所有者和用途 | Stop/start | 删除工作区 |
| --- | --- | --- | --- |
| `/workspaces` | 每个工作区 50 GiB CephFS SSD；Git checkout 和可选 `.venv` | 保留 | 删除 |
| `/shared` | 受 quota 控制、按用户分配，并由该用户各工作区共享的 CephFS HDD | 保留 | 保留 |
| `/dev/shm` | 当前 run 使用、由内存支持的临时空间 | 重新创建 | 重新创建 |
| `$HOME` | 由所选镜像提供 | 只有被有意放在持久 mount 上才会持久 | 没有单独的平台保证 |
| 其他 root filesystem 路径 | 容器镜像 layer 和当前 Pod 修改 | 从镜像重新创建 | 重新创建 |

`/dev/shm` 的大小上限等于 Coder 表单中选择的内存。不要在那里保存需要长期保留的
checkpoint。

## 文件应该放在哪里

- 将源代码和小型配置提交到 Git。
- 将 checkout 和可选的手动 `.venv` 放在 `/workspaces` 下。
- 如果 quota 允许，将大型数据集和跨工作区结果放在 `/shared` 下。
- 将可重复的 shell 配置和系统软件包写入 Dockerfile。

不要假设任意 HOME 会持久。镜像必须创建 HOME，但平台只持久化其声明的 mount。不要
将 `/shared` 用作 HOME。

## Template 注入的持久化工具默认值

Dev Container Template 会把以下默认值注入构建 lifecycle command 和用户 session：

| 变量 | 默认路径 | 使用者 |
| --- | --- | --- |
| `PIP_CACHE_DIR` | `/workspaces/.cache/pip` | pip 下载和 wheel 缓存 |
| `UV_CACHE_DIR` | `/workspaces/.cache/uv` | uv 软件包缓存 |
| `HF_HOME` | `/workspaces/.cache/huggingface` | Hugging Face 模型、数据集和元数据 |
| `CONDA_ENVS_PATH` | `/workspaces/.conda/envs` | 命名 Conda 环境 |
| `CONDA_PKGS_DIRS` | `/workspaces/.cache/conda/pkgs` | Conda 软件包缓存 |

这些目录位于 `/workspaces` 下，因此 stop/start 和容器替换会保留它们。删除工作区会
删除它们。它们不会与其他工作区共享，也不是备份。

这些是方便用户的默认值，并不是限制。仓库可以在 `devcontainer.json` 或自己的
lifecycle/shell 配置中覆盖任意变量。请把手动创建的项目 `.venv` 放在仓库 checkout
中；Template 不会替你创建 `.venv`。如果大型缓存需要被你的多个工作区共用，请先
确认 quota，再有意选择 `/shared` 下的路径。

## 镜像缓存不是用户存储

镜像缓存保存已经构建的环境；它不包含 `/workspaces` 或 `/shared` 的实时内容。缓存
key 包含仓库 URL、Dev Container 目录、解析后的 Git commit、cache schema 和
Envbuilder 版本。

- 新 Git commit 会按设计创建新的 cache key；
- stop/start 可以复用已经存在的构建镜像；
- 删除工作区不表示 Registry cache 已被删除；并且
- 上游可变 tag 可以移动，同时 cache hit 仍使用之前构建的结果。

如果要有意重新解析可变基础 tag，请在 Dockerfile 的 `FROM` 附近记录这次更新，提交
并推送该修改，然后在共享 Template 中验证冷构建。新的平台 Golden Image release
也会自动使相关缓存失效。不要反复删除并重新创建工作区。

## 在不删除任何内容的情况下检查容量

**终端——在 Coder 工作区内运行：**

```bash
df -h /workspaces /shared
```

如果存储已满，请使用 File Browser 检查已知文件夹，并且只删除你本人可以确认用途的
文件。绝对不要粘贴帖子、聊天或 AI 回答中的批量清理命令。如果不清楚文件属于谁，
请联系管理员。
