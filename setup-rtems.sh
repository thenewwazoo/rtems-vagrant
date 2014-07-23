#!/bin/bash

BUILD_BRANCH=beagle
RTEMS_BRANCH=beaglebone-wip
TOOLS_BRANCH=bbxm-wip

GIT_ROOT="https://github.com/thenewwazoo"
GIT_CACHE="/vagrant/git_cache"

echo "Updating host environment..."
DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y git
apt-get build-dep -y binutils gcc g++ gdb unzip git python2.7-dev

mkdir -p development/rtems/sources ; cd development/rtems/sources

echo "Checking out build tools..."
git clone -b "${BUILD_BRANCH}" ${GIT_ROOT}/rtems-source-builder.git  || exit 1

echo "Checking build environment..."
# sb-check returns 0 on failed check (but without fatal error), so work around
sbout=$(./rtems-source-builder/source-builder/sb-check)
isok=$(echo "${sbout}" | grep -c "Environment is ok")
if [[ $? != 0 ]]; then
    echo "sb-check failed: ${sbout}"
    exit 1
else
    echo "${sbout}"
fi

cd rtems-source-builder/rtems
../source-builder/sb-set-builder \
    --log=beagle.txt \
    --prefix=$HOME/development/rtems/4.11 \
    --with-rtems \
    devel/beagle.bset

export PATH=$HOME/development/rtems/4.11/bin:$PATH
cd ~/development/rtems/sources/

echo "Checkout out RTEMS source..."
git clone -b "${RTEMS_BRANCH}" ${GIT_ROOT}/rtems.git || exit 1

echo "Bootstrapping RTEMS..."
cd rtems
./bootstrap ; ./bootstrap -p

echo "Building RTEMS..."
mkdir ~/development/rtems/build ; cd ~/development/rtems/build
~/development/rtems/sources/rtems/configure \
    --target=arm-rtems4.11 \
    --enable-rtemsbsp="beagleboneblack beagleboardxm" \
    --enable-tests
make

echo "Getting testing tools..."
cd ~/development/rtems/sources/
git clone -b "${TOOLS_BRANCH}" ${GIT_ROOT}/rtems-tools.git || exit 1

chown -R vagrant:vagrant *


