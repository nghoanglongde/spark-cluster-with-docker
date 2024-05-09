#!/bin/bash

# start hadoop and yarn
$HADOOP_HOME/sbin/start-all.sh

# start spark
$SPARK_HOME/sbin/start-all.sh

# start history server
$SPARK_HOME/sbin/start-history-server.sh

# start jupyter
jupyter notebook --ip=0.0.0.0 --port=8888 --allow-root --NotebookApp.token=