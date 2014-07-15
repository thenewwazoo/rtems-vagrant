rtems-vagrant
=============

Build RTEMS using Vagrant!

```bash
host$ vagrant up
```

This will give you an Ubuntu Precise 64-bit system with 
RTEMS downloaded and ready for build. See the `setup-rtems.sh` 
script to change the default branch.

```bash
host$ vagrant ssh
```

This logs you into your new development box.

```bash
rtems-autobuild$ ./build-rtems.sh
```

This will build everything that can be built, including all
known targets. It's a kitchen-sink build. It will take a 
very long time.
