ARG DISTRIB=debian
ARG VERSION=latest
FROM ${DISTRIB}:${VERSION}

LABEL maintainer="camille.perin@protonmail.com"

RUN apt-get update && apt-get -y --no-install-recommends install apt-utils
RUN apt-get update && apt-get -y --no-install-recommends install binutils gcc make m4 git cmake g++ wget lzip jam

WORKDIR /app

ARG INSTALL_PREFIX=/usr/local

RUN mkdir -p $INSTALL_PREFIX

RUN apt-get update && apt-get -y --no-install-recommends install ca-certificates

# Build of GMP library
RUN wget https://gmplib.org/download/gmp/gmp-6.1.2.tar.lz
RUN tar xf gmp-6.1.2.tar.lz
RUN cd gmp-6.1.2; ./configure --prefix=$INSTALL_PREFIX ; make install

# Build of MPFR library
RUN wget http://www.mpfr.org/mpfr-current/mpfr-4.0.1.tar.gz
RUN tar xf mpfr-4.0.1.tar.gz
RUN cd mpfr-4.0.1; ./configure --with-gmp=$INSTALL_PREFIX --prefix=$INSTALL_PREFIX ; make install

# Build of Boost Thread library
RUN wget https://dl.bintray.com/boostorg/release/1.66.0/source/boost_1_66_0.tar.gz
RUN tar xf boost_1_66_0.tar.gz
RUN cd boost_1_66_0; ./bootstrap.sh --with-libraries=thread
RUN cd boost_1_66_0; ./b2 --prefix=$INSTALL_PREFIX install

# Build of CGAL library
RUN git clone https://github.com/CGAL/cgal.git
RUN mkdir buildCGAL
RUN cd buildCGAL; cmake \
    -DGMP_INCLUDE_DIR=$INSTALL_PREFIX/include \
    -DGMP_LIBRARIES=$INSTALL_PREFIX/lib \
    -DMPFR_INCLUDE_DIR=$INSTALL_PREFIX/include \
    -DMPFR_LIBRARIES=$INSTALL_PREFIX/lib \
    -DBOOST_INCLUDEDIR=$INSTALL_PREFIX/include \
    -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX \
    ../cgal
RUN cd buildCGAL; make install
