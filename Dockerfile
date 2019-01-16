FROM centos:7

MAINTAINER Krittin Phornsiricharoenphant <oatkrittin@gmail.com>

ENV PATH $PATH:/root/bin:/root/miniconda3/bin:/root/pear/bin:/root/FastQC:/root/microbiome_helper

RUN yum -y update && \
  yum -y groupinstall "Development Tools" && \
  yum -y install \
  wget \
  bzip2 \
  unzip \
  perl \
  perl-CPAN \
  git \
  java-1.8.0-openjdk \
  && \
  yum clean all && \
  rm -rf /var/cache/yum/*

# Install Miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
  chmod u+x Miniconda3-latest-Linux-x86_64.sh && \
  ./Miniconda3-latest-Linux-x86_64.sh -b && \
  rm -f Miniconda3-latest-Linux-x86_64.sh && \
  conda config --add channels defaults && \
  conda config --add channels bioconda && \
  conda config --add channels conda-forge

# Install qiime1 and qiime2 
# RUN wget https://data.qiime2.org/distro/core/qiime2-2018.11-py35-linux-conda.yml && \
#   conda create -n qiime1 python=2.7 qiime matplotlib=1.4.3 bowtie2 mock nose -c bioconda && \
#   conda env create -n qiime2 --file qiime2-2018.11-py35-linux-conda.yml && \
#   rm qiime2-2018.11-py35-linux-conda.yml

# Install qiime1
RUN conda install bowtie2

WORKDIR /root
# Install DIAMOND
RUN mkdir /root/bin && \
  wget http://github.com/bbuchfink/diamond/releases/download/v0.9.24/diamond-linux64.tar.gz && \
  tar xzf diamond-linux64.tar.gz && \
  rm -f diamond-linux64.tar.gz && \
  mv diamond bin/.

# Install PEAR
ADD pear-0.9.11-linux-x86_64.tar.gz /root/.

RUN mv /root/pear-0.9.11-linux-x86_64 /root/pear

# Install FastQC
RUN wget http://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.8.zip && \
  unzip fastqc_v0.11.8.zip && \
  chmod u+x FastQC/fastqc && \
  rm -f fastqc_v0.11.8.zip

# Install microbiome_helper perl deps
RUN git clone https://github.com/LangilleLab/microbiome_helper.git && \
  wget -O - http://cpanmin.us | perl - --self-upgrade && \
  cpanm File::Basename Getopt::Long List::Util Parallel::ForkManager Pod::Usage