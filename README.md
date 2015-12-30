Installing OpenCV on Raspberry Pi 2 B
========

# System Dependencies

Install apt-get dependencies on raspberry pi

    # apt-get install build-essential cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev python-dev python3-dev python-numpy libjpeg-dev libpng-dev libtiff-dev libjasper-dev libdc1394-22-dev python-numpy python3-numpy



# libtbb

Intel Threading Building Blocks library provices software developers iwth a solution for enabling parallelism in C++ applications and libraries.

OpenCV relies on libtbb2, linking against this library should provide better performance, however libtbbs is not shipped by default in raspbian, there are several ways of solving this problem


Download [custom pre-built packages](https://github.com/avolkov/rpi-opencv/raw/master/deb/), [see instructions](libtbb2.md)

Rebuilding libtbb2 source package from Debian Jessie [see instructions](libtbb2.md)


Ignore the problem and or forgo extra performance and not link OpenCV agains libtbb2 by passing `-D WITH_TBB=OFF` to cmake.



# Compile OpenCV 3.0.0 from source


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


    $ cmake -D CMAKE_BUILD_TYPE=RELEASE -D WITH_OPENEXR=OFF -D CMAKE_INSTALL_PREFIX=/usr/local -D WITH_TBB=ON -DOPENCV_EXTRA_MODULES_PATH=opencv_contrib/modules -D WITH_V4L=ON -D INSTALL_C_EXAMPLES=ON -D BUILD_NEW_PYTHON_SUPPORT=ON -D INSTALL_PYTHON_EXAMPLES=ON -D TBB_USE_GCC_BUILTINS=1 -D __TBB_64BIT_ATOMICS=0 opencv


Run make

    $ make -j 4


Install opencv on the system


    # make install


TODO

Verifying that OpenCV was compiled with libtbb support
http://stackoverflow.com/questions/12457885/check-if-opencv-is-compiled-with-tbb?rq=1


# References

1. [OpenCV 3.1.0-dev: installation in Linux](http://docs.opencv.org/master/d7/d9f/tutorial_linux_install.html#gsc.tab=0)
2. [OpenCV Tutorials: Installation in Linux](http://docs.opencv.org/2.4/doc/tutorials/introduction/linux_install/linux_install.html#linux-installation)
3. [Install OpenCV and Python on your Raspberry Pi 2 and B+](http://www.pyimagesearch.com/2015/02/23/install-opencv-and-python-on-your-raspberry-pi-2-and-b/)
