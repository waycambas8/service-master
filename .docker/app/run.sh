#!/bin/bash

set -e
/app/run/app.sh

if [ ! -d "/var/log/supervisor" ]; then
    mkdir /var/log/supervisor
fi

/usr/bin/supervisord -n -c /etc/supervisord.d/supervisord.conf
