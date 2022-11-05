FROM ghcr.io/linuxserver/baseimage-rdesktop-web:focal

ENV \
  GUIAUTOSTART="true" \
  HOME="/config"


RUN \
 echo "**** install packages ****" && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    fonts-noto-color-emoji \
    jq  \
    libc6\ 
    libxss1 \
    libnss3 \
    obconf \
    numix-gtk-theme \
    lxappearance \
    curl && \
    echo "**** install hakuneko ****" && \
  if [ -z ${HAKUNEKO_RELEASE+x} ]; then \
         HAKUNEKO_RELEASE=$(curl -sX GET "https://api.github.com/repos/manga-download/hakuneko/releases/latest" \
         | jq -r .tag_name); \
  fi && \
  HAKUNEKO_VERSION="$(echo ${HAKUNEKO_RELEASE} | cut -c2-)" && \
  HAKUNEKO_URL="https://github.com/manga-download/hakuneko/releases/download/v${HAKUNEKO_VERSION}/hakuneko-desktop_${HAKUNEKO_VERSION}_linux_amd64.deb" && \
  echo "${HAKUNEKO_VERSION} ;; ${HAKUNEKO_URL}" && \
  curl -o /tmp/hakuneko.deb \
       -L "${HAKUNEKO_URL}" && \
  DEBIAN_FRONTEND=noninteractive apt install -f /tmp/hakuneko.deb && \
#    apt-get install -y obconf && \
  dbus-uuidgen > /etc/machine-id && \
  echo "**** cleanup ****" && \
   apt-get clean && \
   rm -rf \
     /tmp/* \
     /var/lib/apt/lists/* \
     /var/tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 3000
VOLUME /config


