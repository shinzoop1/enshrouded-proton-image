FROM ghcr.io/ptero-eggs/steamcmd:proton

USER root

# Keep the Proton version shipped with the Pterodactyl base image. GE-Proton 11
# requires GLIBC_2.38, but this base image ships an older glibc, so replacing
# Proton with GE-Proton 11 prevents Wine from starting.
# Add the Vulkan loader and Mesa software driver needed by Proton's Python
# startup code on a headless dedicated-server container.
RUN apt-get update \
    && apt-get install -y --no-install-recommends libvulkan1 mesa-vulkan-drivers \
    && rm -rf /var/lib/apt/lists/* \
    && ldconfig

ENV HOME="/home/container"
WORKDIR /home/container

USER container
