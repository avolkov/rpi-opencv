Installing libtbb2 from Debian Jessie armhf on raspbian
======

There are several ways of installing libtbb2 on your system

# Installing custom-compiled binaries

I have already downloaded the source package, modified the sources and build binary packages.
The easiest way would be to to download libtbb2 and libtbb-dev from [here]() and install them on your local system with this command

    # dpkg -i libtbb2_4.2~20140122-5_armhf.deb libtbb-dev_4.2~20140122-5_armhf.deb


# Downloading Debian Jessie armhf binary packages then making modification on the filesystem

This way is slightly longer, and I haven't actually tried building OpenCV against the modified header files, but this could work.

1. Download libtbb2 and libtbb-dev from Debian Jessie and install the packages on your local system.

    $ wget http://ftp.us.debian.org/debian/pool/main/t/tbb/libtbb-dev_4.2~20140122-5_armhf.deb
    $ wget http://ftp.us.debian.org/debian/pool/main/t/tbb/libtbb2_4.2~20140122-5_armhf.deb
    # dpkg -i libtbb-dev_4.2~20140122-5_armhf.deb libtbb2_4.2~20140122-5_armhf.deb


2. Make the following modification to the file `/usr/include/tbb/machine/gcc_armv7.h`

Remove the following lines from the top of `gcc_armv7.h`

    //TODO: is ARMv7 is the only version ever to support?
    #if !(__ARM_ARCH_7A__)
    #error compilation requires an ARMv7-a architecture.
    #endif


On line 56 of the file, replace this macro --

    #define __TBB_full_memory_fence() __asm__ __volatile__("dmb ish": : :"memory")

With the following --

    #define __TBB_full_memory_fence() 0xffff0fa0

Now proceed to compiling OpenCV


#