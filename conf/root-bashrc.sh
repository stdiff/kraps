#!/bin/sh

export PS1='\u@\h:\w\$ '

export JAVA_HOME=/usr/java/latest
export HADOOP_HOME=/usr/local/hadoop
export HIVE_HOME=/usr/local/hive
export DERBY_HOME=/usr/local/derby
export SPARK_HOME=/usr/local/spark

export PATH=$PATH:$JAVA_HOME/bin
export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin
export PATH=$PATH:$HIVE_HOME/bin
export PATH=$PATH:$DERBY_HOME/bin
export PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin

export PYSPARK_PYTHON=/usr/bin/python3

alias grep='grep --color=auto'
alias ls='ls --color'
alias l='ls -alF'
alias la='ls -la'
alias ll='ls -l'



