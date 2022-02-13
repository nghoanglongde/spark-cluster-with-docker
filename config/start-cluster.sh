#!/bin/bash

# start hadoop
$HADOOP_HOME/sbin/start-all.sh

# start spark
$SPARK_HOME/sbin/start-all.sh

# start jupyter
jupyter notebook --ip=0.0.0.0 --port=8888 --allow-root --NotebookApp.token=