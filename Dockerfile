###################################### >Last Modified on Sat, 27 Oct 2018< 
# docker image for spark
# 
# 
# create docker image from Dockerfile:
# docker build . -t stdiff/hadoop

FROM opensuse:42.2

RUN mkdir /workspace
WORKDIR /workspace

############################################################ utilities
RUN zypper --non-interactive install vim
RUN zypper --non-interactive install wget
RUN zypper --non-interactive install curl
RUN zypper --non-interactive install tar
RUN zypper --non-interactive install which
RUN zypper --non-interactive install less
RUN zypper --non-interactive install net-tools
RUN zypper --non-interactive install glibc-locale
RUN zypper --non-interactive install rsync

############################################################# Python 3
RUN zypper --non-interactive install gcc
RUN zypper --non-interactive install gcc-c++
RUN zypper --non-interactive install python3
RUN zypper --non-interactive install python3-devel
RUN zypper --non-interactive install python3-pip
RUN zypper --non-interactive install python3-h5py
RUN zypper --non-interactive install python3-lxml
RUN zypper --non-interactive install python3-matplotlib
RUN zypper --non-interactive install python3-numpy
RUN zypper --non-interactive install python3-numpy-devel
RUN zypper --non-interactive install python3-opencv
RUN zypper --non-interactive install python3-openpyxl
RUN zypper --non-interactive install python3-pandas
RUN zypper --non-interactive install python3-pytest
RUN zypper --non-interactive install python3-requests
RUN zypper --non-interactive install python3-scipy
RUN zypper --non-interactive install python3-setuptools
RUN zypper --non-interactive install cyrus-sasl-devel
RUN pip install --upgrade pip
RUN pip install scikit-learn
RUN pip install seaborn
RUN pip install jupyter
RUN pip install jupyterlab
RUN pip install pyhive[hive]

################################################################ ssh/d
RUN zypper --non-interactive install openssh

RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN ssh-keygen -q -N "" -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key
RUN ssh-keygen -q -N "" -t ed25519 -f /etc/ssh/ssh_host_ed25519_key
RUN ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa
RUN cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys
RUN chmod 0600 /root/.ssh/authorized_keys

RUN echo "Port 22" >> /etc/ssh/ssh_config
RUN echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config

################################################################# JAVA
COPY download/jdk-8u131-linux-x64.rpm /workspace/jdk-8u131-linux-x64.rpm
RUN rpm -iv jdk-8u131-linux-x64.rpm

ENV JAVA_HOME /usr/java/latest
ENV PATH $PATH:$JAVA_HOME/bin

############################################################### Hadoop
ENV HADOOP_HOME /usr/local/hadoop

COPY download/hadoop-2.9.1.tar.gz /workspace/hadoop-2.9.1.tar.gz
RUN tar xvfz hadoop-2.9.1.tar.gz
RUN mv hadoop-2.9.1 $HADOOP_HOME

COPY conf/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml
COPY conf/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml
COPY conf/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml
COPY conf/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml

RUN sed -i "s|\${JAVA_HOME}|/usr/java/latest|" $HADOOP_HOME/etc/hadoop/hadoop-env.sh

ENV PATH $PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin
RUN mkdir -p /home/hadoop/hadoopinfra/hdfs/{namenode,datanode}
RUN $HADOOP_HOME/bin/hdfs namenode -format

########################################################## Apache Hive
ENV HIVE_HOME /usr/local/hive

COPY download/apache-hive-3.1.0-bin.tar.gz /workspace/apache-hive-3.1.0-bin.tar.gz
RUN tar xvfz apache-hive-3.1.0-bin.tar.gz
RUN mv apache-hive-3.1.0-bin $HIVE_HOME

RUN mv $HIVE_HOME/conf/hive-env.sh.template $HIVE_HOME/conf/hive-env.sh
COPY conf/hive-site.xml $HIVE_HOME/conf/hive-site.xml
ENV PATH $PATH:$HIVE_HOME/bin

######################################################## Apache Derby 
ENV DERBY_HOME /usr/local/derby

COPY download/db-derby-10.14.2.0-bin.tar.gz /workspace/db-derby-10.14.2.0-bin.tar.gz
RUN tar xvfz db-derby-10.14.2.0-bin.tar.gz
RUN mv db-derby-10.14.2.0-bin /usr/local/derby

ENV PATH $PATH:$DERBY_HOME/bin
RUN mkdir $DERBY_HOME/data
COPY conf/jpox.properties $HIVE_HOME/conf/jpox.properties

RUN cp $DERBY_HOME/lib/derbyclient.jar $HIVE_HOME/lib
RUN cp $DERBY_HOME/lib/derbytools.jar $HIVE_HOME/lib

#################################################################### R
#RUN zypper addrepo -f http://download.opensuse.org/repositories/devel\:/languages\:/R\:/patched/openSUSE_Leap_42.2/ R-base
#RUN zypper --non-interactive update 
#RUN zypper --non-interactive install R-base R-base-devel
################################################################ Spark





####################################################### initialization
COPY conf/start-services.sh /workspace/start-services.sh
RUN chmod 755 /workspace/start-services.sh
