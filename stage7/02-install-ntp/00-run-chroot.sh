#!/bin/sh -e

# Setup the Internet clock sync.
#
# Because you uninstalled fake-hwclock (it won’t be able to store clock on a
# readonly filesystem), you need to install and set up NTP sync. Also clock
# keeping is poor on a standard RPi so you may consider updating time regularly
# (every hour or two should be enough).

# Moved to 00-install-extras/00-packages
#apt-get install -y ntp

filename=/etc/ntp.conf
fileext=.orig.stage7

if [ \! -f ${filename}.${fileext} ]; then
   mv ${filename} ${filename}.${fileext}
fi

sed -e 's/^\(driftfile\ \).*\(\/ntp\.drift\)$/\1\/var\/tmp\/\2/' ${filename}.${fileext} > ${filename}
