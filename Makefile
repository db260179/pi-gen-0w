# Needed to support spaces in addition to tabs for commands in GNU Make 3.82
# and beyond
.RECIPEPREFIX +=

.PHONY: all \
        continue \
        rebuild-last-stage \
        enter-container \
        clean

all:

   PRESERVE_CONTAINER=1 ./build-docker.sh

continue:

   PRESERVE_CONTAINER=1 CONTINUE=1 ./build-docker.sh

rebuild-last-stage:

   echo 'Place SKIP files in previous stages and press Enter to continue...'; read x
   CLEAN=1 PRESERVE_CONTAINER=1 CONTINUE=1 ./build-docker.sh

enter-container:

   docker run -it --privileged --volumes-from=pigen_work pi-gen /bin/sh

clean:

   docker rm -v pigen_work || /bin/true

