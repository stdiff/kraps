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

chmod 777 /tmp/hive

nohup $DERBY_HOME/bin/startNetworkServer -h 0.0.0.0 &
schematool -dbType derby -initSchema

hiveserver2 &
hive -f hive-ddl.hql

export HIVE_SERVER2_THRIFT_PORT=10001
start-thriftserver.sh &


#start-thriftserver.sh --hiveconf hive.server2.thrift.port=10001
###starting org.apache.spark.sql.hive.thriftserver.HiveThriftServer2, logging to /usr/local/spark/logs/spark--org.apache.spark.sql.hive.thriftserver.HiveThriftServer2-1-fc0305554091.out





## start bash
/bin/bash
