FROM openjdk:8-jdk-alpine
MAINTAINER zhangjie <zhangjie@zcckj.com>
ARG FILE
ARG SERVER_PORT
ADD ${FILE} ./
# Configure ustc alipine software source and timezone
RUN sed -i "s#http://dl-cdn.alpinelinux.org/#https://mirrors.ustc.edu.cn/#g" /etc/apk/repositories && \
    apk update && \
    apk --no-cache add tzdata && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" >  /etc/timezone &&\
    rm -rf /var/cache/apk/*
EXPOSE ${SERVER_PORT}
# To reduce Tomcat startup time we added a system property pointing to "/dev/urandom" as a source of entropy.
