Installing OpenCV on Raspberry Pi 2 B
========

# Dependencies

Install apt-get dependencies on raspberry pi

    # apt-get install build-essential cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev python-dev python3-dev python-numpy libjpeg-dev libpng-dev libtiff-dev libjasper-dev libdc1394-22-dev python-numpy python3-numpy

Install libttb2 and libtbb from debian-armhf repository

    $ wget http://ftp.us.debian.org/debian/pool/main/t/tbb/libtbb-dev_4.2~20140122-5_armhf.deb
    $ wget http://ftp.us.debian.org/debian/pool/main/t/tbb/libtbb2_4.2~20140122-5_armhf.deb
    # dpkg -i libtbb-dev_4.2~20140122-5_armhf.deb libtbb2_4.2~20140122-5_armhf.deb


# Grabbing libtbb2 from debian repo obviously doesn't work.

* Try installing libtbb2 from source package
* Try installing libtbb from source


# Source

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


    cmake -D CMAKE_BUILD_TYPE=RELEASE -D WITH_OPENEXR=OFF -D CMAKE_INSTALL_PREFIX=/usr/local -D WITH_TBB=ON -DOPENCV_EXTRA_MODULES_PATH=opencv_contrib/modules -D WITH_V4L=ON -D INSTALL_C_EXAMPLES=ON -D BUILD_NEW_PYTHON_SUPPORT=ON -D INSTALL_PYTHON_EXAMPLES=ON -D TBB_USE_GCC_BUILTINS=1 -DTBB_64BIT_ATOMICS=0 -D__TBB_64BIT_ATOMICS=0 opencv

For the reasoning behind the use of `-D TBB_USE_GCC_BUILTINS=1 -D TBB_64BIT_ATOMICS=0` see https://software.intel.com/en-us/forums/intel-threading-building-blocks/topic/500680


Run make

    make -j 4


After several tries make still fails with

    Linking CXX static library ../../lib/libopencv_hal.a
    [  7%] Built target opencv_hal
    [  7%] Building CXX object modules/core/CMakeFiles/opencv_core_pch_dephelp.dir/opencv_core_pch_dephelp.cxx.o
    In file included from /usr/include/tbb/tbb_machine.h:252:0,
                     from /usr/include/tbb/aligned_space.h:33,
                     from /usr/include/tbb/tbb.h:43,
                     from /home/pi/opencv_source/opencv/modules/core/include/opencv2/core/private.hpp:65,
                     from /home/pi/opencv_source/opencv/modules/core/src/precomp.hpp:54,
                     from /home/pi/opencv_source/modules/core/opencv_core_pch_dephelp.cxx:1:
    /usr/include/tbb/machine/gcc_armv7.h:39:2: error: #error compilation requires an ARMv7-a architecture.
     #error compilation requires an ARMv7-a architecture.
      ^
    modules/core/CMakeFiles/opencv_core_pch_dephelp.dir/build.make:64: recipe for target 'modules/core/CMakeFiles/opencv_core_pch_dephelp.dir/opencv_core_pch_dephelp.cxx.o' failed
    make[2]: *** [modules/core/CMakeFiles/opencv_core_pch_dephelp.dir/opencv_core_pch_dephelp.cxx.o] Error 1
    CMakeFiles/Makefile2:1744: recipe for target 'modules/core/CMakeFiles/opencv_core_pch_dephelp.dir/all' failed
    make[1]: *** [modules/core/CMakeFiles/opencv_core_pch_dephelp.dir/all] Error 2
    Makefile:137: recipe for target 'all' failed
    make: *** [all] Error 2

Something isn't linking properly when using libtbb2 pulled from Debian.

Try pulling source libtbb2 package and try setting `CXXFLAGS="-DTBB_USE_GCC_BUILTINS=1 -D__TBB_64BIT_ATOMICS=0"`

See https://www.raspberrypi.org/forums/viewtopic.php?t=98551&p=727515

References

1. [OpenCV 3.1.0-dev: installation in Linux](http://docs.opencv.org/master/d7/d9f/tutorial_linux_install.html#gsc.tab=0)
2. [OpenCV Tutorials: Installation in Linux](http://docs.opencv.org/2.4/doc/tutorials/introduction/linux_install/linux_install.html#linux-installation)
3. [Install OpenCV and Python on your Raspberry Pi 2 and B+](http://www.pyimagesearch.com/2015/02/23/install-opencv-and-python-on-your-raspberry-pi-2-and-b/)
