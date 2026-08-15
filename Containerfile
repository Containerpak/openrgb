FROM ubuntu:26.04 AS source

ADD --checksum=sha256:37f25ecb9c0f52cd3b916d760c1df61a8b372c8b124115555200fe6dfe56f2a0 https://github.com/CalcProgrammer1/OpenRGB/releases/download/release_candidate_1.0rc3/OpenRGB_1.0rc3_x86_64_6fbcf62.AppImage /tmp/app.AppImage

RUN chmod 0755 /tmp/app.AppImage && \
    cd /tmp && \
    ./app.AppImage --appimage-extract >/dev/null && \
    mkdir -p /stage && \
    cp -a /tmp/squashfs-root/. /stage/

FROM ghcr.io/containerpak/mesa64:main

LABEL org.opencontainers.image.source="https://github.com/Containerpak/openrgb"

COPY --from=source /stage/ /opt/openrgb/
COPY openrgb /usr/bin/openrgb
COPY openrgb.desktop /usr/share/applications/openrgb.desktop
COPY icon.png /usr/share/icons/hicolor/128x128/apps/openrgb.png

RUN apt-get update && \
    apt-get install -y --no-install-recommends libharfbuzz0b libhidapi-hidraw0 libusb-1.0-0 && \
    chmod 0755 /usr/bin/openrgb && \
    cpak-clean-junk
