# Complete GCG image matrix

[Home](../../README.md) | [Choose an image](../03-choose-a-base-image.md) | [简体中文](../../zh-cn/docs/reference/image-matrix.md)

The GCG catalog contains 12 user-facing repository families: eight Ubuntu
families and four Rocky Linux 9 families. The Ubuntu catalog expands to 180
images: four CPU tags across four CPU families, plus 41 CUDA tuples across four
CUDA families. Rocky adds four images.

Registry prefix for every row below:

```text
registry.gcg.cardiff.zhuoling.space/platform/coder/golden/
```

## The 12 repository families

| Repository after the prefix | OS | Included choice |
| --- | --- | --- |
| `ubuntu` | Ubuntu | Common developer tools |
| `ubuntu-uv` | Ubuntu | Common tools + uv |
| `ubuntu-conda` | Ubuntu | Common tools + Conda |
| `ubuntu-conda-uv` | Ubuntu | Common tools + Conda + uv |
| `ubuntu-cuda` | Ubuntu | Common tools + CUDA Toolkit |
| `ubuntu-cuda-uv` | Ubuntu | Common tools + CUDA Toolkit + uv |
| `ubuntu-conda-cuda` | Ubuntu | Common tools + Conda + CUDA Toolkit |
| `ubuntu-conda-cuda-uv` | Ubuntu | Common tools + Conda + CUDA Toolkit + uv |
| `rocky` | Rocky Linux 9 | Common developer tools |
| `rocky-uv` | Rocky Linux 9 | Common tools + uv |
| `rocky-conda` | Rocky Linux 9 | Common tools + Conda |
| `rocky-conda-uv` | Rocky Linux 9 | Common tools + Conda + uv |

Every compatible GCG image also provides the platform-required UID/GID 1000
account and utilities. The tool columns above describe optional additions.

## Ubuntu CPU tags

Each of the four Ubuntu CPU families has all four concrete tags.

| Ubuntu release | Concrete mutable tag |
| --- | --- |
| 20.04 | `20.04` |
| 22.04 | `22.04` |
| 24.04 | `24.04` |
| 26.04 | `26.04` |

For all four CPU families, `recommended` currently points to `24.04` and
`latest` currently points to `26.04`.

## All 41 Ubuntu/CUDA tuples

Every row exists in all four CUDA repository families. The concrete mutable
tag is the Ubuntu release followed by `-cuda` and the CUDA version.

| Ubuntu | CUDA | Concrete mutable tag |
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

For all four CUDA families, `recommended` currently points to
`24.04-cuda12.8` and `latest` currently points to `26.04-cuda13.3`.

## Rocky Linux 9 tags

All four Rocky families use concrete tag `9-v2`. The aliases `9`,
`recommended` and `latest` currently point to that tag. Here, `v2` is the GCG
image recipe generation; `9-v2` does not mean Rocky Linux 9.2.

## Tags, digests and compatibility

All tags above are mutable. For a base that must not move, ask an administrator
for the corresponding `@sha256:` reference recorded in
`40-coder/images/images.lock.json`.

Catalog availability does not prove that a particular framework supports that
OS/CUDA/GPU combination. Check the framework requirement, then test the exact
commit in **GCG Dev Container** before using RTX 5090.

These 12 repositories are convenience images, not an allowlist. Any other
Linux AMD64 image may be used when it satisfies the GCG platform contract.
