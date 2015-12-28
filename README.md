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

Remove the following in debian/libtbb-dev/usr/include/tbb/machine/gcc_armv7.h

    //TODO: is ARMv7 is the only version ever to support?
    #if !(__ARM_ARCH_7A__)
    #error compilation requires an ARMv7-a architecture.
    #endif


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


    cmake -D CMAKE_BUILD_TYPE=RELEASE -D WITH_OPENEXR=OFF -D CMAKE_INSTALL_PREFIX=/usr/local -D WITH_TBB=ON -DOPENCV_EXTRA_MODULES_PATH=opencv_contrib/modules -D WITH_V4L=ON -D INSTALL_C_EXAMPLES=ON -D BUILD_NEW_PYTHON_SUPPORT=ON -D INSTALL_PYTHON_EXAMPLES=ON -D TBB_USE_GCC_BUILTINS=1 -D __TBB_64BIT_ATOMICS=0 opencv


Run make

    make -j 4


References

1. [OpenCV 3.1.0-dev: installation in Linux](http://docs.opencv.org/master/d7/d9f/tutorial_linux_install.html#gsc.tab=0)
2. [OpenCV Tutorials: Installation in Linux](http://docs.opencv.org/2.4/doc/tutorials/introduction/linux_install/linux_install.html#linux-installation)
3. [Install OpenCV and Python on your Raspberry Pi 2 and B+](http://www.pyimagesearch.com/2015/02/23/install-opencv-and-python-on-your-raspberry-pi-2-and-b/)
