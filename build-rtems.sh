#!/bin/bash

# This script attempts to build absolutely everything in the stable
#  section of the project.

RTEMS_VERSION="4.11"
RTEMS_TARGETS="arm avr bfin h8300 i386 lm32 m32c m32r m68k mips no_cpu powerpc sh sparc"
export PREFIX=$HOME/development/rtems/${RTEMS_VERSION}
export PATH=$PREFIX/bin:$PATH

cd rtems-source-builder/rtems/
../source-builder/sb-set-builder \
  --log=sb-set-builder.log \
  --prefix="${PREFIX}" \
  "${RTEMS_VERSION}/rtems-all.bset"

cd ../../rtems/
./bootstrap
cd ..; mkdir rtems-build; cd rtems-build

for target in $RTEMS_TARGETS; do
    ../rtems/configure --enable-tests --target=${target}-rtems${RTEMS_VERSION}
    make all
done

