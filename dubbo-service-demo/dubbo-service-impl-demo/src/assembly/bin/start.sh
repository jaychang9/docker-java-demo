#!/bin/sh
cd `dirname $0`
BIN_DIR=`pwd`
cd ..
DEPLOY_DIR=`pwd`
CONF_DIR=$DEPLOY_DIR/conf

check_java_env() {
    if [ -z "$JAVA_HOME" -a -z "$JRE_HOME" ]; then
      if $darwin; then
        # Bugzilla 54390
        if [ -x '/usr/libexec/java_home' ] ; then
          export JAVA_HOME=`/usr/libexec/java_home`
        # Bugzilla 37284 (reviewed).
        elif [ -d "/System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK/Home" ]; then
          export JAVA_HOME="/System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK/Home"
        fi
      else
        JAVA_PATH=`which java 2>/dev/null`
        if [ "x$JAVA_PATH" != "x" ]; then
          JAVA_PATH=`dirname $JAVA_PATH 2>/dev/null`
          JRE_HOME=`dirname $JAVA_PATH 2>/dev/null`
        fi
        if [ "x$JRE_HOME" = "x" ]; then
          # XXX: Should we try other locations?
          if [ -x /usr/bin/java ]; then
            JRE_HOME=/usr
          fi
        fi
      fi
      if [ -z "$JAVA_HOME" -a -z "$JRE_HOME" ]; then
        echo "Neither the JAVA_HOME nor the JRE_HOME environment variable is defined"
        echo "At least one of these environment variable is needed to run this program"
        exit 1
      fi
    fi
    if [ -z "$JAVA_HOME" -a "$1" = "debug" ]; then
      echo "JAVA_HOME should point to a JDK in order to run in debug mode."
      exit 1
    fi
    if [ -z "$JRE_HOME" ]; then
      JRE_HOME="$JAVA_HOME"
    fi
}

check_java_env
#source $BIN_DIR/setenv.sh

#USER=dubbo
#GROUP=dubbo

SERVICE_NAME=""
SERVER_PORT=""
SERVER_PROTOCOL=""
#LOGS_FILE=""

if [ -f conf/dubbo.properties ]; then
    SERVICE_NAME=`sed '/dubbo.application.name/!d;s/.*=//' conf/dubbo.properties | tr -d 'r'`
    SERVER_PROTOCOL=`sed '/dubbo.protocol.name/!d;s/.*=//' conf/dubbo.properties | tr -d 'r'`
    SERVER_PORT=`sed '/dubbo.protocol.port/!d;s/.*=//' conf/dubbo.properties | tr -d 'r'`
    #LOGS_FILE=`sed '/dubbo.log4j.file/!d;s/.*=//' conf/dubbo.properties | tr -d 'r'`
fi


if [ -z "$SERVICE_NAME" ]; then
    SERVICE_NAME=`pwd |xargs basename`
fi

PIDS=`ps -f | grep java | grep "$CONF_DIR" |awk '{print $2}'`
if [ -n "$PIDS" ]; then
    echo "ERROR: The $SERVICE_NAME already started!"
    echo "PID: $PIDS"
    exit 1
fi

if [ -n "$SERVER_PORT" ]; then
    SERVER_PORT_COUNT=`netstat -tln | grep :$SERVER_PORT | wc -l`
    if [ $SERVER_PORT_COUNT -gt 0 ]; then
        echo "ERROR: The $SERVICE_NAME port $SERVER_PORT already used!"
        exit 1
    fi
fi

LOGS_DIR="$DEPLOY_DIR/logs"

if [ ! -d $LOGS_DIR ]; then
    mkdir -p $LOGS_DIR
    #chown -R $USER.$GROUP $LOGS_DIR
fi
STDOUT_FILE=$LOGS_DIR/stdout.log

LIB_DIR=$DEPLOY_DIR/lib
LIB_JARS=`ls $LIB_DIR|grep .jar|awk '{print "'$LIB_DIR'/"$0}'|tr "\n" ":"`


JAVA_OPTS=" -Djava.awt.headless=true -Djava.net.preferIPv4Stack=true "
JAVA_DEBUG_OPTS=""
if [ "$1" = "debug" ]; then
    if [ -z "$2" ]; then
        echo "Missing parameter debug port!"
        exit 1
    fi
    if echo "$2" | grep -v '^[0-9]\+$'; then
        echo "Parameter $2 as debug port must be a number!"
        exit 1
    fi
    JAVA_DEBUG_OPTS=" -Xdebug -Xnoagent -Djava.compiler=NONE -Xrunjdwp:transport=dt_socket,address=$2,server=y,suspend=n "
fi
JAVA_JMX_OPTS=""
if [ "$1" = "jmx" ]; then
    JAVA_JMX_OPTS=" -Dcom.sun.management.jmxremote.port=1099 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false "
fi
JAVA_MEM_OPTS=""
BITS=`java -version 2>&1 | grep -i 64-bit`
if [ -n "$BITS" ]; then
    JAVA_MEM_OPTS=" -server -Xmx1g -Xms1g -Xmn720m -XX:PermSize=128m -Xss256k -XX:+DisableExplicitGC -XX:+UseConcMarkSweepGC -XX:+CMSParallelRemarkEnabled -XX:+UseCMSCompactAtFullCollection -XX:LargePageSizeInBytes=128m -XX:+UseFastAccessorMethods -XX:+UseCMSInitiatingOccupancyOnly -XX:CMSInitiatingOccupancyFraction=70 "
else
    JAVA_MEM_OPTS=" -server -Xms256m -Xmx512m -XX:PermSize=128m -XX:SurvivorRatio=2 -XX:+UseParallelGC "
fi

echo -e "Starting the $SERVICE_NAME ...\c"

nohup java $JAVA_OPTS $JAVA_MEM_OPTS $JAVA_DEBUG_OPTS $JAVA_JMX_OPTS -classpath $CONF_DIR:$LIB_JARS com.alibaba.dubbo.container.Main > $STDOUT_FILE 2>&1 &

COUNT=0
while [ $COUNT -lt 1 ]; do
    echo -e ".\c"
    sleep 1
    if [ -n "$SERVER_PORT" ]; then
        if [ "$SERVER_PROTOCOL" == "dubbo" ]; then
            WHICH_NC = `which nc`
            if [ x$WHICH_NC = "x" -o x${WHICH_NC:0:14} = "x/usr/bin/which" ]; then
                COUNT=`netstat -an | grep :$SERVER_PORT | wc -l`
            else
                COUNT=`echo status | nc -i 1 127.0.0.1 $SERVER_PORT | grep -c OK`
            fi
        else
            COUNT=`netstat -an | grep :$SERVER_PORT | wc -l`
        fi
    else
        COUNT=`ps -f | grep java | grep "$DEPLOY_DIR" | awk '{print $2}' | wc -l`
    fi
done

echo "OK!"
PIDS=`ps -f | grep java | grep "$DEPLOY_DIR" | awk '{print $2}'`
echo "PID: $PIDS"
echo "STDOUT: $STDOUT_FILE"
