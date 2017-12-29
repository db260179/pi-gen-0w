#!/bin/bash -e

install -v -d						${ROOTFS_DIR}/etc/systemd/system/dhcpcd.service.d
install -v -m 644 files/wait.conf			${ROOTFS_DIR}/etc/systemd/system/dhcpcd.service.d/

install -v -d                                           ${ROOTFS_DIR}/etc/wpa_supplicant

workingFile=files/wpa_supplicant.conf.tmp
cat files/wpa_supplicant.conf | \
   sed -e "s/{{\ *WIFI_SSID\ *}}/${WIFI_SSID}/g" | \
   sed -e "s/{{\ *WIFI_PSK\ *}}/${WIFI_PSK}/g" > ${workingFile}
install -v -m 600 ${workingFile}             ${ROOTFS_DIR}/etc/wpa_supplicant/wpa_supplicant.conf
/bin/rm ${workingFile}

