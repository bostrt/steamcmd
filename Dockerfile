############################################################
# Dockerfile that contains steamCMD
############################################################
FROM debian:stretch

RUN dpkg --add-architecture i386
RUN apt-get update && apt-get install -y \
        lib32stdc++6 \
        lib32gcc1 \
        libcurl3:i386 \
        curl && \
        apt-get -y upgrade && \
        apt-get clean autoclean && \
        apt-get autoremove -y && \
        rm -rf /var/lib/{apt,dpkg,cache,log}/

# Switch to user steam
ENV HOME /opt/steam

# Create Directory for steamCMD
# Download steamCMD
# Extract and delete archive
RUN mkdir -p /opt/steam/steamcmd && cd /opt/steam/steamcmd && \
        curl -o steamcmd_linux.tar.gz "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" && \
        tar zxf steamcmd_linux.tar.gz && \
        rm steamcmd_linux.tar.gz

COPY otp /bin/otp
COPY install.txt /opt/steam/install.txt
COPY install_game.sh /opt/steam/install_game.sh

RUN chgrp -R 0 /opt/steam && \
    chmod -R g=u /opt/steam

VOLUME /opt/steam/steamcmd

ENTRYPOINT ["/opt/steam/install_game.sh"]
