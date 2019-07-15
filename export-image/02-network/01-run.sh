#!/bin/bash -e

install -m 644 files/resolv.conf "${ROOTFS_DIR}/etc/"
install -m 644 files/interfaces-wlan0 "${ROOTFS_DIR}/etc/network/interfaces.d"
