#!/bin/sh -e

scripts_home=/root/scripts/initial-setup.d
dest=/root/scripts/initial-setup.files

# TODO These CUPS printer configurations belong elsewhere, not here.

install -v -p "files/cupsd.conf" "${ROOTFS_DIR}/${dest}/"
install -v -p "files/printers.conf" "${ROOTFS_DIR}/${dest}/"

install -v -p "files/ppd/Ricoh_C250DN.ppd" "${ROOTFS_DIR}/${dest}/"
#install -v -p "files/ppd/Samsung_ML-1710.ppd" "${ROOTFS_DIR}/${dest}/"

install -v -o 0 -g 0 -m 755 -p "files/0702-install-cups-config-files.sh" "${ROOTFS_DIR}/${scripts_home}/"

