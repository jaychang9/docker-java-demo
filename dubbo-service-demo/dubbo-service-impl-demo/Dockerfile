FROM openjdk:8-jdk-alpine
MAINTAINER zhangjie <zhangjie@zcckj.com>
ARG FILE
ARG SERVER_PORT
ARG PROJECT_NAME
WORKDIR /${PROJECT_NAME}
ADD ${FILE} /
# Configure ustc alipine software source and timezone
RUN set -x && \
    sed -i "s#http://dl-cdn.alpinelinux.org/#https://mirrors.ustc.edu.cn/#g" /etc/apk/repositories && \
    apk update && \
    apk --no-cache add tzdata && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" >  /etc/timezone && \
    rm -rf /var/cache/apk/* && rm -rf /${FILE} && \
    cd /${PROJECT_NAME}/bin && \
    chmod +x *.sh
VOLUME /${PROJECT_NAME}/conf
VOLUME /${PROJECT_NAME}/logs
EXPOSE ${SERVER_PORT}
CMD ["./bin/start.sh","docker"]