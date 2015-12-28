Installing OpenCV on Raspberry Pi 2 B
========

Install apt-get dependencies on raspberry pi

    # apt-get install build-essential cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev python-dev python3-dev python-numpy libjpeg-dev libpng-dev libtiff-dev libjasper-dev libdc1394-22-dev python-numpy python3-numpy

Install libttb2 and libtbb from debian-armhf repository

    $ wget http://ftp.us.debian.org/debian/pool/main/t/tbb/libtbb-dev_4.2~20140122-5_armhf.deb
    $ wget http://ftp.us.debian.org/debian/pool/main/t/tbb/libtbb2_4.2~20140122-5_armhf.deb
    # dpkg -i libtbb-dev_4.2~20140122-5_armhf.deb libtbb2_4.2~20140122-5_armhf.deb


Download OpenCV from github

    $ mkdir opencv_source
    $ cd opencv_source
    $ git clone https://github.com/itseez/opencv
    $ git clone https://github.com/itseez/opencv-contrib
    $ cd ..

Checkout `3.0.0` branch




References

1. [OpenCV 3.1.0-dev: installation in Linux](http://docs.opencv.org/master/d7/d9f/tutorial_linux_install.html#gsc.tab=0)
2. [OpenCV Tutorials: Installation in Linux](http://docs.opencv.org/2.4/doc/tutorials/introduction/linux_install/linux_install.html#linux-installation)
3. [Install OpenCV and Python on your Raspberry Pi 2 and B+](http://www.pyimagesearch.com/2015/02/23/install-opencv-and-python-on-your-raspberry-pi-2-and-b/)
