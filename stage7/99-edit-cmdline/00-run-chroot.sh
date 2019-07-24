#!/bin/sh -e

# Change cmdline.txt to boot read-only, and also skip filesystem check. Replace
# fsck.repair=yes with fsck.mode=skip. Append ro at the end.
#
# Disable swap and filesystem check and set it to read-only.
#
# Because the filesystem will be mounted read-only, there is nothing to be
# corrupted so filesystem check must be disabled. I say MUST because it MUST.
# If you don’t have an external HW clock and use NTP time sync only and you do
# a change to the filesystem and reboot, filesystem check will see it as an
# update from the future, denying further boot, requiring manual action on the
# site.

mv /boot/cmdline.txt /boot/cmdline.txt.orig
sed -e 's/fsck\.repair\=yes/fsck\.mode\=skip\ fastboot\ noswap\ ro/' /boot/cmdline.txt.orig > /boot/cmdline.txt

