#!/bin/sh

extendedWarning() {
   ${CAT} << END_OF_FILE
   o Clone overlayRoot git repo
END_OF_FILE
}

cloneGitRepo() {
   cloneGitRepo_exitCode=${EXIT_SUCCESS}
   logT 'Beginning cloneGitRepo'

   logT 'Creating directory in which to clone git repo'
   mkdir /root/repo

   if [ ${?} -gt 0 ]; then
      logE 'Error creating directory'
      cloneGitRepo_exitCode=${EXIT_FAILURE}
   fi

   orig_dir="${PWD}"

   logT 'Entering directory in which to clone git repo'
   cd /root/repo

   if [ ${?} -gt 0 ]; then
      logE 'Error cd into repo dir'
      cloneGitRepo_exitCode=${EXIT_FAILURE}
   fi

   repo='https://github.com/marklister/overlayRoot.git'

   logT "Cloning git repo: ${repo}"
   git clone "${repo}"

   if [ ${?} -gt 0 ]; then
      logE 'Error occurred cloning git repo'
      cloneGitRepo_exitCode=${EXIT_FAILURE}
   fi

   logT 'Entering repo directory'
   cd overlayRoot

   if [ ${?} -gt 0 ]; then
      logE 'Error cd into repo dir'
      cloneGitRepo_exitCode=${EXIT_FAILURE}
   fi

   logT 'Running overlayRoot installer'
   ./install

   if [ ${?} -gt 0 ]; then
      logE 'Error running overlayRoot installer'
      cloneGitRepo_exitCode=${EXIT_FAILURE}
   fi

   # Repo README.md recommended disabling swap before using overlayRoot:
   #
   #    $ sudo dphys-swapfile swapoff
   #    $ sudo dphys-swapfile uninstall
   #    $ sudo update-rc.d dphys-swapfile remove
   #
   # As dphys-swapfile was already removed in an earlier pi-gen-0w stage, there
   # is nothing more to do here.

   logT 'Exiting repo directory'
   cd "${orig_dir}"

   if [ ${?} -gt 0 ]; then
      logE 'Error cd into orig dir'
      cloneGitRepo_exitCode=${EXIT_FAILURE}
   fi

   logT 'Finishing cloneGitRepo'
   return ${cloneGitRepo_exitCode}
}

main() {
   main_exitCode=${EXIT_SUCCESS}

   cloneGitRepo

   if [ ${?} -gt 0 ]; then
      logE 'cloneGitRepo failed.'
      main_exitCode=${EXIT_FAILURE}
   fi

   return ${main_exitCode}
}

# Do not exit 0! This file is intended to get sourced.

