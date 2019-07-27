#!/bin/sh -e

scripts_home=/root/scripts/initial-setup.d

install -v -o 0 -g 0 -m 755 -p "files/9901-git-clone-overlayRoot.sh" "${ROOTFS_DIR}/${scripts_home}/"

