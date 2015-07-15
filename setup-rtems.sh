#!/bin/bash

RTEMS_BRANCH=master
BUILD_BRANCH=beagle

RTEMS_ROOT="https://github.com/rtems"
BUILD_ROOT="https://github.com/bengras"

echo "Updating host environment..."
DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y git
apt-get build-dep -y binutils gcc g++ gdb unzip git python2.7-dev

cd /home/vagrant/

mkdir -p development/rtems/sources ; cd development/rtems/sources

echo "Checking out source builder..."
git clone -b "${BUILD_BRANCH}" ${BUILD_ROOT}/rtems-source-builder.git  || exit 1

echo "Checking build environment..."
# sb-check returns 0 on failed check (but without fatal error), so ignore the output
./rtems-source-builder/source-builder/sb-check

echo "Building tools..."
cd rtems-source-builder/rtems
../source-builder/sb-set-builder \
    --log=beagle.txt \
    --prefix=/home/vagrant/development/rtems/4.11 \
    devel/beagle.bset

export PATH=/home/vagrant/development/rtems/4.11/bin:$PATH
cd /home/vagrant/development/rtems/

echo "Checkout out RTEMS source..."
git clone -b "${RTEMS_BRANCH}" ${RTEMS_ROOT}/rtems.git rtems-src || exit 1

echo "Bootstrapping RTEMS..."
cd rtems-src
./bootstrap ; ./bootstrap -p

echo "Building RTEMS..."
mkdir /home/vagrant/development/rtems/b-beagle; cd /home/vagrant/development/rtems/b-beagle
CONSOLE_POLLED=1 /home/vagrant/development/rtems/rtems-src/configure \
    --target=arm-rtems4.11 \
    --enable-rtemsbsp="beagleboneblack beagleboardxm"
make

if [ $? != 0 ]; then
    echo "Make failed!"
    exit 1
fi

make install

if [ $? != 0 ]; then
    echo "Install failed!"
    exit 1
fi

echo <<EOF > ~vagrant/.bash_profile
export RTEMS_PREFIX=/home/vagrant/development/rtems/4.11
export RTEMS_MAKEFILE_PATH=/opt/rtems-4.11/arm-rtems4.11/beagleboneblack
export PATH=/home/vagrant/development/rtems/4.11/bin:$PATH
EOF

chown -R vagrant:vagrant /home/vagrant/
