#!/bin/sh

extendedWarning() {
   ${CAT} << END_OF_FILE
   o Add ro flag to both block devices in /etc/fstab
END_OF_FILE
}

updateFstab() {
   updateFstab_exitCode=${EXIT_SUCCESS}
   logT 'Beginning updateFstab'

   filename=/etc/fstab
   fileext=.orig.stage9898

   logT "Backing up ${filename} to ${filename}.${fileext}"
   if [ \! -f ${filename}.${fileext} ]; then
      mv ${filename} ${filename}.${fileext}

      if [ ${?} -gt 0 ]; then
         logE 'Error occurred backing up /etc/fstab file'
         updateFstab_exitCode=${EXIT_FAILURE}
      fi
   fi

   logT "Updating ${filename} to add ro flag to devices"
   sed -e '/\/proc/!s/defaults/defaults\,ro/' ${filename}.${fileext} > ${filename}

   if [ ${?} -gt 0 ]; then
      logE 'Error occurred backing up /etc/fstab file'
      updateFstab_exitCode=${EXIT_FAILURE}
   fi

   logT 'Finishing updateFstab'
   return ${updateFstab_exitCode}
}

main() {
   main_exitCode=${EXIT_SUCCESS}

   updateFstab

   if [ ${?} -gt 0 ]; then
      logE 'updateFstab failed.'
      main_exitCode=${EXIT_FAILURE}
   fi

   return ${main_exitCode}
}

# Do not exit 0! This file is intended to get sourced.

