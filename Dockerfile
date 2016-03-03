# add a base image
FROM lsucrc/crcbase

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

# clean up tmp
RUN yum clean all
