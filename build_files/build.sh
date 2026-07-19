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

echo "===== REMOVE EXISTING INITRAMFS ====="

rm -f /usr/lib/modules/*/initramfs.img || true
rm -f /boot/initramfs-*.img || true

echo "===== DRACUT START ====="

KVER=$(basename /usr/lib/modules/*)
dracut \
  --force \
  --verbose \
  "/usr/lib/modules/${KVER}/initramfs.img" \
  "${KVER}"

echo "===== DRACUT COMPLETED ====="

echo "===== WATERMARK HASH AFTER DRACUT ====="
sha256sum /usr/share/plymouth/themes/spinner/watermark.png
