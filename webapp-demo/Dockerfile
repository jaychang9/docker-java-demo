FROM tomcat:8.5-jre8-alpine
MAINTAINER zhangjie <zhangjie@zcckj.com>
ARG FILE
RUN rm -r ./webapps/*
ADD ${FILE} ./webapps/ROOT.war
# Configure ustc alpine software source and timezone
RUN set -e \
    && sed -i "s#http://dl-cdn.alpinelinux.org/#https://mirrors.ustc.edu.cn/#g" /etc/apk/repositories \
    && apk update \
    && apk --no-cache add tzdata \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" >  /etc/timezone \
    && rm -rf /var/cache/apk/*