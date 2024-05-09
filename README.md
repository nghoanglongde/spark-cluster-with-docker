# Run Spark Cluster within Docker

![Untitled Workspace (7)](https://user-images.githubusercontent.com/43443323/153743377-4599a4df-bb1f-4040-828a-326dc22fc352.png)

  
This is the implementation of spark cluster on top of hadoop (1 masternode, 2 slaves node) using Docker

# Follow this steps on Windows 10

### 1. clone github repo
```
# Step 1
https://github.com/nghoanglong/spark-cluster-with-docker.git

# Step 2
cd spark-cluster-with-docker
```
### 2. pull docker image
```
docker pull ghcr.io/nghoanglong/spark-cluster-with-docker/spark-cluster:1.0
```

### 3. start cluster
```
docker-compose up
```

### 4. access site
1. hadoop cluster: http://localhost:50070/
2. hadoop cluster - resource manager: http://localhost:8088/
3. spark cluster: https://localhost:8080/
4. jupyter notebook: https://localhost:8888/
5. spark history server: http://localhost:18080/
6. spark job monitoring: http://localhost:4040/
