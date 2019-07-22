#!/bin/sh -e

# Setup the Internet clock sync.
#
# Because you uninstalled fake-hwclock (it won’t be able to store clock on a
# readonly filesystem), you need to install and set up NTP sync. Also clock
# keeping is poor on a standard RPi so you may consider updating time regularly
# (every hour or two should be enough).

apt-get install -y ntp

mv /etc/ntp.conf /etc/ntp.conf.orig
sed -e 's/^\(driftfile\ \).*\(\/ntp\.drift\)$/\1\/var\/tmp\2/' /etc/ntp.conf.orig > /etc/ntp.conf
