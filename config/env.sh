#!/bin/bash

echo "
export JAVA_HOME=${JAVA_HOME}
export HADOOP_HOME=${HADOOP_HOME}
export HADOOP_CONF_DIR=${HADOOP_CONF_DIR}
" >> ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh


