#!/bin/sh

extendedWarning() {
   ${CAT} << END_OF_FILE
   o stop and mask SystemD timers and services that will not work on read-only root
END_OF_FILE
}

disableAndMaskServices() {
   disableAndMaskServices_exitCode=${EXIT_SUCCESS}
   logT 'Beginning disableAndMaskServices'

   logT 'Stopping services'
   systemctl stop systemd-tmpfiles-clean.timer \
                  apt-daily.timer              \
                  apt-daily-upgrade.timer

   if [ ${?} -gt 0 ]; then
      logE "Error occurred stopping services"
      disableAndMaskServices_exitCode=${EXIT_FAILURE}
   fi

   logT 'Disabling services'
   systemctl disable systemd-tmpfiles-clean.timer \
                     apt-daily.timer              \
                     apt-daily-upgrade.timer

   if [ ${?} -gt 0 ]; then
      logE "Error occurred disabling services"
      disableAndMaskServices_exitCode=${EXIT_FAILURE}
   fi

   # We got rid of these earlier; nothing to do here.
   #systemctl disable dphys-swapfile && \
   #   rm /var/swap
   #
   #systemctl disable bluetooth \
   #                  cron

   logT 'Masking services'
   systemctl mask systemd-update-utmp          \
                  systemd-update-utmp-runlevel \
                  systemd-rfkill               \
                  systemd-rfkill.socket

   if [ ${?} -gt 0 ]; then
      logE "Error occurred masking services"
      disableAndMaskServices_exitCode=${EXIT_FAILURE}
   fi

   logT 'Finishing disableAndMaskServices'
   return ${disableAndMaskServices_exitCode}
}

main() {
   main_exitCode=${EXIT_SUCCESS}

   disableAndMaskServices

   if [ ${?} -gt 0 ]; then
      logE 'disableAndMaskServices failed.'
      main_exitCode=${EXIT_FAILURE}
   fi

   return ${main_exitCode}
}

# Do not exit 0! This file is intended to get sourced.

