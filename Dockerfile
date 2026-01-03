FROM jlesage/baseimage-gui:ubuntu-24.04-v4 AS builder

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates curl && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /grass

COPY startapp.sh /grass/startapp.sh
RUN chmod +x /grass/startapp.sh

COPY main-window-selection.xml /etc/openbox/main-window-selection.xml

ARG GRASS_VERSION=6.1.2
ARG GRASS_ARCH=amd64
ARG GRASS_PACKAGE_URL="https://files.grass.io/file/grass-extension-upgrades/v${GRASS_VERSION}/Grass_${GRASS_VERSION}_${GRASS_ARCH}.deb"

RUN curl -sSL "${GRASS_PACKAGE_URL}" -o /grass/grass.deb

FROM jlesage/baseimage-gui:ubuntu-24.04-v4

LABEL org.opencontainers.image.authors="stempst0r@protonmail.com"
LABEL org.opencontainers.image.source="https://github.com/stempst0r/grass-docker"
LABEL org.opencontainers.image.description="Grass desktop node in a web-accessible GUI container"
LABEL org.opencontainers.image.licenses="MIT"

# HTTPS + Auth (customize or override at runtime)
ENV SECURE_CONNECTION=1
ENV WEB_AUTHENTICATION=1
ENV WEB_AUTHENTICATION_USERNAME=grass
ENV WEB_AUTHENTICATION_PASSWORD=grass

# Keep app running if it crashes
ENV KEEP_APP_RUNNING=1

# Run as non-root
ENV USER_ID=99
ENV GROUP_ID=100

ARG GRASS_VERSION=6.1.2

# App metadata
RUN set-cont-env APP_NAME "Grass" && \
    set-cont-env APP_VERSION "${GRASS_VERSION}"

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        software-properties-common && \
    add-apt-repository universe && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        libayatana-appindicator3-1 \
        libwebkitgtk-6.0-4 \
        libwebkit2gtk-4.1-0 \
        libgtk-3-0 \
        libnotify4 \
        libnss3 \
        libxss1 \
        libxtst6 \
        libegl-mesa0 \
        libgles2-mesa-dev && \
    apt-get autoremove -y && \
    apt-get autoclean -y && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/*

# Copy and install Grass
COPY --from=builder /grass/ /grass/
COPY --from=builder /etc/openbox/main-window-selection.xml /etc/openbox/

RUN mv /grass/startapp.sh /startapp.sh && \
    dpkg -i /grass/grass.deb || apt-get install -f -y && \
    apt-mark hold grass && \
    rm -rf /grass /tmp/* /var/tmp/* /var/cache/apt/*