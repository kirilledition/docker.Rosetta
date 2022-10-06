FROM ubuntu:22.10
LABEL maintainer="Kirill Milash <kirilledition@protonmail.com>"

WORKDIR "/home"
SHELL ["/bin/bash", "-c"]

ENV CPATH="${CPATH}:/home/zlib_pkg/include"
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/home/zlib_pkg/lib"
ENV LIBRARY_PATH="${LIBRARY_PATH}:/home/zlib_pkg/lib"

RUN apt-get update && apt-get -y --no-install-recommends install \
    build-essential \
    clang \
    git \
    wget \
    python3 \
    openmpi-common \
    libopenmpi-dev && \
    ln -s /usr/bin/python3 /usr/bin/python

ARG MAKE_JOBS=4

RUN GIT_SSL_NO_VERIFY=true git clone https://github.com/madler/zlib.git && \
    cd zlib && \
    git checkout tags/v1.2.12 && \
    ./configure --prefix=/home/zlib_pkg && \
    make install -j ${MAKE_JOBS}

ARG USERNAME
ARG PASSWORD

RUN wget \
    --no-check-certificate \
    --user ${USERNAME} \
    --password ${PASSWORD} \
    https://www.rosettacommons.org/downloads/academic/2022/wk11/rosetta.source.release-314.tar.bz2 && \
    tar -xvjf rosetta.source.release-314.tar.bz2

RUN cd /home/rosetta.source.release-314/main/source && \
    ./scons.py \
        -j ${MAKE_JOBS} \
        mode=release \
        extras=mpi \
        ddg_monomer
