#!/bin/sh
set -euo pipefail
cd /app

GUNICORN_TIMEOUT="${GUNICORN_TIMEOUT:-120}"
GUNICORN_WORKERS="${GUNICORN_WORKERS:-4}"
GUNICORN_LOGLEVEL="${GUNICORN_LOGLEVEL:-info}"
BIND_ADDRESS="${BIND_ADDRESS:-0.0.0.0:80}"

GUNICORN_ARGS="-t ${GUNICORN_TIMEOUT} --workers ${GUNICORN_WORKERS} --bind ${BIND_ADDRESS} --log-level ${GUNICORN_LOGLEVEL}"

GUNITORN_TLS_ARGS=""
if [ ${TLS_ENABLE:-'false'} != "false" ]; then
  GUNITORN_TLS_ARGS="-keyfile ${TLS_KEYFILE} --certfile ${TLS_CERT_FILE} --ca-certs ${TLS_CHAIN_FILE}"
fi

if [ "$1" == gunicorn ]; then
    /bin/sh -c "flask db upgrade"
    exec "$@" $GUNICORN_ARGS $GUNITORN_TLS_ARGS

else
    exec "$@"
fi
