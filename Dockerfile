############################################################
# Dockerfile that contains SteamCMD
############################################################
FROM debian:stretch
LABEL maintainer="walentinlamonos@gmail.com"

# Install, update & upgrade packages
# Create user for the server
# This also creates the home directory we later need
# Clean TMP, apt-get cache and other stuff to make the image smaller
RUN apt-get update && apt-get install -y \
        lib32stdc++6 \
        lib32gcc1 \
        curl && \
        apt-get -y upgrade && \
        apt-get clean autoclean && \
        apt-get autoremove -y && \
        rm -rf /var/lib/{apt,dpkg,cache,log}/

# Switch to user steam
# USER steam

# Create Directory for SteamCMD
# Download SteamCMD
# Extract and delete archive
RUN mkdir -p /opt/steam/steamcmd && cd /opt/steam/steamcmd && \
        curl -o steamcmd_linux.tar.gz "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" && \
        tar zxf steamcmd_linux.tar.gz && \
        rm steamcmd_linux.tar.gz

RUN chgrp -R 0 /opt/steam && \
    chmod -R g=u /opt/steam

VOLUME /opt/steam/steamcmd
