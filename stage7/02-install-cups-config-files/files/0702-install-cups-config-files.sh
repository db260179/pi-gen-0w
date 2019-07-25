#!/bin/sh

extendedWarning() {
   ${CAT} << END_OF_FILE
   o install CUPS configuration files
END_OF_FILE
}

installCupsConfigFiles() {
   installCupsConfigFiles_exitCode=${EXIT_SUCCESS}
   logT 'Beginning installCupsConfigFiles'

   logT 'Adding user pi to lpadmin group'
   usermod -a -G lpadmin pi

   if [ ${?} -gt 0 ]; then
      logE "Error occurred adding user to group"
      installCupsConfigFiles_exitCode=${EXIT_FAILURE}
   fi

   # TODO cupsctl: Unable to connect to server: Bad file descriptor
   ## TODO Is this needed?
   #logT 'Configuring CUPS'
   #cupsctl --remote-any
   #
   #if [ ${?} -gt 0 ]; then
   #   logE "Error occurred configuring CUPS"
   #   installCupsConfigFiles_exitCode=${EXIT_FAILURE}
   #fi

   # TODO These CUPS printer configurations belong elsewhere, not here.

   # UID 7 is the lp user

   logT 'Installing cupsd.conf'
   install -v -o 0 -g 7 -m 644 -p "files/cupsd.conf" "/etc/cups/"

   if [ ${?} -gt 0 ]; then
      logE "Error occurred installing cupsd.conf"
      installCupsConfigFiles_exitCode=${EXIT_FAILURE}
   fi

   logT 'Installing printers.conf'
   install -v -o 0 -g 7 -m 600 -p "files/printers.conf" "/etc/cups/"

   if [ ${?} -gt 0 ]; then
      logE "Error occurred installing printers.conf"
      installCupsConfigFiles_exitCode=${EXIT_FAILURE}
   fi

   logT 'Creating ppd directory'
   mkdir -p "/etc/cups/ppd"

   if [ ${?} -gt 0 ]; then
      logE "Error occurred creating ppd directory"
      installCupsConfigFiles_exitCode=${EXIT_FAILURE}
   fi

   logT 'Setting ownership of ppd directory'
   chown 0:7 "/etc/cups/ppd"

   if [ ${?} -gt 0 ]; then
      logE "Error occurred setting ppd directory ownership"
      installCupsConfigFiles_exitCode=${EXIT_FAILURE}
   fi

   logT 'Installing Ricoh C250DN PPD'
   install -v -o 0 -g 7 -m 644 -p "files/ppd/Ricoh_C250DN.ppd" "/etc/cups/ppd/"

   if [ ${?} -gt 0 ]; then
      logE "Error occurred installing C250DN PPD"
      installCupsConfigFiles_exitCode=${EXIT_FAILURE}
   fi

   #logT 'Installing Samsung ML-1710 PPD'
   #install -v -o 0 -g 7 -m 644 -p "files/ppd/Samsung_ML-1710.ppd" "/etc/cups/ppd/"
   #
   #if [ ${?} -gt 0 ]; then
   #   logE "Error occurred installing ML-1710 PPD"
   #   installCupsConfigFiles_exitCode=${EXIT_FAILURE}
   #fi

   logT 'Finishing installCupsConfigFiles'
   return ${installCupsConfigFiles_exitCode}
}

main() {
   main_exitCode=${EXIT_SUCCESS}

   if [ \( ${INITIAL_SETUP_CONF_REMOTE}  -gt 0 \) -a
        \( ${INITIAL_SETUP_CONF_TRUSTED} -gt 0 \) ]; then

      installCupsConfigFiles

   fi

   if [ ${?} -gt 0 ]; then
      logE 'installCupsConfigFiles failed.'
      main_exitCode=${EXIT_FAILURE}
   fi

   return ${main_exitCode}
}

# Do not exit 0! This file is intended to get sourced.
