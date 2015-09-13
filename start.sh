#!/bin/bash

PORT_MAP_OFFSET=10000
ENABLE_HTTPS=0
ENABLE_HTTP=0

while getopts "p:hs" OPT; do
    case ${OPT} in
        p)
            PORT_MAP_OFFSET=${OPTARG}
            ;;
        s)
            ENABLE_HTTPS=1
            ;;
        h)
            ENABLE_HTTP=1
            ;;
    esac
done

PORT_MAP_HTTP=$((${PORT_MAP_OFFSET} + 80))
PORT_MAP_HTTPS=$((${PORT_MAP_OFFSET} + 443))

if [[ ${ENABLE_HTTP} -eq 0 ]] && [[ ${ENABLE_HTTPS} -eq 0 ]]; then
    echo "HTTP & HTTPS protocols both disabled, no point in running this container"
    exit 1
fi

if [[ ${ENABLE_HTTP} -eq 1 ]]; then
    PORTS_ENABLED="-e 'HTTP_ENABLE=1' -p ${PORT_MAP_HTTP}:80 "
fi

if [[ ${ENABLE_HTTPS} -eq 1 ]]; then
    PORTS_ENABLED="${PORTS_ENABLED} -e 'HTTPS_ENABLE=1' -p ${PORT_MAP_HTTPS}:443"
fi

RUN_HOME="${HOME}/dev/docker/apache-httpd/run_test"

mkdir -p ${RUN_HOME}/logs ${RUN_HOME}/certs ${RUN_HOME}/html

docker run -t -d ${PORTS_ENABLED} -v ${RUN_HOME}/logs:/var/log/apache2 --name=apache-httpd-`date +%Y%m%d%H%M%S` rgibert/apache-httpd:latest

