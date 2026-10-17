# GPU 和 RTX 5090

[首页](../README.md) | [English](../../docs/05-gpu-and-rtx5090.md)

两种 GCG Dev Container Template 都会分配 GPU。不要在 `devcontainer.json` 中请求
GPU，不要添加 device mount，也不要添加 `--gpus` 选项。

## 三种不同的检查

1. `nvidia-smi` 证明平台 driver 和物理 GPU 可见。
2. `nvcc --version` 证明所选镜像包含 CUDA toolkit。
3. framework 自身的检查证明其已安装 build 支持所选 toolkit 和 driver 组合。

只有第一项检查属于平台契约。即使 Template 分配 GPU，也允许使用只有 CPU toolchain
的镜像。

**终端——在 Coder 工作区内运行：**

```bash
cd "$(git rev-parse --show-toplevel)"
sh scripts/check-environment.sh
```

如果检查通过但缺少 `nvcc`，请选择 CUDA 镜像族。如果 `nvidia-smi` 和 `nvcc` 正常，
但 framework 报告没有 GPU，请修正项目的 framework 软件包。不要修改 host driver。

## GCG Dev Container：共享 RTX 4090

普通 Template 会获得一个分时共享的 RTX 4090 配额。请用它构建镜像、编辑、测试以及
处理中等规模的 GPU 工作。分时共享并不提供显存隔离：其他工作区可能会消耗计算资源
和 GPU 显存。

绝对不要检查、停止属于其他用户的进程或向它们发送 signal。如果共享显卡无法容纳
工作负载，请停止自己的工作区并使用经过批准的 RTX 5090 队列。

## GCG RTX 5090 Dev Container：独占 FIFO 队列

RTX 5090 Template 会请求整张显卡。同一时刻只能有一个已经准入的工作负载持有它。
队列严格按照 FIFO 运行，不会抢占，也没有预计开始时间。工作区显示 **Running**，
同时 agent 仍为 **Connecting**，通常表示 Pod 正在排队。

排队时请等待，不要删除或重新创建工作区。不要通过更改仓库设置来跳过队列。冷镜像
构建在准入后也会占用 5090。

该 Template 最多允许 60 GiB 内存，并且没有 Pre-launch Script 字段。请将可重复的
系统修改写入 Dockerfile。

## 负责任地使用 5090

1. 在 **GCG Dev Container** 中构建并验证准确的 commit。
2. 停止该共享工作区。
3. 使用相同的 Git URL/ref 和 Dev Container 目录启动 RTX 5090 工作区。
4. 只运行需要独占显卡的工作。
5. 将项目结果保存到 `/workspaces`，将跨工作区数据保存到 `/shared`。
6. 运行结束后立即停止。

停止会保留持久存储并释放 GPU。删除会移除该工作区的 `/workspaces`。不要同时运行
同一项目的共享工作区和 RTX 5090 工作区。

## 绝对不要添加到镜像或配置的内容

- NVIDIA kernel driver 或 NVIDIA Container Toolkit；
- Docker-in-Docker 或 Docker/containerd socket；
- `NVIDIA_VISIBLE_DEVICES` override 或 `/dev/nvidia*` mount；
- host path 或 host device；或者
- privileged mode、额外 capability 或放宽的 security option。

GPU runtime 配置由 GCG Template 管理。
