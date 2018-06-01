#!/bin/sh
set -e
set -u

BASE_DIR=/srv/dubbo
SERVICE_NAME=$2
SERVICE_DIR=$BASE_DIR/$SERVICE_NAME


check() {
  if [ -z $SERVICE_NAME ]; then
    echo "Parameter service name is required"
  else
    if [ ! -d $SERVICE_DIR ]; then
        mkdir -p $SERVICE_DIR
    fi
  fi
}



clean() {
  if [ -d $SERVICE_DIR ]; then
     if [ -d $SERVICE_DIR/bin ]; then
      $SERVICE_DIR/bin/stop.sh
     fi
     rm -rf /$SERVICE_DIR
  fi
}


deploy() {
   cd $BASE_DIR
   if [ -f $SERVICE_NAME*.tar.gz ]; then
     tar xzvf $SERVICE_NAME*.tar.gz
     echo "$SERVICE_DIR/bin"

     $SERVICE_DIR/bin/start.sh
     rm -rf $SERVICE_NAME*.tar.gz
   else
     echo "file $SERVICE_NAME*.tar.gz not found"
   fi
}

check

case "$1" in
    'clean')
        clean
        ;;
    'deploy')
        deploy
        ;;
    *)
    echo "usage: $0 {clean {service-name}|deploy {service-name}}"
    exit 1
    ;;
esac