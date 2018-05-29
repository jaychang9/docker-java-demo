FROM openjdk:8-jdk-alpine
MAINTAINER zhangjie <zhangjie@zcckj.com>
ARG FILE
ARG SERVER_PORT
ARG PROJECT_NAME
ADD ${FILE} ./
# Configure ustc alipine software source and timezone
RUN sed -i "s#http://dl-cdn.alpinelinux.org/#https://mirrors.ustc.edu.cn/#g" /etc/apk/repositories && \
    apk update && \
    apk --no-cache add tzdata && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" >  /etc/timezone &&\
    rm -rf /var/cache/apk/* && \
    cd ${PROJECT_NAME} && ls -l && \
EXPOSE ${SERVER_PORT}
CMD["sh","./bin/start.sh"]
