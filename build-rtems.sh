#!/bin/bash

# This script attempts to build absolutely everything in the stable
#  section of the project.

RTEMS_VERSION="4.11"
export PREFIX=$HOME/development/rtems/${RTEMS_VERSION}
export PATH=$PREFIX/bin:$PATH

cd rtems-source-builder/rtems/
../source-builder/sb-set-builder \
  --log=sb-set-builder.log \
  --prefix="${PREFIX}" \
  --with-rtems \
  "devel/beaglebone_black.bset"

#cd ../../rtems/
#./bootstrap
#cd ..; mkdir rtems-build; cd rtems-build
#
#../rtems/configure \
#    --enable-tests \
#    --target=${target}-rtems${RTEMS_VERSION} \
#    --enable-rtemsbsp=beagleboneblack
#make all
