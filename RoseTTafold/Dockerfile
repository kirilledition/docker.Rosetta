FROM nvidia/cuda:11.8.0-base-ubuntu22.04
LABEL maintainer="Kirill Milash <kirilledition@protonmail.com>"

ARG ROSETTACOMMONS_CONDA_USERNAME
ARG ROSETTACOMMONS_CONDA_PASSWORD

RUN apt-get update --no-install-recommends && \
    apt-get install -y --no-install-recommends git wget libgomp1 unzip && rm -rf /var/lib/apt/lists/*
RUN apt-get clean

RUN wget \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir /root/.conda \
    && bash Miniconda3-latest-Linux-x86_64.sh -b -p /var/conda \
    && rm -f Miniconda3-latest-Linux-x86_64.sh


ENV PATH /var/conda/bin:$PATH
RUN conda --version


WORKDIR /RoseTTaFold
RUN git init && echo * > .gitignore && git remote add origin https://github.com/RosettaCommons/RoseTTAFold.git && git fetch && git checkout origin/main -b main

RUN conda install mamba -n base -c conda-forge

RUN conda env create -f RoseTTAFold-linux.yml
RUN conda env create -f folding-linux.yml

RUN conda config --add channels https://${ROSETTACOMMONS_CONDA_USERNAME}:${ROSETTACOMMONS_CONDA_PASSWORD}@conda.graylab.jhu.edu
#installing pyrosetta into a base image so it gets cached between builds
RUN mamba install -n folding pyrosetta --freeze-installed && conda clean -afy \
    && find /var/conda/ -follow -type f -name '*.a' -delete \
    && find /var/conda/ -follow -type f -name '*.pyc' -delete \
    && find /var/conda/ -follow -type f -name '*.js.map' -delete \
    && find /var/conda/lib/python*/site-packages/bokeh/server/static -follow -type f -name '*.js' ! -name '*.min.js' -delete


RUN wget https://files.ipd.uw.edu/pub/RoseTTAFold/weights.tar.gz && \
    tar xfz weights.tar.gz && \
    rm weights.tar.gz
RUN ./install_dependencies.sh
RUN ln -s /RoseTTaFold/run_e2e_ver.sh /usr/local/bin/run_e2e_ver.sh
RUN ln -s /RoseTTaFold/run_pyrosetta_ver.sh /usr/local/bin/run_pyrosetta_ver.sh

WORKDIR /tmp
