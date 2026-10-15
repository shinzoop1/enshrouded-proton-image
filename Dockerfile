# Enshrouded Pterodactyl image with GE-Proton 11-9.
# Debian 13 (trixie) provides glibc 2.41, newer than the Debian 12 base
# used by the upstream Ptero Proton image. GE-Proton 11-9 needs a newer glibc.
FROM ghcr.io/ptero-eggs/steamcmd:proton AS ptero-base

FROM debian:trixie-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV USER=container
ENV HOME=/home/container

# Keep the official Pterodactyl startup entrypoint from the upstream image.
COPY --from=ptero-base /entrypoint.sh /entrypoint.sh

RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        bash \
        ca-certificates \
        curl \
        dbus \
        file \
        gnutls-bin \
        iproute2 \
        lib32gcc-s1 \
        libao-common \
        libasound2t64 \
        libasound2t64:i386 \
        libdbus-1-3:i386 \
        libfontconfig1:i386 \
        libfreetype6:i386 \
        libgcc-s1:i386 \
        libgdiplus \
        libgl1 \
        libgl1:i386 \
        libncurses6 \
        libntlm0 \
        libopenal1:i386 \
        libpng16-16:i386 \
        libpulse0 \
        libpulse0:i386 \
        libstdc++6:i386 \
        libudev1:i386 \
        libvulkan1 \
        libvulkan1:i386 \
        locales \
        mesa-vulkan-drivers \
        mesa-vulkan-drivers:i386 \
        numactl \
        python3 \
        python3-pip \
        python3-setuptools \
        pipx \
        tini \
        winbind \
        xauth \
        xvfb \
        wget \
    && rm -rf /var/lib/apt/lists/*

# Install the pinned GE-Proton release in its own directory so its runtime
# files remain together. The wrapper preserves the Pterodactyl entrypoint's
# expected /usr/local/bin/proton command.
ARG GE_PROTON_VERSION=GE-Proton11-9
RUN mkdir -p /opt \
    && curl -fL --retry 3 \
       "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${GE_PROTON_VERSION}/${GE_PROTON_VERSION}-x86_64.tar.gz" \
       -o /tmp/ge-proton.tar.gz \
    && tar -xzf /tmp/ge-proton.tar.gz -C /opt \
    && PROTON_BIN="$(find /opt -maxdepth 4 -type f -name proton -print -quit)" \
    && test -n "$PROTON_BIN" \
    && chmod 0755 "$PROTON_BIN" \
    && printf '#!/bin/sh\nexec "%s" "$@"\n' "$PROTON_BIN" > /usr/local/bin/proton \
    && chmod 0755 /usr/local/bin/proton \
    && rm -f /tmp/ge-proton.tar.gz

# Protonfixes can try to initialize a display on headless hosts; Xvfb and the
# software Vulkan packages above preserve the runtime dependencies used by
# the upstream Proton yolk.
RUN useradd --uid 1000 --create-home --home-dir /home/container container \
    && rm -f /etc/machine-id \
    && dbus-uuidgen --ensure=/etc/machine-id \
    && rm -f /var/lib/dbus/machine-id \
    && dbus-uuidgen --ensure \
    && chmod 0755 /entrypoint.sh

WORKDIR /home/container
USER container
STOPSIGNAL SIGINT
ENTRYPOINT ["/usr/bin/tini", "-g", "--"]
CMD ["/entrypoint.sh"]
