rtems-vagrant
=============

Build RTEMS for the Beagle(board|bone) using Vagrant!

```bash
host$ vagrant up
```

This will give you an Ubuntu Precise 64-bit system with 
RTEMS downloaded and built. See the `setup-rtems.sh` 
script to change the default branch.

```bash
host$ vagrant ssh
```

This logs you into your new development box.

```bash
rtems-autobuild$ cd $HOME/development/rtems/rtems-tools/tester/
rtems-autobuild$ ./rtems-test --log=bbxm.log --report-mode=all --rtems-bsp=beagleboardxm_qemu --rtems-tools=$HOME/development/rtems/4.11 $HOME/development/rtems/b-beagle/arm-rtems4.11/c/beagleboardxm
```

This will kick off the emulated test suite.

```bash
rtems-autobuild$ cd $HOME/development/rtems/rtems-src/c/src/lib/libbsp/arm/beagle/simscripts
rtems-autobuild$ sh sdcard.sh $HOME/development/rtems/4.11 $HOME/development/rtems/b-beagle/arm-rtems4.11/c/beagleboneblack/testsuites/samples/hello/hello.exe
[...]
rtems-autobuild$ cp bone_hello.exe-sdcard.img /vagrant/
```

This will generate an SD card image suitable for burning to microSD and booting on your hardware, and copy it to your vagrant host.
