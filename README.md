
[TOC]

# dubbo项目(打的tar.gz包)

## 构建镜像
* **删除旧的镜像**
```jshelllanguage
# 删除本地镜像
project_name=dubbo-service-demo
docker images |grep ${project_name}| awk '{print $3}' |xargs docker rmi -f && echo "${project_name} images removed" || echo "${project_name} images does not exist"
```

* **mvn打包构建镜像，并推送docker registry**
> 参见项目pom.xml的dockerfile-maven-plugin插件配置
```jshelllanguage
mvn clean package -Dmaven.test.skip=true
```

## 根据镜像创建容器并运行
```jshelllanguage
project_name=dubbo-service-impl-demo
running_env=default
containner_name=${project_name}-${running_env}
tag=1.0-SNAPSHOT
docker_registry=10.1.221.82:5000
# 停止运行的容器
docker stop ${containner_name} && echo "container ${containner_name} stoped" || echo "container ${containner_name} does not exist"
# 删除容器
docker rm ${containner_name}&& echo "container ${containner_name} removed" || echo "container ${containner_name} does not exist"
# 删除镜像
docker images |grep ${project_name} | awk '{print $3}' |xargs docker rmi -f && echo "${project_name} images removed" || echo "${project_name} images does not exist"
# pull新的镜像
docker pull ${docker_registry}/zc/${project_name}:${tag}
# 基于新的镜像创建容器
docker run -d  --net=host --name ${containner_name} -p 20880:20880 \
-v /dev:/dev \
${docker_registry}/zc/${project_name}:${tag}
```


# springboot项目

## 构建镜像

* **删除旧镜像**
```jshelllanguage
# 删除本地镜像
project_name=springboot-demo
docker images |grep ${project_name}| awk '{print $3}' |xargs docker rmi -f && echo "${project_name} images removed" || echo "${project_name} images does not exist"
```

* **mvn打包构建镜像，并推送docker registry**
> 参见项目pom.xml的dockerfile-maven-plugin插件配置
```jshelllanguage
mvn clean package -Dmaven.test.skip=true
```

## 根据镜像创建容器并运行
```jshelllanguage
project_name=springboot-demo
debug_port=18081
running_env=default
containner_name=${project_name}-${running_env}
docker_registry=10.1.221.82:5000
tag=1.0-SNAPSHOT
# 停止运行的容器
docker stop ${containner_name} && echo "container ${containner_name} stoped" || echo "container ${containner_name} does not exist"
# 删除容器
docker rm ${containner_name}&& echo "container ${containner_name} removed" || echo "container ${containner_name} does not exist"
# 删除镜像
docker images |grep ${project_name} | awk '{print $3}' |xargs docker rmi -f && echo "${project_name} images removed" || echo "${project_name} images does not exist"
# pull新的镜像
docker pull ${docker_registry}/zc/${project_name}:${tag}
# 基于新的镜像创建容器
docker run -d  --name ${containner_name} -p 8081:8081 \
-p ${debug_port}:${debug_port} \
-v /dev:/dev \
${docker_registry}/zc/${project_name}:${tag}
```

# web项目

## 构建镜像

* **删除旧镜像**
```jshelllanguage
#删除本地镜像
project_name=webapp-demo
docker images |grep ${project_name}| awk '{print $3}' |xargs docker rmi -f && echo "${project_name} images removed" || echo "${project_name} images does not exist"

```

* **mvn打包构建镜像，并推送docker registry**
> 参见项目pom.xml的dockerfile-maven-plugin插件配置
```jshelllanguage
mvn clean package -Dmaven.test.skip=true
```

## 根据镜像创建容器并运行
```jshelllanguage
project_name=webapp-demo
debug_port=18881
running_env=default
containner_name=${project_name}-${running_env}
tag=1.0-SNAPSHOT
# 停止运行的容器
docker stop ${containner_name} && echo "container ${containner_name} stoped" || echo "container ${containner_name} does not exist"
# 删除容器
docker rm ${containner_name}&& echo "container ${containner_name} removed" || echo "container ${containner_name} does not exist"
# 删除镜像
docker images |grep ${project_name} | awk '{print $3}' |xargs docker rmi -f && echo "${project_name} images removed" || echo "${project_name} images does not exist"
# pull新的镜像
docker pull 10.1.221.82:5000/zc/${project_name}:${tag}
# 基于新的镜像创建容器
docker run -d  --name ${containner_name} -p 8881:8080 \
-p ${debug_port}:${debug_port} \
-v /dev:/dev \
10.1.221.82:5000/zc/${project_name}:${tag}
```