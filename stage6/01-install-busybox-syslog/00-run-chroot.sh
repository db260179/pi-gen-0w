#!/bin/sh -e

# Replace log management with busybox one. This will put log into circular
# memory buffer, you will able to see log using the logread command.

apt-get install -y busybox-syslogd
dpkg --purge rsyslog

