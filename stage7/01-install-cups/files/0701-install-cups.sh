#!/bin/sh

extendedWarning() {
   ${CAT} << END_OF_FILE
   o install CUPS
END_OF_FILE
}

installCups() {
   installCups_exitCode=${EXIT_SUCCESS}
   logT 'Beginning installCups'

   logT 'Installing CUPS'
   apt-get install --assume-yes cups

   if [ ${?} -gt 0 ]; then
      logE "Error occurred installing CUPS"
      installCups_exitCode=${EXIT_FAILURE}
   fi

   logT 'Finishing installCups'
   return ${installCups_exitCode}
}

main() {
   main_exitCode=${EXIT_SUCCESS}

   installCups

   if [ ${?} -gt 0 ]; then
      logE 'installCups failed.'
      main_exitCode=${EXIT_FAILURE}
   fi

   return ${main_exitCode}
}

# Do not exit 0! This file is intended to get sourced.

