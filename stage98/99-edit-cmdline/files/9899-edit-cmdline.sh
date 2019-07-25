#!/bin/sh

extendedWarning() {
   ${CAT} << END_OF_FILE
   o Change cmdline.txt to boot with read-only root and skip filesystem check
END_OF_FILE
}

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

updateCmdline() {
   updateCmdline_exitCode=${EXIT_SUCCESS}
   logT 'Beginning updateCmdline'

   filename=/boot/cmdline.txt
   fileext=.orig.stage9899

   logT "Backing up ${filename} to ${filename}.${fileext}"
   if [ \! -f ${filename}.${fileext} ]; then
      mv ${filename} ${filename}.${fileext}

      if [ ${?} -gt 0 ]; then
         logE 'Error occurred backing up /boot/cmdline.txt'
         updateCmdline_exitCode=${EXIT_FAILURE}
      fi
   fi

   logT "Updating ${filename} to add ro flag and more"
   sed -e 's/fsck\.repair\=yes/fsck\.mode\=skip\ fastboot\ noswap\ ro/' ${filename}.${fileext} > ${filename}

   if [ ${?} -gt 0 ]; then
      logE 'Error occurred updating /boot/cmdline.txt'
      updateCmdline_exitCode=${EXIT_FAILURE}
   fi

   logT 'Finishing updateCmdline'
   return ${updateCmdline_exitCode}
}

main() {
   main_exitCode=${EXIT_SUCCESS}

   updateCmdline

   if [ ${?} -gt 0 ]; then
      logE 'updateCmdline failed.'
      main_exitCode=${EXIT_FAILURE}
   fi

   return ${main_exitCode}
}

# Do not exit 0! This file is intended to get sourced.

