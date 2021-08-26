FROM ubuntu:18.04

RUN apt-get update && apt-get install -y --no-install-recommends \
      openjdk-8-jdk \
      net-tools \
      curl \
      netcat \
      gnupg \
      libsnappy-dev \
      openssh-server \
      vim \
      nano \
      unzip \
      wget \
      rsync \
    && rm -rf /var/lib/apt/lists/*
      
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/

##HADOOP

ENV HADOOP_VERSION=2.7.2
ENV HADOOP_URL https://archive.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz

RUN set -x \
    && curl -fSL "$HADOOP_URL" -o /tmp/hadoop.tar.gz \
    && tar -xvf /tmp/hadoop.tar.gz -C /opt/ \
    && rm /tmp/hadoop.tar.gz*

# RUN ln -s /opt/hadoop-$HADOOP_VERSION/etc/hadoop /etc/hadoop

# RUN mkdir /opt/hadoop-$HADOOP_VERSION/logs

ENV HADOOP_HOME=/opt/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV HADOOP_MAPRED_HOME=$HADOOP_HOME
ENV HADOOP_COMMON_HOME=$HADOOP_HOME
ENV HADOOP_HDFS_HOME=$HADOOP_HOME
ENV YARN_HOME=$HADOOP_HOME
ENV HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
ENV HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib"
# ENV HADOOP_HOME_WARN_SUPPRESS=1
# ENV HADOOP_ROOT_LOGGER="ERROR,DRFA"
# ENV HADOOP_ROOT_LOGGER=DEBUG,console
# ENV HDFS_NAMENODE_USER="root"
# ENV HDFS_DATANODE_USER="root"
# ENV HDFS_SECONDARYNAMENODE_USER="root"
# ENV YARN_RESOURCEMANAGER_USER="root"
# ENV YARN_NODEMANAGER_USER="root"

COPY configs/core-site.xml $HADOOP_HOME/etc/hadoop/
COPY configs/hdfs-site.xml $HADOOP_HOME/etc/hadoop/
COPY configs/mapred-site.xml $HADOOP_HOME/etc/hadoop/
COPY configs/yarn-site.xml $HADOOP_HOME/etc/hadoop/

##HIVE
ENV HIVE_VERSION=2.1.0

RUN set -x \
	&& curl -fSL http://archive.apache.org/dist/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz -o /tmp/hive.tar.gz \
	&& tar -xvf /tmp/hive.tar.gz -C /opt/ \
    && rm /tmp/hive.tar.gz
	
ENV HIVE_HOME=/opt/apache-hive-$HIVE_VERSION-bin

COPY configs/hive-site.xml $HIVE_HOME/conf/
COPY configs/hive-env.sh $HIVE_HOME/conf/

#PYTHON
# RUN apt-get update && apt-get install -y --no-install-recommends \
# 	python3.6 \
# 	python3.6-dev \
# 	python3-pip \
# 	python3.6-venv
# RUN python3.6 -m pip install pip --upgrade
# RUN python3.6 -m pip install wheel
# RUN pip install pandas
# RUN pip install sqlalchemy
# RUN pip install pymysql

#SPARK
# ENV SPARK_VERSION spark-2.4.8-bin-hadoop2.7
# ENV SPARK_URL https://www.apache.org/dist/spark/spark-2.4.8/spark-2.4.8-bin-hadoop2.7.tgz 

# RUN set -x \
#     && curl -fSL "$SPARK_URL" -o /tmp/spark.tar.gz \
#     && tar -xvzf /tmp/spark.tar.gz -C /opt/ \
#     && rm /tmp/spark.tar.gz*

# ENV SPARK_HOME=/opt/$SPARK_VERSION
# ENV PYSPARK_PYTHON=python3.6

#SQOOP

# ENV SQOOP_VERSION=1.4.7
# ENV SQOOP_HOME=/opt/sqoop-${SQOOP_VERSION}.bin__hadoop-2.6.0


# RUN set -x \ 
#     && curl -fSL https://archive.apache.org/dist/sqoop/${SQOOP_VERSION}/sqoop-${SQOOP_VERSION}.bin__hadoop-2.6.0.tar.gz -o /tmp/sqoop.tar.gz \
#     && tar -xvf /tmp/sqoop.tar.gz -C /opt/ \
#     && rm /tmp/sqoop.tar.gz

# RUN mv ${SQOOP_HOME}/conf/sqoop-env-template.sh ${SQOOP_HOME}/conf/sqoop-env.sh

# RUN set -x \  
#     && curl -fSL https://downloads.mysql.com/archives/get/p/3/file/mysql-connector-java-8.0.21.tar.gz -o /tmp/mysql-connector-java-8.0.21.tar.gz \
#     && tar -xvf /tmp/mysql-connector-java-8.0.21.tar.gz -C /tmp/ \
#     && mv /tmp/mysql-connector-java-8.0.21/mysql-connector-java-8.0.21.jar ${SQOOP_HOME}/lib \
#     && rm -r /tmp/mysql-connector-java-8.0.21 \
#     && rm /tmp/mysql-connector-java-8.0.21.tar.gz \
#     && curl https://downloads.apache.org//commons/lang/binaries/commons-lang-2.6-bin.tar.gz -o /tmp/commons-lang-2.6-bin.tar.gz \
#     && tar -xvf /tmp/commons-lang-2.6-bin.tar.gz -C /tmp/ \
#     && mv /tmp/commons-lang-2.6/commons-lang-2.6.jar ${SQOOP_HOME}/lib \
#     && rm -r /tmp/commons-lang-2.6/ \
#     && rm /tmp/commons-lang-2.6-bin.tar.gz


#####

# ENV PATH $HADOOP_HOME/bin/:$HIVE_HOME/bin:$SPARK_HOME/bin:${SQOOP_HOME}/bin:$PATH
ENV PATH $PATH:$HADOOP_HOME/bin:$HIVE_HOME/bin

ENV USER=root

COPY configs/env.sh /tmp/env.sh

RUN \
  ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
  cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
  chmod 0600 ~/.ssh/authorized_keys

ADD /configs/env.sh /env.sh
RUN chmod a+x /env.sh
RUN /env.sh
RUN rm -f /env.sh

RUN mkdir /scripts
RUN mkdir /raw-data
RUN mkdir /processed
# VOLUME ["/scripts", "/raw-data"]

ADD start.sh /start.sh
RUN chmod a+x /start.sh

# EXPOSE 9870 9000 8088 8042 8188 9864

CMD ["sh", "-c", "/start.sh"]