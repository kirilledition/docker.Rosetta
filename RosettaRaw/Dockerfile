FROM alpine:latest
LABEL maintainer="Kirill Milash <kirilledition@protonmail.com>"

# Migrate to Alpine
#ARG DEBIAN_FRONTEND=noninteractive
ARG USERNAME
ARG PASSWORD
ARG ROSETTACOMMONS_CONDA_USERNAME
ARG ROSETTACOMMONS_CONDA_PASSWORD
ARG MAKE_JOBS=4
ARG BUILD_BINARIES="bin"



RUN echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk --update add \
    bash \
    curl \
    wget \
    ca-certificates \
    libstdc++ \
    glib \
    tini@testing \
    && curl "https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub" -o /etc/apk/keys/sgerrand.rsa.pub \
    && curl -L "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.23-r3/glibc-2.23-r3.apk" -o glibc.apk \
    && apk add glibc.apk \
    && curl -L "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.23-r3/glibc-bin-2.23-r3.apk" -o glibc-bin.apk \
    && apk add glibc-bin.apk \
    && curl -L "https://github.com/andyshinn/alpine-pkg-glibc/releases/download/2.25-r0/glibc-i18n-2.25-r0.apk" -o glibc-i18n.apk \
    && apk add --allow-untrusted glibc-i18n.apk \
    && /usr/glibc-compat/bin/localedef -i en_US -f UTF-8 en_US.UTF-8 \
    && /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc/usr/lib \
    && rm -rf glibc*apk /var/cache/apk/*

RUN apk add alpine-sdk build-base linux-headers perl

ARG OPENMPI_VERSION="4.1.4"
RUN mkdir /tmp/openmpi-src
WORKDIR /tmp/openmpi-src
RUN wget https://www.open-mpi.org/software/ompi/v4.1/downloads/openmpi-${OPENMPI_VERSION}.tar.gz && \
    tar xfz openmpi-${OPENMPI_VERSION}.tar.gz && \
    cd openmpi-${OPENMPI_VERSION} && \
    ./configure && \
    make -j $MAKE_JOBS && \
    make install

ARG FFTW_VERSION="3.3.10"
ARG FFTW_CONFIGURE_OPTIONS="--enable-mpi --enable-static --enable-shared"
RUN mkdir /tmp/fftw-src
WORKDIR /tmp/fftw-src
RUN wget http://www.fftw.org/fftw-${FFTW_VERSION}.tar.gz && \
    tar xfz fftw-${FFTW_VERSION}.tar.gz && \
    cd fftw-${FFTW_VERSION} && \
    ./configure ${FFTW_CONFIGURE_OPTIONS} && \
    make -j $MAKE_JOBS && \
    make install

RUN apk add cmake gfortran gdb
ARG BLAS_VERSION="3.10.0"
RUN mkdir /tmp/blas-src
WORKDIR /tmp/blas-src
RUN wget http://www.netlib.org/blas/blas-${BLAS_VERSION}.tgz && \
    tar xfz blas-${BLAS_VERSION}.tgz && \
    cd BLAS-${BLAS_VERSION} && \
    make -j $MAKE_JOBS && \
    cp blas_LINUX.a /usr/local/lib


ARG LAPACK_VERSION="3.10.1"
RUN mkdir /tmp/lapack-src
WORKDIR /tmp/lapack-src
RUN wget https://codeload.github.com/Reference-LAPACK/lapack/tar.gz/refs/tags/v${LAPACK_VERSION} -O lapack-${LAPACK_VERSION}.tar.gz && \
    tar xfz lapack-${LAPACK_VERSION}.tar.gz && \
    mkdir lapack-build && \
    cd lapack-build && \
    # cmake ../lapack-${LAPACK_VERSION} && \
    cmake ../lapack-${LAPACK_VERSION} -DBUILD_TESTING:BOOL=On &&\
    make -j $MAKE_JOBS && \
    make test && \
    make install
RUN rm -rf /tmp/*


# Configure environment
ENV CONDA_DIR /opt/conda
ENV PATH $CONDA_DIR/bin:$PATH
ENV SHELL /bin/bash
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV MINICONDA_URL https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh


# Install conda
RUN cd /tmp && \
    mkdir -p $CONDA_DIR && \
    curl -L $MINICONDA_URL  -o miniconda.sh && \
    /bin/bash miniconda.sh -f -b -p $CONDA_DIR && \
    rm miniconda.sh

RUN conda update -n base -c conda-forge conda -y
RUN conda upgrade -y pip && \
    conda config --add channels conda-forge && \
    conda clean --all

RUN conda --version

WORKDIR /home

RUN apk add --no-cache wget && \
    wget --no-check-certificate \
    --user ${USERNAME} \
    --password ${PASSWORD} \
    -q \
    https://www.rosettacommons.org/downloads/academic/2022/wk11/rosetta.source.release-314.tar.bz2 -O rosetta.source.release-314.tar.bz2

RUN tar -xvjf rosetta.source.release-314.tar.bz2 && rm -rf rosetta.source.release-314.tar.bz2

RUN cd /home/rosetta.source.release-314/main/source && \
    ./scons.py \
        -j ${MAKE_JOBS} \
        mode=release \
        extras=mpi \
        $BUILD_BINARIES


RUN if [[ -z "$ROSETTACOMMONS_CONDA_USERNAME" ]] ; then echo Not installing pyRosetta ; else conda config --add channels https://${ROSETTACOMMONS_CONDA_USERNAME}:${ROSETTACOMMONS_CONDA_PASSWORD}@conda.graylab.jhu.edu && \
conda install pyrosetta -y
 

ENTRYPOINT ["/sbin/tini", "--"]
CMD [ "/bin/bash" ]
