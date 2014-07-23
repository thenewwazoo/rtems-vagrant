#!/bin/bash

SB_BSET="devel/beaglebone_black.bset"
RTEMS_TARGET="arm"
RTEMS_BSP="beagleboneblack"

RTEMS_VERSION="4.11"
export PREFIX=$HOME/development/rtems/${RTEMS_VERSION}
export PATH=$PREFIX/bin:$PATH

cd rtems-source-builder/rtems/
../source-builder/sb-set-builder \
  --log=sb-set-builder.log \
  --prefix="${PREFIX}" \
  --with-rtems \
  "${SB_BSET}"

cd ../../rtems/
./bootstrap
cd ..; mkdir rtems-build; cd rtems-build

../rtems/configure \
    --enable-tests \
    --target=${RTEMS_TARGET}-rtems${RTEMS_VERSION} \
    --enable-rtemsbsp=${RTEMS_BSP}
make all
