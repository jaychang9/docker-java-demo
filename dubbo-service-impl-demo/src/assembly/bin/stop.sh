#!/bin/sh
cd `dirname $0`
BIN_DIR=`pwd`
cd ..
DEPLOY_DIR=`pwd`
CONF_DIR=$DEPLOY_DIR/conf

SERVICE_NAME=`sed '/dubbo.application.name/!d;s/.*=//' conf/dubbo.properties | tr -d 'r'`

if [ -z "$SERVICE_NAME" ]; then
    SERVICE_NAME=`pwd |xargs basename`
fi

PIDS=`ps -f | grep java | grep "$CONF_DIR" |awk '{print $2}'`
if [ -z "$PIDS" ]; then
    echo "ERROR: The $SERVICE_NAME does not started!"
    exit 1
fi

#if [ "$1" != "skip" ]; then
#    $BIN_DIR/dump.sh
#fi

echo "Stopping the $SERVICE_NAME ...\c"
for PID in $PIDS ; do
    kill $PID > /dev/null 2>&1
done

COUNT=0
while [ $COUNT -lt 1 ]; do
    echo ".\c"
    sleep 1
    COUNT=1
    for PID in $PIDS ; do
        PID_EXIST=`ps -f -p $PID | grep java`
        if [ -n "$PID_EXIST" ]; then
            COUNT=0
            break
        fi
    done
done

echo "OK!"
echo "PID: $PIDS"
