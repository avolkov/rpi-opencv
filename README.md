Installing OpenCV on Raspberry Pi 2 B
========

# Dependencies

Install apt-get dependencies on raspberry pi

    # apt-get install build-essential cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev python-dev python3-dev python-numpy libjpeg-dev libpng-dev libtiff-dev libjasper-dev libdc1394-22-dev python-numpy python3-numpy

Install libttb2 and libtbb from debian-armhf repository

    $ wget http://ftp.us.debian.org/debian/pool/main/t/tbb/libtbb-dev_4.2~20140122-5_armhf.deb
    $ wget http://ftp.us.debian.org/debian/pool/main/t/tbb/libtbb2_4.2~20140122-5_armhf.deb
    # dpkg -i libtbb-dev_4.2~20140122-5_armhf.deb libtbb2_4.2~20140122-5_armhf.deb

Package pages in Debian Jessie

* [libtbb2](https://packages.debian.org/jessie/libtbb2)
* [libtbb-dev](https://packages.debian.org/jessie/libtbb-dev)

Download tbb source package and rebuild it from source in raspbian

## libtbb2

In order to use OpenCV parallel execution functionality, and avoid the following errors associated with using libtbb2 binary packages from debian armhf library:

    #error compilation requires an ARMv7-a architecture.
      ^
    modules/core/CMakeFiles/opencv_core_pch_dephelp.dir/build.make:64: recipe for target 'modules/core/CMakeFiles/opencv_core_pch_dephelp.dir/opencv_core_pch_dephelp.cxx.o' failed
    make[2]: *** [modules/core/CMakeFiles/opencv_core_pch_dephelp.dir/opencv_core_pch_dephelp.cxx.o] Error 1
    CMakeFiles/Makefile2:1744: recipe for target 'modules/core/CMakeFiles/opencv_core_pch_dephelp.dir/all' failed
    make[1]: *** [modules/core/CMakeFiles/opencv_core_pch_dephelp.dir/all] Error 2
    Makefile:137: recipe for target 'all' failed
    make: *** [all] Error 2

Build libtbb2 and libtbb-dev packages from source Debian Jessie packages.


Downloading the source

    $ mkdir tbb
    $ cd tbb
    $ wget http://http.debian.net/debian/pool/main/t/tbb/tbb_4.2~20140122-5.dsc
    $ wget http://http.debian.net/debian/pool/main/t/tbb/tbb_4.2~20140122.orig.tar.gz
    $ wget http://http.debian.net/debian/pool/main/t/tbb/tbb_4.2~20140122-5.debian.tar.xz


Extracting the source into build directory with `dpkg-source` command. [dpkg-source quick reference](http://ftp.debian.org/debian/doc/source-unpack.txt)

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


On line 56 of the same file, replace

    #define __TBB_full_memory_fence() __asm__ __volatile__("dmb ish": : :"memo    ry")

With the following:

    #define __TBB_full_memory_fence() 0xffff0fa0

In order to prevent the error `error compilation requires an ARMv7-a architecture.` even though Raspberry Pi 2 runs on armv7-a something is wrong with the compiling option when defining the archtecture.

For more information about workaround see [Compile OpenCV with TBB on Raspberry Pi 2](http://stackoverflow.com/questions/30131032/compile-opencv-with-tbb-on-raspberry-pi-2)

Parallel compilation speedup [source](http://askubuntu.com/a/353869/373573)

Use 2 threads instead of 4 (the number of CPUs) because of the high memory usage raspberry pi will run out of physical memory and will use swap significantly slowing down build process.


    export DEB_BUILD_OPTIONS="parallel=2"


Rebuild package with the following command

    $ dpkg-buildpackage -rfakeroot -uc -b


Find the built packages in the top-level directory

* libtbb2_4.2~20140122-5_armhf.deb
* libtbb2-dbg_4.2~20140122-5_armhf.deb
* libtbb-dev_4.2~20140122-5_armhf.deb
* libtbb-doc_4.2~20140122-5_all.deb
* tbb-examples_4.2~20140122-5_armhf.deb


Install libtbb2 and libtbb-dev

    # dpkg -i libtbb2_4.2~20140122-5_armhf.deb libtbb-dev_4.2~20140122-5_armhf.deb


# Building OpenCV 3.0.0 from source


Download OpenCV from github

    $ mkdir opencv_source
    $ cd opencv_source
    $ git clone https://github.com/itseez/opencv
    $ git clone https://github.com/itseez/opencv_contrib
    $ cd ..

Checkout `3.0.0` branch for opencv

    $ cd opencv
    $ git checkout tags/3.0.0 -b  3.0.0
    $ cd ../

Checkout `3.0.0` branch for opencv_contrib

    $ cd opencv_contrib
    $ git checkout tags/3.0.0 -b  3.0.0
    $ cd ../



# Compile

Run cmake from top-level directory to build configuration files


    cmake -D CMAKE_BUILD_TYPE=RELEASE -D WITH_OPENEXR=OFF -D CMAKE_INSTALL_PREFIX=/usr/local -D WITH_TBB=ON -DOPENCV_EXTRA_MODULES_PATH=opencv_contrib/modules -D WITH_V4L=ON -D INSTALL_C_EXAMPLES=ON -D BUILD_NEW_PYTHON_SUPPORT=ON -D INSTALL_PYTHON_EXAMPLES=ON -D TBB_USE_GCC_BUILTINS=1 -D __TBB_64BIT_ATOMICS=0 -march=armv7-a -mtune=cortex-a7 -mfpu=neon opencv


Run make

    make -j 4


New error

    [ 36%] Generating opencl_kernels_core.cpp, opencl_kernels_core.hpp
    Scanning dependencies of target opencv_core
    [ 36%] [ 36%] [ 36%] Building CXX object modules/core/CMakeFiles/opencv_core.dir/src/datastructs.cpp.o
    Building CXX object modules/core/CMakeFiles/opencv_core.dir/src/lpsolver.cpp.o
    Building CXX object modules/core/CMakeFiles/opencv_core.dir/src/gl_core_3_1.cpp.o
    [ 36%] Built target pch_Generate_opencv_test_stitching
    [ 36%] Building CXX object modules/core/CMakeFiles/opencv_core.dir/src/parallel.cpp.o
    /tmp/cc4pp3Ga.s: Assembler messages:
    /tmp/cc4pp3Ga.s:191: Error: selected processor does not support ARM mode `dmb ish'
    /tmp/cc4pp3Ga.s:379: Error: selected processor does not support ARM mode `dmb ish'
    /tmp/cc4pp3Ga.s:404: Error: selected processor does not support ARM mode `dmb ish'
    /tmp/cc4pp3Ga.s:495: Error: selected processor does not support ARM mode `dmb ish'
    modules/core/CMakeFiles/opencv_core.dir/build.make:150: recipe for target 'modules/core/CMakeFiles/opencv_core.dir/src/parallel.cpp.o' failed
    make[2]: *** [modules/core/CMakeFiles/opencv_core.dir/src/parallel.cpp.o] Error 1
    make[2]: *** Waiting for unfinished jobs....
    CMakeFiles/Makefile2:1678: recipe for target 'modules/core/CMakeFiles/opencv_core.dir/all' failed
    make[1]: *** [modules/core/CMakeFiles/opencv_core.dir/all] Error 2
    Makefile:137: recipe for target 'all' failed
    make: *** [all] Error 2

Try setting up these parameters: `-march=armv7-a`

    export CFLAGS=-march=armv7-a

this flag doesn't work see stack overflow answer instead -- http://stackoverflow.com/questions/30131032/compile-opencv-with-tbb-on-raspberry-pi-2

Or more params ([taken from raspberry.org](https://www.raspberrypi.org/forums/viewtopic.php?f=54&t=98517))

    -march=armv7-a -mtune=cortex-a7 -mfpu=neon



References

1. [OpenCV 3.1.0-dev: installation in Linux](http://docs.opencv.org/master/d7/d9f/tutorial_linux_install.html#gsc.tab=0)
2. [OpenCV Tutorials: Installation in Linux](http://docs.opencv.org/2.4/doc/tutorials/introduction/linux_install/linux_install.html#linux-installation)
3. [Install OpenCV and Python on your Raspberry Pi 2 and B+](http://www.pyimagesearch.com/2015/02/23/install-opencv-and-python-on-your-raspberry-pi-2-and-b/)
