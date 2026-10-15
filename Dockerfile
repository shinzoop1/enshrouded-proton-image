FROM ghcr.io/ptero-eggs/steamcmd:proton

USER root

# GE-Proton is installed alongside the Pterodactyl SteamCMD/Proton base image.
# The egg's existing startup command can continue to call: proton run ...
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl tar \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /opt/ge-proton \
    && curl -fL --retry 3 --retry-all-errors \
       "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton11-9/GE-Proton11-9-x86_64.tar.gz" \
       -o /tmp/ge-proton.tar.gz \
    && tar -xzf /tmp/ge-proton.tar.gz --strip-components=1 -C /opt/ge-proton \
    && rm -f /tmp/ge-proton.tar.gz \
    && test -x /opt/ge-proton/proton

# Make the GE-Proton launcher take precedence over the base image's Proton.
ENV PATH="/opt/ge-proton:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
ENV HOME="/home/container"
WORKDIR /home/container

USER container
