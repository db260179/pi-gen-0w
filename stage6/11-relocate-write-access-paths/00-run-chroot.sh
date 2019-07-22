#!/bin/sh -e

relocate() {
   mv ${1} ${2} && \
      ln -s ${2} ${1}
}

redirect() {
   rm -rf ${1} && \
      ln -s ${2} ${1}
}

relocate /etc/resolv.conf /var/run/dhcpcd.resolv.conf
relocate /var/lib/dhcp    /var/run/dhcp
relocate /var/spool       /var/run/spool

redirect /var/lib/dhcpcd5 /var/run

mkdir -p /var/run/db
redirect /var/db          /var/run/db

redirect /var/lib/systemd/random-seed /tmp/random-seed

# This file will not be created on reboot, so need a systemd service
# (pre-command):

mv /lib/systemd/system/systemd-random-seed.service /lib/systemd/system/systemd-random-seed.service.orig
sed -e '/ExecStart/a ExecStartPre=/bin/echo "" >/tmp/random-seed' /lib/systemd/system/systemd-random-seed.service.orig > /lib/systemd/system/systemd-random-seed.service

# Do not use touch instead of echo, it won’t work because checking RO
# filesystem.
