#!/bin/sh -e

scripts_home=/root/scripts

mkdir -p "${ROOTFS_DIR}/${scripts_home}/initial-setup.d"
mkdir -p "${ROOTFS_DIR}/${scripts_home}/initial-setup.files"
install -v -o 0 -g 0 -m 755 -p "files/initial-setup.sh" "${ROOTFS_DIR}/${scripts_home}/"
install -v -o 0 -g 0 -m 644 -p "files/initial-setup.sh.conf" "${ROOTFS_DIR}/${scripts_home}/"

# Set up lock file so initial-setup script will run; script will not run
# without this set, and script will automatically remove this upon successful
# completion to avoid running again.
ln -s /dev/null "${ROOTFS_DIR}/${scripts_home}/initial-setup.sh.lock"

filename=${ROOTFS_DIR}/etc/rc.local
fileext=.orig.stage6

if [ \! -f ${filename}.${fileext} ]; then
   mv ${filename} ${filename}.${fileext}
fi

sed -e '/^exit\ 0$/i \/root\/scripts\/initial\-setup\.sh' ${filename}.${fileext} > ${filename}
chmod +x ${filename}

