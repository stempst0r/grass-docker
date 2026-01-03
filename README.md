
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

Open your browser and go to: `http://your-host-ip:5800` (or HTTPS if `SECURE_CONNECTION=1`).

Log in with the credentials you set (default is `grass/grass` – **always change them in production!**).

Then sign in to your Grass account inside the app to start earning points.

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
