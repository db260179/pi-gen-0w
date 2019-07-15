#!/bin/bash -e

install -v -d					"${ROOTFS_DIR}/etc/systemd/system/dhcpcd.service.d"
install -v -m 644 files/wait.conf		"${ROOTFS_DIR}/etc/systemd/system/dhcpcd.service.d/"

install -v -d					"${ROOTFS_DIR}/etc/wpa_supplicant"

workingFile=files/wpa_supplicant.conf.tmp
cat files/wpa_supplicant.conf | \
   sed -e "s/{{\ *WIFI_SSID\ *}}/${WIFI_SSID}/g" | \
   sed -e "s/{{\ *WIFI_PSK\ *}}/${WIFI_PSK}/g" > ${workingFile}
install -v -m 600 ${workingFile}		"${ROOTFS_DIR}/etc/wpa_supplicant/wpa_supplicant.conf"
/bin/rm ${workingFile}

if [ -v WPA_COUNTRY ]; then
	echo "country=${WPA_COUNTRY}" >> "${ROOTFS_DIR}/etc/wpa_supplicant/wpa_supplicant.conf"
fi

if [ -v WPA_ESSID ] && [ -v WPA_PASSWORD ]; then
on_chroot <<EOF
wpa_passphrase "${WPA_ESSID}" "${WPA_PASSWORD}" >> "/etc/wpa_supplicant/wpa_supplicant.conf"
EOF
fi

# Disable wifi on 5GHz models
mkdir -p "${ROOTFS_DIR}/var/lib/systemd/rfkill/"
echo 1 > "${ROOTFS_DIR}/var/lib/systemd/rfkill/platform-3f300000.mmc:wlan"
echo 1 > "${ROOTFS_DIR}/var/lib/systemd/rfkill/platform-fe300000.mmc:wlan"
