#!/bin/bash

BUILD_BRANCH=bbxm
TOOLS_BRANCH=bbxm-wip
RTEMS_BRANCH=beaglebone-wip

DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get build-dep -y binutils gcc g++ gdb unzip git python2.7-dev

git clone -b "${BUILD_BRANCH}" https://github.com/thenewwazoo/rtems-source-builder.git  || exit 1
git clone -b "${TOOLS_BRANCH}" https://github.com/thenewwazoo/rtems-tools.git || exit 1
git clone -b "${RTEMS_BRANCH}" https://github.com/thenewwazoo/rtems.git || exit 1

chown -R vagrant:vagrant *

# sb-check returns 0 on failed check (but without fatal error), so work around
sbout=$(./rtems-source-builder/source-builder/sb-check)
isok=$(echo "${sbout}" | grep -c "Environment is ok")
if [[ $? != 0 ]]; then
    echo "sb-check failed: ${sbout}"
    exit 1
else
    echo "${sbout}"
fi
