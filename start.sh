#!/bin/bash

# Start SSH server 
/etc/init.d/ssh start

$HADOOP_HOME/bin/hdfs namenode -format
$HADOOP_HOME/sbin/start-dfs.sh
$HADOOP_HOME/sbin/start-yarn.sh
$HADOOP_HOME/sbin/mr-jobhistory-daemon.sh start historyserver


hdfs dfs -mkdir -p    /user/hive/warehouse
hdfs dfs -chmod 777   /tmp
hdfs dfs -chmod g+w   /user/hive/warehouse
hdfs dfs -mkdir /stage
hdfs dfs -chmod g+w /stage
hdfs dfs -chmod g+w /processed

# cp /conf/hive-site.xml $HIVE_HOME/conf/hive-site.xml


# $HIVE_HOME/bin/hiveserver2 --hiveconf hive.server2.enable.doAs=false

tail -f /dev/null