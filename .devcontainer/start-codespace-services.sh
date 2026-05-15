#!/bin/bash
set -e

if ! mysqladmin ping --silent >/dev/null 2>&1; then
    install -m 755 -o mysql -g root -d /run/mysqld
    start-stop-daemon --start --background --chuid mysql --exec /usr/sbin/mariadbd -- \
        --user=mysql \
        --pid-file=/run/mysqld/mysqld.pid \
        --socket=/run/mysqld/mysqld.sock

    for i in {1..30}; do
        if mysqladmin ping --silent >/dev/null 2>&1; then
            break
        fi
        sleep 1
    done
fi

apache2ctl start
