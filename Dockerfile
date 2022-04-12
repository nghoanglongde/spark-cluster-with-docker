FROM ubuntu:18.04

WORKDIR /root

RUN apt-get update && apt-get install -y \
    python3-pip \
    openssh-server \
    nano \
    openjdk-8-jdk \
    python3.7

RUN pip3 install jupyter && \
    pip3 install pyspark

# download hadoop
RUN wget https://archive.apache.org/dist/hadoop/common/hadoop-2.7.7/hadoop-2.7.7.tar.gz && \
    tar -xzf hadoop-2.7.7.tar.gz && \
    mv hadoop-2.7.7 /usr/local/hadoop && \
    rm hadoop-2.7.7.tar.gz

# download spark
RUN wget https://dlcdn.apache.org/spark/spark-3.2.1/spark-3.2.1-bin-hadoop2.7.tgz && \
    tar -xzf spark-3.2.1-bin-hadoop2.7.tgz && \
    mv spark-3.2.1-bin-hadoop2.7 /usr/local/spark && \
    rm spark-3.2.1-bin-hadoop2.7.tgz

# set environment vars
ENV HADOOP_HOME=/usr/local/hadoop
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV SPARK_HOME=/usr/local/spark
ENV SPARK_MASTER_PORT 7077
ENV HADOOP_CONF_DIR=/usr/local/hadoop/etc/hadoop
ENV LD_LIBRARY_PATH=/usr/local/hadoop/lib/native
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:/usr/local/spark/bin

# ssh without key
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 0600 ~/.ssh/authorized_keys

# copy hadoop configs
COPY config/* /tmp/

RUN mv /tmp/ssh_config ~/.ssh/config && \
    mv /tmp/hadoop-env.sh $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
    mv /tmp/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml && \ 
    mv /tmp/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml && \
    mv /tmp/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml && \
    mv /tmp/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml && \
    mv /tmp/slaves $HADOOP_HOME/etc/hadoop/slaves && \
    mv /tmp/workers $SPARK_HOME/conf/workers && \
    mv /tmp/spark-env.sh $SPARK_HOME/conf/spark-env.sh && \
    mv /tmp/spark-default.conf $SPARK_HOME/conf/spark-default.conf && \
    mv /tmp/start-cluster.sh ~/start-cluster.sh

# create spark-events directory
RUN mkdir /tmp/spark-events && \
    chmod 777 /tmp/spark-events

# remove CRLF
RUN sed -i 's/\r$//g' $HADOOP_HOME/etc/hadoop/slaves
RUN sed -i 's/\r$//g' $HADOOP_HOME/etc/hadoop/hadoop-env.sh
RUN sed -i 's/\r$//g' $SPARK_HOME/conf/workers
RUN sed -i 's/\r$//g' $SPARK_HOME/conf/spark-default.conf
RUN sed -i 's/\r$//g' $SPARK_HOME/conf/spark-env.sh
RUN sed -i 's/\r$//g' ~/start-cluster.sh

# format namenode
RUN $HADOOP_HOME/bin/hdfs namenode -format

