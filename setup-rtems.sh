#!/bin/bash

BUILD_BRANCH=bbxm
TOOLS_BRANCH=bbxm-wip
RTEMS_BRANCH=beaglebone-wip

enosys() {
    local distro=$1
    if [[ "$distro" != "" ]]; then
        echo "Sorry, this script hasn't been extended to include $distro."
    else
        echo "Sorry, this script hasn't been extended to include this platform."
    fi
    exit 1
}

get_buildhost() {
    ostype=$(uname -s)

    case $ostype in
    "Linux")
        has_lsbr=$(lsb_release >/dev/null 2>&1)
        if [ $? -eq 0 ]; then
            distro=$(lsb_release -si)
            if [[ $distro == "Ubuntu" ]]; then
                echo "$distro"
            else
                enosys $distro
            fi
        else
            enosys "Linuxes without lsb_release"
        fi
    ;;
    *)
        enosys $ostype
    ;;
    esac
}

buildhost=$(get_buildhost)
case "$buildhost" in
    Ubuntu)
        DEBIAN_FRONTEND=noninteractive
        apt-get update
        apt-get install -y git
        apt-get build-dep -y binutils gcc g++ gdb unzip git python2.7-dev
        if [ $? -ne 0 ]; then
            exit 1
        fi
    ;;
    *)
        enosys
    ;;
esac


sudo -u vagrant git clone -b "${BUILD_BRANCH}" https://github.com/bengras/rtems-source-builder.git 
sudo -u vagrant git clone -b "${TOOLS_BRANCH}" https://github.com/bengras/rtems-tools.git
sudo -u vagrant git clone -b "${RTEMS_BRANCH}" https://github.com/bengras/rtems.git

# sb-check returns 0 on failed check (but without fatal error), so work around
isok=$(./rtems-source-builder/source-builder/sb-check | grep -c "Environment is ok")
if [[ $? != 0 ]]; then
    echo "sb-check failed. exiting"
    exit 1
fi
