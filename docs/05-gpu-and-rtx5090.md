# GPU and RTX 5090

[Home](../README.md) | [简体中文](../zh-cn/docs/05-gpu-and-rtx5090.md)

Both GCG Dev Container Templates allocate a GPU. Do not request a GPU in
`devcontainer.json`, add device mounts or add `--gpus` options.

## Three different checks

1. `nvidia-smi` proves that the platform driver and physical GPU are visible.
2. `nvcc --version` proves that the selected image contains a CUDA toolkit.
3. A framework's own check proves that its installed build supports the
   selected toolkit and driver combination.

Only the first check is part of the platform contract. A CPU-toolchain image is
allowed even though the Template allocates a GPU.

**TERMINAL — run inside the Coder workspace:**

```bash
cd "$(git rev-parse --show-toplevel)"
sh scripts/check-environment.sh
```

If the check passes but `nvcc` is absent, select a CUDA image family. If
`nvidia-smi` and `nvcc` work but a framework reports no GPU, fix the project's
framework package. Do not modify host drivers.

## GCG Dev Container: shared RTX 4090

The ordinary Template receives one time-sliced RTX 4090 allocation. Use it for
image builds, editing, tests and moderate GPU work. Time slicing is not memory
isolation: other workspaces can consume compute and GPU memory.

Never inspect, stop or signal processes belonging to other users. If the
shared card cannot fit the workload, stop your workspace and use the approved
RTX 5090 queue.

## GCG RTX 5090 Dev Container: exclusive FIFO queue

The RTX 5090 Template requests the whole card. Only one admitted workload can
hold it. The queue is strict FIFO, has no preemption and has no estimated start
time. **Running** with an agent still **Connecting** usually means the Pod is
queued.

While queued, wait without deleting or recreating the workspace. Do not change
repository settings to skip the queue. A cold image build also occupies the
5090 after admission.

The Template allows at most 60 GiB memory and has no Pre-launch Script field.
Put repeatable system changes in Dockerfile.

## Responsible 5090 workflow

1. Build and verify the exact commit in **GCG Dev Container**.
2. Stop that shared workspace.
3. Start the RTX 5090 workspace with the same Git URL/ref and Dev Container
   directory.
4. Run only work that needs the exclusive card.
5. Save project results under `/workspaces` or cross-workspace data under
   `/shared`.
6. Stop immediately after the run finishes.

Stopping preserves persistent storage and releases the GPU. Deleting removes
that workspace's `/workspaces`. Do not run shared and RTX 5090 workspaces for
the same project at the same time.

## Never add these to the image or configuration

- NVIDIA kernel driver or NVIDIA Container Toolkit;
- Docker-in-Docker or a Docker/containerd socket;
- `NVIDIA_VISIBLE_DEVICES` overrides or `/dev/nvidia*` mounts;
- host paths or host devices; or
- privileged mode, extra capabilities or relaxed security options.

The GCG Template owns the GPU runtime configuration.
