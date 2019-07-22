#!/bin/sh -e

# Add ",ro" flag to both block devices in /etc/fstab

mv /etc/fstab /etc/fstab.orig
sed -e '/\/proc/!s/defaults/defaults\,ro/' /etc/fstab.orig > /etc/fstab

