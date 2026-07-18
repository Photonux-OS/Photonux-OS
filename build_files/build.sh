#!/bin/bash

set -ouex pipefail

# Copy the contents of system_files/ of the git repo to /
cp -avf "/ctx/system_files"/. /

### Install packages

dnf5 install -y tmux

### Enable services

systemctl enable podman.socket

### Photonux identity

mkdir -p /etc/bazzite
echo "photonux-os" > /etc/bazzite/image_name

echo "===== IMAGE NAME ====="
cat /etc/bazzite/image_name

echo "===== WATERMARK FILE ====="
file /usr/share/plymouth/themes/spinner/watermark.png

echo "===== WATERMARK PATH ====="
ls -l /usr/share/plymouth/themes/spinner/watermark.png

echo "===== WATERMARK HASH ====="
sha256sum /usr/share/plymouth/themes/spinner/watermark.png

echo "===== SYSTEM LOGO HASH ====="
sha256sum /usr/share/pixmaps/system-logo-white.png || true

echo "===== PLYMOUTH DEFAULTS ====="
cat /usr/share/plymouth/plymouthd.defaults || true

echo "===== DRACUT START ====="

dracut \
  --regenerate-all \
  --force \
  --verbose

echo "===== DRACUT COMPLETED ====="

echo "===== WATERMARK HASH AFTER DRACUT ====="
sha256sum /usr/share/plymouth/themes/spinner/watermark.png
