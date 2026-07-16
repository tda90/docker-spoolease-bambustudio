# syntax=docker/dockerfile:1
FROM ghcr.io/linuxserver/baseimage-selkies:ubunturesolute
# set version label
ARG BUILD_DATE
ARG VERSION
ARG BAMBUSTUDIO_VERSION
LABEL build_version="SpoolEase-BambuStudio (packaged by tda90, based on linuxserver/docker-bambustudio) version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="tda90"
# title
ENV TITLE=BambuStudio \
    SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt \
    NO_GAMEPAD=true \
    PIXELFLUX_WAYLAND=true
RUN \
  echo "**** add icon ****" && \
  curl -o \
    /usr/share/selkies/www/icon.png \
    https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/bambustudio-logo.png && \
  echo "**** install packages ****" && \
  add-apt-repository ppa:xtradeb/apps && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
  apt-get install --no-install-recommends -y \
    firefox \
    fonts-dejavu \
    fonts-dejavu-extra \
    gir1.2-gst-plugins-bad-1.0 \
    gir1.2-gstreamer-1.0 \
    gstreamer1.0-nice \
    gstreamer1.0-plugins-* \
    gstreamer1.0-pulseaudio \
    libosmesa6 \
    libwebkit2gtk-4.1-0 \
    libwx-perl && \
  echo "**** install bambu studio from appimage ****" && \
  DOWNLOAD_URL=$(curl -sX GET "https://api.github.com/repos/yanshay/SpoolEase-BambuStudio/releases/tags/2.7.1.62-SpoolEase.1" \
    | awk '/browser_download_url.*ubuntu-24.04/{print $4;exit}' FS='[""]') && \
  cd /tmp && \
  curl -o \
    /tmp/bambu.app -L \
    "${DOWNLOAD_URL}" && \
  chmod +x /tmp/bambu.app && \
  ./bambu.app --appimage-extract && \
  mv squashfs-root /opt/bambustudio && \
  localedef -i en_GB -f UTF-8 en_GB.UTF-8 && \
  printf "Linuxserver.io version: ${VERSION}\nBuild-date: ${BUILD_DATE}" > /build_version && \
  echo "**** cleanup ****" && \
  apt-get autoclean && \
  rm -rf \
    /config/.cache \
    /config/.launchpadlib \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*
# add local files
COPY /root /
# ensure custom init scripts are executable (web commits drop the +x bit)
RUN chmod +x /custom-cont-init.d/*.sh
# ports and volumes
EXPOSE 3001
VOLUME /config
