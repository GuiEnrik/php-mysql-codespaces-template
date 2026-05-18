FROM php:8.2-apache

ENV DEBIAN_FRONTEND=noninteractive
ENV APACHE_DOCUMENT_ROOT=/workspaces/htdocs
ENV PHPMYADMIN_VERSION=5.2.2

RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    git \
    libonig-dev \
    libzip-dev \
    mariadb-client \
    mariadb-server \
    nano \
    unzip \
    && docker-php-ext-install mysqli pdo pdo_mysql mbstring zip \
    && rm -rf /var/lib/apt/lists/*

RUN sed -ri 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf && \
    sed -ri 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf && \
    a2enmod rewrite remoteip

RUN curl -fsSL "https://files.phpmyadmin.net/phpMyAdmin/${PHPMYADMIN_VERSION}/phpMyAdmin-${PHPMYADMIN_VERSION}-all-languages.tar.gz" -o /tmp/phpmyadmin.tar.gz && \
    mkdir -p /opt/phpmyadmin && \
    tar -xzf /tmp/phpmyadmin.tar.gz --strip-components=1 -C /opt/phpmyadmin && \
    rm /tmp/phpmyadmin.tar.gz && \
    mkdir -p /opt/phpmyadmin/tmp && \
    chown -R www-data:www-data /opt/phpmyadmin/tmp

RUN printf '%s\n' \
    '<?php' \
    "\$cfg['blowfish_secret'] = 'phpmysqlcodespacestemplatekey123';" \
    '$i = 0;' \
    '$i++;' \
    "\$cfg['Servers'][\$i]['auth_type'] = 'cookie';" \
    "\$cfg['Servers'][\$i]['host'] = '127.0.0.1';" \
    "\$cfg['Servers'][\$i]['port'] = '3306';" \
    "\$cfg['Servers'][\$i]['compress'] = false;" \
    "\$cfg['Servers'][\$i]['AllowNoPassword'] = true;" \
    "\$cfg['TempDir'] = '/opt/phpmyadmin/tmp';" \
    > /opt/phpmyadmin/config.inc.php

RUN printf '%s\n' \
    'RemoteIPHeader X-Forwarded-For' \
    'RemoteIPTrustedProxy 127.0.0.0/8' \
    'RemoteIPTrustedProxy ::1' \
    > /etc/apache2/conf-available/remoteip.conf && \
    a2enconf remoteip

RUN printf '%s\n' \
    'RedirectMatch 302 ^/phpmyadmin$ /phpmyadmin/' \
    'Alias /phpmyadmin /opt/phpmyadmin' \
    '<Directory /opt/phpmyadmin>' \
    '    DirectoryIndex index.php' \
    '    AllowOverride All' \
    '    Require all granted' \
    '</Directory>' \
    > /etc/apache2/conf-available/phpmyadmin.conf && \
    a2enconf phpmyadmin

RUN printf '%s\n' \
    '[mysqld]' \
    'bind-address = 0.0.0.0' \
    > /etc/mysql/mariadb.conf.d/99-codespaces.cnf

RUN printf '%s\n' \
    '#!/bin/bash' \
    'set -e' \
    '' \
    'PROJECT_ROOT="${PROJECT_ROOT:-$(find /workspaces -mindepth 2 -maxdepth 2 -type d -name htdocs -print -quit | sed "s!/htdocs$!!")}"' \
    'APACHE_DOCUMENT_ROOT="${PROJECT_ROOT}/htdocs"' \
    'if [ -d "$APACHE_DOCUMENT_ROOT" ]; then' \
    '    sed -ri "s!DocumentRoot .*!DocumentRoot ${APACHE_DOCUMENT_ROOT}!g" /etc/apache2/sites-available/000-default.conf' \
    '    printf "%s\n" "<Directory ${APACHE_DOCUMENT_ROOT}>" "    Options Indexes FollowSymLinks" "    AllowOverride All" "    Require all granted" "</Directory>" > /etc/apache2/conf-available/project-docroot.conf' \
    '    a2enconf project-docroot >/dev/null' \
    'fi' \
    '' \
    'service mariadb start' \
    '' \
    'for i in {1..30}; do' \
    '    if mysqladmin ping --silent >/dev/null 2>&1; then' \
    '        break' \
    '    fi' \
    '    sleep 1' \
    'done' \
    '' \
    'if mysql -u root -e "SELECT 1" >/dev/null 2>&1; then' \
    '    MYSQL_ROOT_CMD="mysql -u root"' \
    'elif mysql -u root -proot -e "SELECT 1" >/dev/null 2>&1; then' \
    '    MYSQL_ROOT_CMD="mysql -u root -proot"' \
    'else' \
    '    MYSQL_ROOT_CMD="mysql -u root --skip-password"' \
    'fi' \
    '' \
    '$MYSQL_ROOT_CMD <<SQL' \
    "ALTER USER 'root'@'localhost' IDENTIFIED BY '';" \
    "CREATE USER IF NOT EXISTS 'root'@'127.0.0.1' IDENTIFIED BY '';" \
    "CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '';" \
    "ALTER USER 'root'@'127.0.0.1' IDENTIFIED BY '';" \
    "ALTER USER 'root'@'%' IDENTIFIED BY '';" \
    "GRANT ALL PRIVILEGES ON *.* TO 'root'@'127.0.0.1' WITH GRANT OPTION;" \
    "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;" \
    'FLUSH PRIVILEGES;' \
    'SQL' \
    '' \
    'apache2-foreground' \
    > /usr/local/bin/start-services.sh && \
    chmod +x /usr/local/bin/start-services.sh

CMD ["/usr/local/bin/start-services.sh"]
