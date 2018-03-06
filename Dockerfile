FROM debian:testing

MAINTAINER Camille Perin <camille.perin@protonmail.com>

RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y install apt-utils

RUN apt-get -y install binutils gcc make m4 git cmake g++ wget lzip jam

WORKDIR /app

RUN mkdir INSTALL

RUN wget https://gmplib.org/download/gmp/gmp-6.1.2.tar.lz
RUN tar xf gmp-6.1.2.tar.lz
RUN cd gmp-6.1.2; ./configure --prefix=/app/INSTALL ; make install

RUN wget http://www.mpfr.org/mpfr-current/mpfr-4.0.1.tar.gz
RUN tar xf mpfr-4.0.1.tar.gz
RUN cd mpfr-4.0.1; ./configure --with-gmp=/app/INSTALL --prefix=/app/INSTALL ; make install

RUN wget https://dl.bintray.com/boostorg/release/1.66.0/source/boost_1_66_0.tar.gz
RUN tar xf boost_1_66_0.tar.gz
RUN cd boost_1_66_0; ./bootstrap.sh --with-libraries=thread
RUN cd boost_1_66_0; ./b2 --prefix=/app/INSTALL install

RUN git clone https://github.com/CGAL/cgal.git
RUN mkdir buildCGAL
RUN cd buildCGAL; cmake \
    -DGMP_INCLUDE_DIR=/app/INSTALL/include \
    -DGMP_LIBRARIES=/app/INSTALL/lib \
    -DMPFR_INCLUDE_DIR=/app/INSTALL/include \
    -DMPFR_LIBRARIES=/app/INSTALL/lib \
    -DBOOST_INCLUDEDIR=/app/INSTALL/include \
    -DCMAKE_INSTALL_PREFIX=/app/INSTALL \
    ../cgal

RUN cd buildCGAL; make install
