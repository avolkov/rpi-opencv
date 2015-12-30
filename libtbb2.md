Installing libtbb2 from Debian Jessie armhf on raspbian
======

There are several ways of installing libtbb2 on your system

# Installing custom-compiled binaries

I have already downloaded the source package, modified the sources and build binary packages.
The easiest way would be to to download [libtbb2](https://github.com/avolkov/rpi-opencv/raw/master/deb/libtbb-dev_4.2%7E20140122-5_armhf.deb) and [libtbb-dev](https://github.com/avolkov/rpi-opencv/raw/master/deb/libtbb2_4.2%7E20140122-5_armhf.deb) from [here](https://github.com/avolkov/rpi-opencv/tree/master/deb) and install them on your local system with this command

    $ wget https://github.com/avolkov/rpi-opencv/raw/master/deb/libtbb-dev_4.2%7E20140122-5_armhf.deb
    # wget https://github.com/avolkov/rpi-opencv/raw/master/deb/libtbb2_4.2%7E20140122-5_armhf.deb
    # dpkg -i libtbb2_4.2~20140122-5_armhf.deb libtbb-dev_4.2~20140122-5_armhf.deb


# Download Debian Jessie armhf packages then make modification on the filesystem

This way is slightly longer, and I haven't actually tried building OpenCV against the modified header files, but this could work.


Download libtbb2 and libtbb-dev from Debian Jessie and install the packages on your local system.


    $ wget http://ftp.us.debian.org/debian/pool/main/t/tbb/libtbb-dev_4.2~20140122-5_armhf.deb
    $ wget http://ftp.us.debian.org/debian/pool/main/t/tbb/libtbb2_4.2~20140122-5_armhf.deb
    # dpkg -i libtbb-dev_4.2~20140122-5_armhf.deb libtbb2_4.2~20140122-5_armhf.deb


Make the following modification to the file `/usr/include/tbb/machine/gcc_armv7.h`

Remove the following lines from the top of `gcc_armv7.h`

    //TODO: is ARMv7 is the only version ever to support?
    #if !(__ARM_ARCH_7A__)
    #error compilation requires an ARMv7-a architecture.
    #endif


On line 56 of the file, replace this macro --

    #define __TBB_full_memory_fence() __asm__ __volatile__("dmb ish": : :"memory")

With the following --

    #define __TBB_full_memory_fence() 0xffff0fa0


# Compile libtbb source packages

This is the longest way to do the job, it takes several hours to compile libtbb2 on Raspberry Pi 2 even with parallel compile option enabled. You have been warned.

Download the source

    $ mkdir tbb
    $ cd tbb
    $ wget http://http.debian.net/debian/pool/main/t/tbb/tbb_4.2~20140122-5.dsc
    $ wget http://http.debian.net/debian/pool/main/t/tbb/tbb_4.2~20140122.orig.tar.gz
    $ wget http://http.debian.net/debian/pool/main/t/tbb/tbb_4.2~20140122-5.debian.tar.xz


Extract the source into build directory with `dpkg-source` command. [dpkg-source quick reference](http://ftp.debian.org/debian/doc/source-unpack.txt)

    $ dpkg-source -x tbb_4.2~20140122-5.dsc

Set `-D TBB_USE_GCC_BUILTINS=1 -D __TBB_64BIT_ATOMICS=0` CXXFLAGS in source package

    $ cd tbb-4.2~20140122
    $ vi debian/rules


Set the line 9 with CXXFLAGS from

    CXXFLAGS=$(CPPFLAGS)

To. See [Raspberry pi compilation errors thread](https://software.intel.com/en-us/forums/intel-threading-building-blocks/topic/500680) for explanation.

    CXXFLAGS+=-D TBB_USE_GCC_BUILTINS=1 -D __TBB_64BIT_ATOMICS=0 $(CPPFLAGS)


Remove the following in `include/tbb/machine/gcc_armv7.h` and `debian/libtbb-dev/usr/include/tbb/machine/gcc_armv7.h`


    //TODO: is ARMv7 is the only version ever to support?
    #if !(__ARM_ARCH_7A__)
    #error compilation requires an ARMv7-a architecture.
    #endif


Replace the line 56 of the same file containing

    #define __TBB_full_memory_fence() __asm__ __volatile__("dmb ish": : :"memory")

With the following:

    #define __TBB_full_memory_fence() 0xffff0fa0

In order to prevent the error `error compilation requires an ARMv7-a architecture.` even though Raspberry Pi 2 runs on armv7-a, there's something is wrong with the compiling option when defining the architecture.

For more information about the workaround see [Compile OpenCV with TBB on Raspberry Pi 2](http://stackoverflow.com/questions/30131032/compile-opencv-with-tbb-on-raspberry-pi-2)


Use 2 threads instead of 4 (the number of CPUs) because of the high memory usage raspberry pi will run out of physical memory and will use swap significantly slowing down build process.
[Parallel compilation speedup](http://askubuntu.com/a/353869/373573)

    export DEB_BUILD_OPTIONS="parallel=2"


Rebuild package with the following command

    $ dpkg-buildpackage -rfakeroot -uc -b


Find the built packages in the top-level directory

* libtbb2_4.2~20140122-5_armhf.deb
* libtbb2-dbg_4.2~20140122-5_armhf.deb
* libtbb-dev_4.2~20140122-5_armhf.deb
* libtbb-doc_4.2~20140122-5_all.deb
* tbb-examples_4.2~20140122-5_armhf.deb


# Install libtbb2 and libtbb-dev

    # dpkg -i libtbb2_4.2~20140122-5_armhf.deb libtbb-dev_4.2~20140122-5_armhf.deb
