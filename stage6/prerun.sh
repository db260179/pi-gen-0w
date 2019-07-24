#!/bin/bash -e

if [ ! -d "${ROOTFS_DIR}" ]; then
	copy_previous
fi

on_chroot << EOF
apt-get update
EOF

# TODO Add docker-containerd to 02-packages?
