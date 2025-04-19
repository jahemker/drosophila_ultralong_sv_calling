FROM ubuntu:24.04 AS build

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


FROM ubuntu:24.04

COPY --from=build /usr/local/bin/ /usr/local/bin/

RUN apt-get update && \
    apt-get install -y \
        default-jdk \
        default-jre \
        git \
        python3 \
        python3-pip \
        python-is-python3 && \
    rm -r /var/lib/apt/lists/*

#install sniffles and its dependencies
RUN pip3 install --break-system-packages sniffles

#install cutesv and its dependencies
RUN pip3 install --break-system-packages cuteSV

#Install debreak and its dependencies
RUN pip3 install --break-system-packages pysam

RUN git clone https://github.com/ruanjue/bsalign.git && \
    cd bsalign && \
    make

RUN git clone https://github.com/ruanjue/wtdbg2 && \
    cd wtdbg2 && \
    make

RUN git clone https://github.com/Maggi-Chen/DeBreak.git 

#install svim-asm and its dependencies
RUN git clone https://github.com/eldariont/svim-asm.git && \
    cd svim-asm && \
    pip3 install --break-system-packages .

#install jasmine and its dependencies
RUN git clone https://github.com/mkirsche/Jasmine && \
    cd Jasmine && \
    ./build_jar.sh 

COPY ./scripts/* /scripts/
RUN chmod uga+x /scripts/* && \
    mv /scripts/* /usr/local/bin/

ENV PATH="/DeBreak/:/Jasmine/:/wtdbg2/:/bsalign/:$PATH"
