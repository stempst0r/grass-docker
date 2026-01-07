
# Grass Docker GUI

Docker image for running the **Grass** desktop application in a browser-accessible GUI using noVNC.

Grass is a decentralized bandwidth-sharing network that allows users to earn rewards (Grass Points, convertible to GRASS tokens) by running a node that shares unused internet bandwidth for public web data collection in AI development.

This container is built on [jlesage/baseimage-gui](https://github.com/jlesage/docker-baseimage-gui) and provides secure web access via noVNC with HTTPS, basic authentication, auto-restart on crashes, and non-root execution.

Images are automatically built and published to **GitHub Container Registry** at `ghcr.io/stempst0r/grass-docker` with tags matching the official Grass version (e.g., `6.1.2`) and `latest`.

Perfect for running Grass nodes 24/7 on headless devices, or home labs.

## Features

- Browser-based GUI access via noVNC (port 5800)
- HTTPS and basic authentication enabled by default
- Automatic app restart on crash
- Runs as non-root user for security
- Minimal multi-stage build
- Version tags match official Grass releases

## Quick Start

```bash
docker run -d \
  --name grass-node \
  -p 5800:5800 \
  -e WEB_AUTHENTICATION_USERNAME=yourusername \
  -e WEB_AUTHENTICATION_PASSWORD=yourstrongpassword \
  ghcr.io/stempst0r/grass-docker:latest
```

Open your browser and go to: `https://your-host-ip:5800` (or HTTP if `SECURE_CONNECTION=0`).

Log in with the credentials you set (default is `grass/grass` – **always change them in production!**).

Then sign in to your Grass account inside the app to start earning points.

## Comprehensive docker-compse

```yaml
---
services:
  grass-node:
    image: ghcr.io/stempst0r/grass-docker:latest
    container_name: grass-node
    restart: unless-stopped
    ports:
      - "5800:5800"   # noVNC web interface
    environment:
      # --- noVNC Web Access Security ---
      SECURE_CONNECTION: "1"                  # 1 = HTTPS (self-signed), 0 = HTTP
      WEB_AUTHENTICATION: "1"                 # 1 = enable basic auth, 0 = disable
      WEB_AUTHENTICATION_USERNAME: "yourusername"    # change this!
      WEB_AUTHENTICATION_PASSWORD: "yourstrongpassword"  # change this!

      # --- Application Behavior ---
      KEEP_APP_RUNNING: "1"                   # automatically restart Grass if it crashes

      # --- Non-root User (Security) ---
      USER_ID: "1000"                         # set to your host user's UID if you need volume access
      GROUP_ID: "1000"                        # set to your host user's GID

      # --- Optional Display Settings (jlesage/baseimage-gui) ---
      DISPLAY_WIDTH: "1920"                   # virtual desktop width
      DISPLAY_HEIGHT: "1080"                  # virtual desktop height

      # --- Optional: Timezone ---
      TZ: "America/Chicago"                   # adjust to your timezone

    # Optional: persist config
    volumes:
      - grass-config:/config

volumes:
  grass-config:
```

## Environment Variables

| Variable                        | Description                                   | Default   |
|---------------------------------|-----------------------------------------------|-----------|
| `WEB_AUTHENTICATION_USERNAME`   | noVNC web username                            | `grass`   |
| `WEB_AUTHENTICATION_PASSWORD`   | noVNC web password                            | `grass`   |
| `SECURE_CONNECTION`             | Enable HTTPS (self-signed certificate)         | `1`       |
| `KEEP_APP_RUNNING`              | Restart Grass if it crashes                    | `1`       |
| `USER_ID` / `GROUP_ID`          | UID/GID for the non-root user                 | `99`/`100`|

## Pulling Specific Versions

```bash
docker pull ghcr.io/stempst0r/grass-docker:6.1.2   # specific version
docker pull ghcr.io/stempst0r/grass-docker:latest # most recent
```

## Building Locally (Optional)

```bash
git clone https://github.com/stempst0r/grass-docker.git
cd grass-docker
docker build -t grass-docker:latest .

# Build a specific Grass version
docker build --build-arg GRASS_VERSION=6.1.2 -t grass-docker:6.1.2 .
```

## Updating to New Grass Versions

When a new Grass version is released:
- A Git tag `vX.Y.Z` is pushed to this repository.
- GitHub Actions automatically builds and publishes new images tagged with that version and updates `latest`.

## Disclaimer

This is an **unofficial**, community-maintained project. Use at your own risk.

The container downloads and installs the official Grass `.deb` package from `files.grass.io`.

For official information and support, visit:
- https://www.grass.io
- https://app.getgrass.io

## License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.
