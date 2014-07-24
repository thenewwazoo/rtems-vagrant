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

echo "Building source tools..."
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
CONSOLE_POLLED=1 /home/vagrant/development/rtems/sources/rtems-src/configure \
    --target=arm-rtems4.11 \
    --enable-rtemsbsp="beagleboneblack beagleboardxm" \
    --enable-tests
make

if [ $? != 0 ]; then
    echo "Make failed!"
    exit 1
fi

echo "Building a hello-world SD card image..."
cd /home/vagrant/development/rtems/sources/rtems-src/c/src/lib/libbsp/arm/beagle/simscripts
sh sdcard.sh \
    /home/vagrant/development/rtems/4.11 \
    /home/vagrant/development/rtems/b-beagle/arm-rtems4.11/c/beagleboneblack/testsuites/samples/hello/hello.exe
if [[ ! -e bone_hello.exe-sdcard.img ]]; then
    echo "Failed to build SD card image."
    exit 1
fi
cp bone_hello.exe-sdcard.img /vagrant/

echo "Getting testing tools..."
cd /home/vagrant/development/rtems/
git clone -b "${TOOLS_BRANCH}" ${GIT_ROOT}/rtems-tools.git || exit 1

echo "Running tests..."
cd rtems-tools/tester
./rtems-test \
    --log=bbxm.log \
    --report-mode=all \
    --rtems-bsp=beagleboardxm_qemu \
    --rtems-tools=/home/vagrant/development/rtems/4.11 \
    /home/vagrant/development/rtems/b-beagle/arm-rtems4.11/c/beagleboardxm

chown -R vagrant:vagrant /home/vagrant/
