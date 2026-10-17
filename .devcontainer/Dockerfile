# This is one known-good example for both GCG Dev Container Templates. The
# concrete mutable tag currently selects Ubuntu 24.04, CUDA 12.8 and uv.
#
# You may choose another GCG tag, pin a digest, or use any compatible Linux
# AMD64 image. Read docs/03-choose-a-base-image.md before changing this line.
FROM registry.gcg.cardiff.zhuoling.space/platform/coder/golden/ubuntu-cuda-uv:24.04-cuda12.8

# Root is used only while the image is being built.
USER root

# No extra operating-system package is installed by default. Package commands
# depend on the selected distribution; use the matching complete recipe in
# docs/04-customize-your-environment.md.

# HOME lives in the container layer and is reset on every stop/start. Point
# ~/.ssh at the per-workspace persistent disk so keys, config and known_hosts
# survive restarts. The link holds no secret; create the target once inside
# the workspace with: mkdir -m 700 /workspaces/.ssh
RUN home="$(getent passwd 1000 | cut -d: -f6)" \
    && ln -s /workspaces/.ssh "$home/.ssh" \
    && chown -h 1000:1000 "$home/.ssh"

# STOP EDITING HERE. The final effective user must have UID/GID 1000. The
# username and HOME path may differ in another compatible image.
USER 1000:1000
