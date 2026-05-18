#!/bin/bash
set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APACHE_DOCUMENT_ROOT="$PROJECT_ROOT/htdocs"

sed -ri "s!DocumentRoot .*!DocumentRoot ${APACHE_DOCUMENT_ROOT}!g" /etc/apache2/sites-available/000-default.conf

printf '%s\n' \
    "<Directory ${APACHE_DOCUMENT_ROOT}>" \
    "    Options Indexes FollowSymLinks" \
    "    AllowOverride All" \
    "    Require all granted" \
    "</Directory>" \
    > /etc/apache2/conf-available/project-docroot.conf
a2enconf project-docroot >/dev/null

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

if mysql -u root -e "SELECT 1" >/dev/null 2>&1; then
    MYSQL_ROOT_CMD="mysql -u root"
elif mysql -u root -proot -e "SELECT 1" >/dev/null 2>&1; then
    MYSQL_ROOT_CMD="mysql -u root -proot"
else
    MYSQL_ROOT_CMD="mysql -u root --skip-password"
fi

$MYSQL_ROOT_CMD <<SQL
ALTER USER 'root'@'localhost' IDENTIFIED BY '';
CREATE USER IF NOT EXISTS 'root'@'127.0.0.1' IDENTIFIED BY '';
CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '';
ALTER USER 'root'@'127.0.0.1' IDENTIFIED BY '';
ALTER USER 'root'@'%' IDENTIFIED BY '';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'127.0.0.1' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
SQL

if apache2ctl -t; then
    if apache2ctl status >/dev/null 2>&1; then
        apache2ctl graceful
    else
        apache2ctl start
    fi
fi
