#!/bin/sh -e

# Stop and mask SystemD timers and services that won’t work on read-only
# machine

systemctl stop systemd-tmpfiles-clean.timer \
               apt-daily.timer              \
               apt-daily-upgrade.timer

systemctl disable systemd-tmpfiles-clean.timer           \
                  systemd-tmpfiles-clean apt-daily.timer \
                  apt-daily-upgrade.timer

systemctl disable dphys-swapfile && \
   rm /var/swap

systemctl disable bluetooth \
                  cron

systemctl mask systemd-update-utmp          \
               systemd-update-utmp-runlevel \
               systemd-rfkill               \
               systemd-rfkill.socket

