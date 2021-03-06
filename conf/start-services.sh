#!/bin/sh

export JAVA_HOME=/usr/java/latest
export HADOOP_HOME=/usr/local/hadoop
export PATH=$PATH:$HADOOP_HOME/bin

## start sshd 
/usr/sbin/sshd -p 22

## initialize HDFS 
#$HADOOP_HOME/bin/hdfs namenode -format

## start Hadoop
$HADOOP_HOME/sbin/start-dfs.sh
$HADOOP_HOME/sbin/start-yarn.sh

hadoop fs -mkdir -p /user/root

hadoop fs -mkdir /tmp
hadoop fs -mkdir -p /user/hive/warehouse
hadoop fs -chmod g+w /tmp
hadoop fs -chmod g+w /user/hive/warehouse

nohup $DERBY_HOME/bin/startNetworkServer -h 0.0.0.0 &
schematool -dbType derby -initSchema



## start bash
/bin/bash
