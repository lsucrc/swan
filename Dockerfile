# add a base image
FROM centos:7

# install dependencies of swan model
RUN yum install -y \ 
    make \
    wget \
    perl \
    gcc-gfortran \
    openmpi \
    openmpi-devel.x86_64 \
    openssh-clients \
    openssh-server

# set up enviroment variables of openmpi
ENV PATH $PATH:/usr/lib64/openmpi/bin
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/usr/lib64/openmpi/lib

# download swan source code and extract it 
WORKDIR /root/
RUN wget http://swanmodel.sourceforge.net/download/zip/swan4101.tar.gz && \
    tar -zxvf swan4101.tar.gz 

# compile swan 
WORKDIR swan4101
RUN make config && make mpi

# set up enviroment variable of swan
ENV PATH $PATH:/root/swan4101
RUN chmod +rx /root/swan4101/swanrun 

# download test data and extract it 
WORKDIR /root
RUN wget http://swanmodel.sourceforge.net/download/zip/refrac.tar.gz && \
    tar -zxvf refrac.tar.gz

# test
WORKDIR /root/refrac
RUN time swanrun -input a11refr -mpi 4

