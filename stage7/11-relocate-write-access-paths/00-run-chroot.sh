#!/bin/sh -e

# TODO Do we really need this? If the intent is to have a tmpfs overlay on top of this, can we leave everything alone and let the overlay write here?

relocate() {
   if [ \! -L ${1} ]; then
      mv ${1} ${2} && \
         ln -s ${2} ${1}
   fi
}

redirect() {
   if [ \! -L ${1} ]; then
      rm -rf ${1} && \
         ln -s ${2} ${1}
   fi
}

# TODO Enable
#relocate /etc/resolv.conf /var/run/dhcpcd.resolv.conf
#relocate /var/lib/dhcp    /var/run/dhcp
#relocate /var/spool       /var/run/spool
#
#redirect /var/lib/dhcpcd5 /var/run
#
#mkdir -p /var/run/db
#redirect /var/db          /var/run/db
#
#redirect /var/lib/systemd/random-seed /tmp/random-seed
#
## This file will not be created on reboot, so need a systemd service
## (pre-command):
#
#filename=/lib/systemd/system/systemd-random-seed.service
#fileext=.orig.stage7
#
#if [ \! -f ${filename}.${fileext} ]; then
#   mv ${filename} ${filename}.${fileext}
#fi
#
#sed -e '/ExecStart/a ExecStartPre=/bin/echo "" >/tmp/random-seed' ${filename}.${fileext} > ${filename}
#
## Do not use touch instead of echo, it won’t work because checking RO
## filesystem.
