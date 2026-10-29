# Based on the starter's known-good example for both GCG Dev Container
# Templates. The conda family is used so /opt/conda matches gcg-standard: the
# shared venvs in /home/ubuntu/shared/venvs use /opt/conda/bin/python3.12 as
# their base interpreter. The tag selects Ubuntu 24.04, CUDA 12.8, conda and uv.
#
# You may choose another GCG tag, pin a digest, or use any compatible Linux
# AMD64 image. Read docs/03-choose-a-base-image.md before changing this line.
FROM registry.gcg.cardiff.zhuoling.space/platform/coder/golden/ubuntu-conda-cuda-uv:24.04-cuda12.8

# Root is used only while the image is being built.
USER root

# No extra operating-system package is installed by default. Package commands
# depend on the selected distribution; use the matching complete recipe in
# docs/04-customize-your-environment.md.

# HOME lives in the container layer and is reset on every stop/start, so:
# - ~/.ssh and ~/.claude point at the per-workspace persistent disk. The
#   targets are created by postCreateCommand in devcontainer.json.
# - /home/ubuntu/shared points at /shared, so the shared disk has the same path
#   as on gcg-standard and venvs, scripts and configs work on both.
# - ~/.bashrc loads the shared settings before its interactive-only guard.
# None of these links or lines hold a secret.
RUN home="$(getent passwd 1000 | cut -d: -f6)" \
    && ln -s /workspaces/.ssh "$home/.ssh" \
    && ln -s /workspaces/.claude "$home/.claude" \
    && mkdir -p /home/ubuntu \
    && ln -s /shared /home/ubuntu/shared \
    && chown -h 1000:1000 "$home/.ssh" "$home/.claude" /home/ubuntu/shared \
    && { printf '%s\n' \
           '# Shared settings for every GCG workspace (rules: /home/ubuntu/shared/env/RULES.md)' \
           'if [ -f /home/ubuntu/shared/env/common.sh ]; then . /home/ubuntu/shared/env/common.sh; fi' \
           ''; \
         cat "$home/.bashrc"; } > /tmp/bashrc.new \
    && mv /tmp/bashrc.new "$home/.bashrc" \
    && chown 1000:1000 "$home/.bashrc"

# STOP EDITING HERE. The final effective user must have UID/GID 1000. The
# username and HOME path may differ in another compatible image.
USER 1000:1000
