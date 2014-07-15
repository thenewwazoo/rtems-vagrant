#!/bin/bash

set -e

BUILD_BRANCH=master
TOOLS_BRANCH=master
RTEMS_BRANCH=master

DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y git
apt-get build-dep -y binutils gcc g++ gdb unzip git python2.7-dev

git clone -b "${BUILD_BRANCH}" https://github.com/bengras/rtems-source-builder.git 
git clone -b "${TOOLS_BRANCH}" https://github.com/bengras/rtems-tools.git
git clone -b "${RTEMS_BRANCH}" https://github.com/bengras/rtems.git

chown -R vagrant:vagrant *

# sb-check returns 0 on failed check (but without fatal error), so work around
isok=$(./rtems-source-builder/source-builder/sb-check | grep -c "Environment is ok")
if [[ $? != 0 ]]; then
    echo "sb-check failed. exiting"
    exit 1
fi
