#!/bin/sh
cd `dirname $0`
set -e

start() {
    ./start.sh
}

debug() {
    ./start.sh debug
}

stop() {
    ./stop.sh
}

restart() {
   ./restart.sh
}

dump() {
   ./dump.sh
}

case "$1" in
    'start')
        start
        ;;
    'stop')
        stop
        ;;
    'debug')
        debug
        ;;
    'dump')
        dump
        ;;
    'restart')
        restart
        ;;
    *)
    echo "usage: $0 {start|stop|restart|debug|dump}"
    exit 1
    ;;
esac