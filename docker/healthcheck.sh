#!/bin/sh
if [ $TLS_ENBALE = true]; then
  exec curl https://localhost/
else
  exec curl http://localhost/
fi