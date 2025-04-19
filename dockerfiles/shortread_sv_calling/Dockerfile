FROM ubuntu:20.04 AS build

# Install basic packages
RUN apt-get update && \
    apt-get install -y \
        bzip2 \
        libbz2-dev \
        cmake \
        curl \
        gcc \
        liblzma-dev \
        libncurses5-dev \
        wget \
        zlib1g-dev && \
    rm -r /var/lib/apt/lists/*

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

# Install sambamba
RUN wget -q https://github.com/biod/sambamba/releases/download/v0.8.2/sambamba-0.8.2-linux-amd64-static.gz \
      && gunzip sambamba-0.8.2-linux-amd64-static.gz \
      && chmod +x sambamba-0.8.2-linux-amd64-static \
      && mv sambamba-0.8.2-linux-amd64-static /usr/local/bin/sambamba


FROM ubuntu:20.04

COPY --from=build /usr/local/bin/ /usr/local/bin/

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        autoconf \
        bwa \
        bzip2 \
        cmake \
        curl \
        default-jdk \
        default-jre \
        g++ \
        git \
        libboost-all-dev \
        libbz2-dev \
        libcurl4-openssl-dev \
        libffi-dev \
        libhdf5-dev \
        liblzma-dev \
        libncurses5-dev \
        libssl-dev \
        libzmq5 \
        python2.7-dev \
        python3.8 \
        python3-pip \
        r-base-core \
        wget \
        zlib1g-dev && \
    rm -r /var/lib/apt/lists/*

#install BBMap + tools
RUN wget -q https://downloads.sourceforge.net/project/bbmap/BBMap_38.96.tar.gz \
    && tar zxf BBMap_38.96.tar.gz \
    && ln -s /bbmap/*.sh /usr/local/bin/ && \
    rm BBMap_38.96.tar.gz

#install jasmine and its dependencies
RUN git clone https://github.com/mkirsche/Jasmine && \
    cd Jasmine && \
    ./build_jar.sh && \
    ln -s /Jasmine/jasmine /usr/local/bin/

# pip2
RUN curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py && \
    python2.7 get-pip.py

# install manta 
# current issue is the configManta.py script calls for python2, maybe I can symlink python2.7 to python2?
RUN wget -q https://github.com/Illumina/manta/releases/download/v1.6.0/manta-1.6.0.centos6_x86_64.tar.bz2 && \
    tar -xjf manta-1.6.0.centos6_x86_64.tar.bz2 && \
    rm manta-1.6.0.centos6_x86_64.tar.bz2

# install lumpy/smoove and dependencies
RUN wget -q https://github.com/brentp/gsort/releases/download/v0.1.4/gsort_linux_amd64 && \
    chmod uga+x /gsort_linux_amd64 && \
    mv /gsort_linux_amd64 /usr/local/bin/gsort

RUN wget -q https://github.com/brentp/mosdepth/releases/download/v0.3.11/mosdepth && \
    chmod uga+x /mosdepth && \
    mv /mosdepth /usr/local/bin/

RUN pip2 install git+https://github.com/hall-lab/svtyper.git

RUN wget -q https://github.com/brentp/smoove/releases/download/v0.2.8/smoove && \
    chmod uga+x smoove && \
    mv smoove /usr/local/bin/

RUN git clone --recursive https://github.com/arq5x/lumpy-sv.git && \
    cd lumpy-sv && \
    make && \
    cp bin/* /usr/local/bin/

# install delly
RUN wget -q https://github.com/dellytools/delly/releases/download/v1.2.6/delly_v1.2.6_linux_x86_64bit && \
    chmod uga+x delly_v1.2.6_linux_x86_64bit && \
    mv delly_v1.2.6_linux_x86_64bit /usr/local/bin/delly

# install gridss
RUN wget -q https://github.com/PapenfussLab/gridss/releases/download/v2.13.2/gridss-2.13.2.tar.gz && \
    mkdir /gridss/ && \
    tar -xzf gridss-2.13.2.tar.gz -C /gridss/ && \
    rm gridss-2.13.2.tar.gz

# get extra scripts from the outside directory.
COPY ./scripts/* /scripts/
RUN chmod uga+x /scripts/* && \
    mv /scripts/vcf_dup_to_ins.py /usr/local/bin/ && \
    mv /scripts/* /gridss/

#install R package for gridss script
RUN R -e "install.packages('BiocManager')" && \
    R -e "BiocManager::install('StructuralVariantAnnotation')" && \
    R -e "install.packages('stringr')"

#alias python2.7 to python2 for manta
RUN echo '#!/bin/bash\npython2.7 "$@"' > /usr/local/bin/python2 && \
    chmod uga+x /usr/local/bin/python2

#add manta to path
ENV PATH="/manta-1.6.0.centos6_x86_64/bin/:/gridss/:$PATH"