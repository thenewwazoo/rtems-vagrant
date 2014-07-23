#!/bin/bash

BUILD_BRANCH=beagle
RTEMS_BRANCH=beaglebone-wip
TOOLS_BRANCH=bbxm-wip

GIT_ROOT="https://github.com/bengras"

echo "Updating host environment..."
DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y git
apt-get build-dep -y binutils gcc g++ gdb unzip git python2.7-dev

cd /home/vagrant/

mkdir -p development/rtems/sources ; cd development/rtems/sources

echo "Checking out build tools..."
git clone -b "${BUILD_BRANCH}" ${GIT_ROOT}/rtems-source-builder.git  || exit 1

echo "Checking build environment..."
# sb-check returns 0 on failed check (but without fatal error), so ignore the output
./rtems-source-builder/source-builder/sb-check

cd rtems-source-builder/rtems
../source-builder/sb-set-builder \
    --log=beagle.txt \
    --prefix=/home/vagrant/development/rtems/4.11 \
    devel/beagle.bset

export PATH=/home/vagrant/development/rtems/4.11/bin:$PATH
cd /home/vagrant/development/rtems/sources/

echo "Checkout out RTEMS source..."
git clone -b "${RTEMS_BRANCH}" ${GIT_ROOT}/rtems.git rtems-src || exit 1

echo "Bootstrapping RTEMS..."
cd rtems-src
./bootstrap ; ./bootstrap -p

echo "Building RTEMS..."
mkdir /home/vagrant/development/rtems/b-beagle; cd /home/vagrant/development/rtems/b-beagle
CONSOLE_POLLED=1 /home/vagrant/development/rtems-src/sources/rtems/configure \
    --target=arm-rtems4.11 \
    --enable-rtemsbsp="beagleboneblack beagleboardxm" \
    --enable-tests
make

echo "Getting testing tools..."
cd /home/vagrant/development/rtems/
git clone -b "${TOOLS_BRANCH}" ${GIT_ROOT}/rtems-tools.git || exit 1

chown -R vagrant:vagrant /home/vagrant/
