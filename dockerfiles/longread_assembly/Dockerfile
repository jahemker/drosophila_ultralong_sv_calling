FROM ubuntu:20.04 AS build

# Install basic packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        bzip2 \
        cmake \
        curl \
        gcc \
        git \
        libbz2-dev \
        liblzma-dev \
        libncurses5-dev \
        python3 \
        wget \
        zlib1g-dev && \
    rm -r /var/lib/apt/lists/*

# Install minimap2
RUN curl -L https://github.com/lh3/minimap2/releases/download/v2.28/minimap2-2.28_x64-linux.tar.bz2 | tar -jxvf - && \
    mv minimap2-2.28_x64-linux/minimap2 /usr/local/bin/

#Install samtools
RUN wget -q https://github.com/samtools/samtools/releases/download/1.20/samtools-1.20.tar.bz2 \
    && tar -xjf samtools-1.20.tar.bz2 \
    && cd /samtools-1.20 \
    && ./configure \
    && make -j \
    && make install

RUN wget -q https://github.com/samtools/htslib/releases/download/1.20/htslib-1.20.tar.bz2 \
    && tar -xjf htslib-1.20.tar.bz2 \
    && cd /htslib-1.20 \
    && ./configure \
    && make -j \
    && make install

RUN wget -q https://github.com/samtools/bcftools/releases/download/\1.20/bcftools-1.20.tar.bz2 \
    && tar -xjf bcftools-1.20.tar.bz2 \
    && cd /bcftools-1.20 \
    && ./configure \
    && make -j \
    && make install

# install seqkit
RUN wget -q https://github.com/shenwei356/seqkit/releases/\
download/v2.3.0/seqkit_linux_amd64.tar.gz \
 && tar zxf seqkit_linux_amd64.tar.gz \
 && chmod uga+x seqkit \
 && mv seqkit /usr/local/bin

# install dependencies for compleasm
RUN git clone https://github.com/lh3/miniprot && \
    cd miniprot && \
    make && \
    mv miniprot /usr/local/bin

# RUN wget http://eddylab.org/software/hmmer/hmmer-3.3.2.tar.gz && \
#     tar -zxf hmmer-3.3.2.tar.gz && \
#     cd hmmer-3.3.2 && \
#     ./configure --prefix /hmmer && \
#     make && \
#     make check && \
#     make install

# install git lfs for medaka
RUN wget -q https://github.com/git-lfs/git-lfs/releases/download/v3.2.0/git-lfs-linux-amd64-v3.2.0.tar.gz \
 && tar -zxf git-lfs-linux-amd64-v3.2.0.tar.gz \
 && cd git-lfs-3.2.0 \
 && ./install.sh \
 && git lfs install

# install purge_dups
RUN git clone --branch "v1.2.5" https://github.com/dfguan/purge_dups.git \
 && cd purge_dups/src \
 && make -j \
 && for i in $(find . -executable -type f); do mv $i /usr/local/bin/; done

# install yak
RUN git clone https://github.com/lh3/yak \
 && cd yak \
 && make -j \
 && mv yak /usr/local/bin/yak

FROM nvidia/cuda:12.8.1-cudnn-devel-ubuntu20.04
# FROM nvidia/cuda:11.2.1-cudnn8-devel-ubuntu20.04

COPY --from=build /usr/local/bin/ /usr/local/bin/

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        bedtools \
        bzip2 \
        cmake \
        g++ \
        genometools \
        gcc \
        git \
        hmmer \
        libboost-all-dev \
        libbz2-dev \
        libcurl4-openssl-dev \
        libffi-dev \
        libhdf5-dev \
        liblzma-dev \
        libncurses5-dev \
        libssl-dev \
        libzmq5 \
        pigz \
        python3.8 \
        python3-pip \
        python-is-python3 \
        wget \
        zlib1g-dev && \
    rm -r /var/lib/apt/lists/*

# RUN apt-get update \
#  && apt-get install -y \
#     bc \
#     bedtools \
#     bwa \
#     bzip2 \
#     cmake \
#     curl \
#     default-jdk \
#     default-jre \
#     gcc \
#     git \
#     g++ \
#     libboost-all-dev \
#     libbz2-dev \
#     libcurl4-openssl-dev \
#     libffi-dev \
#     libhdf5-dev \
#     liblzma-dev \
#     libncurses5-dev \
#     libssl-dev \
#     libzmq5 \
#     miniasm \
#     parallel \
#     pigz \
#     python3.8 \
#     python3-pip \
#     python-is-python3 \
#     racon \
#     r-base-core \
#     wget \
#     zlib1g-dev \
#  && rm -rf /var/lib/apt/lists/*

# install flye
RUN git clone --branch "2.9.2" https://github.com/fenderglass/Flye.git \
 && cd Flye \
 && python3 setup.py install

# install medaka-cpu
ENV SINGULARITYENV_LC_ALL="C"
RUN pip3 install medaka==1.11.3

# install ragtag
RUN pip3 install RagTag==2.1.0

# install compleasm
RUN pip3 install pandas
RUN git clone --branch "0.2.6" https://github.com/huangnengCSU/compleasm.git && \
    cd compleasm/ && \
    ln -s /compleasm/compleasm.py /usr/local/bin/

# install Dorado
RUN wget -q https://cdn.oxfordnanoportal.com/software/analysis/dorado-0.7.2-linux-x64.tar.gz \
 && tar zxf dorado-0.7.2-linux-x64.tar.gz \
 && rm dorado-0.7.2-linux-x64.tar.gz \
 && ln -s /dorado-0.7.2-linux-x64/bin/dorado /usr/local/bin/