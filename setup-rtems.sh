#!/bin/bash

RTEMS_BRANCH=4.11
BUILD_BRANCH=beagle

RTEMS_ROOT="https://github.com/rtems"
BUILD_ROOT="https://github.com/bengras"

ENV_ROOT=$(pwd)
LOGIN_USER=$(whoami)
echo "Updating host environment..."
DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y git python2.7-dev
apt-get build-dep -y binutils gcc g++ gdb unzip git python2.7-dev

cd "${ENV_ROOT}"

mkdir -p development/rtems/sources ; cd development/rtems/sources

echo "Checking out source builder..."
if [ -d "rtems-source-builder" ]
then
    cd rtems-source-builder && git pull && cd ..
else
    git clone -b "${BUILD_BRANCH}" ${BUILD_ROOT}/rtems-source-builder.git  || exit 1
fi

cd rtems-source-builder
git checkout 1d441d0184c72c3e313bc70df9cc2e284c0cb360
cd ..

find . -name qemu-1-1.cfg -exec sed '/disable-opengl/d' {} \;

echo "Checking build environment..."
# sb-check returns 0 on failed check (but without fatal error), so ignore the output
#./rtems-source-builder/source-builder/sb-check

echo "Building tools..."
cd rtems-source-builder/rtems
../source-builder/sb-set-builder \
    --log=beagle.txt \
    --prefix=${ENV_ROOT}/development/rtems/4.11 \
    devel/beagle.bset || exit 1

export PATH=/development/rtems/4.11/bin:$PATH
cd ${ENV_ROOT}/development/rtems/

echo "Checkout out RTEMS source..."
if [ -d "rtems-src" ]
then
    cd rtems-src && git pull && cd ..
else
    git clone -b "${RTEMS_BRANCH}" ${RTEMS_ROOT}/rtems.git rtems-src || exit 1
fi

echo "Bootstrapping RTEMS..."
cd rtems-src
./bootstrap || exit 1
./bootstrap -p || exit 1

echo "Building RTEMS..."
mkdir ${ENV_ROOT}/development/rtems/b-beagle; cd ${ENV_ROOT}/development/rtems/b-beagle
CONSOLE_POLLED=1 ${ENV_ROOT}/development/rtems/rtems-src/configure \
    --target=arm-rtems4.11 \
    --enable-rtemsbsp="beagleboneblack beagleboardxm" || exit 1
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

echo <<EOF > ~${LOGIN_USER}/.bash_profile
export RTEMS_PREFIX=${ENV_ROOT}/development/rtems/4.11
export RTEMS_MAKEFILE_PATH=/opt/rtems-4.11/arm-rtems4.11/beagleboneblack
export PATH=${ENV_ROOT}/development/rtems/4.11/bin:$PATH

alias go="make && cd ~/build_output/ && ${ENV_ROOT}/development/rtems/rtems-src/c/src/lib/libbsp/arm/beagle/simscripts/sdcard.sh $RTEMS_PREFIX ./beaglebone.exe && cp bone_beaglebone.exe-sdcard.img ${LOGIN_USER}/beaglebone-test1/ && cd -"
EOF

echo 'Be sure to make a symlink from o-optimize to ${ENV_ROOT}/build_output/'
mkdir ${ENV_ROOT}/build_output
chown -R ${LOGIN_USER}:${LOGIN_USER} "${ENV_ROOT}"
