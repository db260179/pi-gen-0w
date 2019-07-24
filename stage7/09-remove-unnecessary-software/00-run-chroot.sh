#!/bin/sh -e

apt-get remove -y --purge bluez     \
                          cron      \
                          dbus      \
                          logrotate \
                          triggerhappy

apt-get autoremove -y --purge

# Avahi daemon is for mDNS to auto-discover services on the same network – you
# can eventually get it work if you need it but most people don’t need it and
# it probably needs write access somewhere.
#
# Triggerhappy is hotkey daemon which is useless on headless sytem.
#
# Bluez is userspace part of the bluetooth system. I don’t need bluetooth at
# all.
#
# You can remove more like xserver-common, dbus, ....
