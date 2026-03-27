FROM php:8.2-apache

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    mariadb-server \
    mariadb-client \
    nano \
    git \
    unzip \
    curl \
    && docker-php-ext-install mysqli pdo pdo_mysql \
    && rm -rf /var/lib/apt/lists/*

RUN echo "Listen 8080" > /etc/apache2/ports.conf && \
    sed -i 's/:80/:8080/g' /etc/apache2/sites-available/000-default.conf

RUN printf '%s\n' \
'#!/bin/bash' \
'service mariadb start' \
'' \
'# garante root sem senha' \
'mysql -u root <<EOF' \
"ALTER USER '\''root'\''@'\''localhost'\'' IDENTIFIED BY '\'''\'';" \
"FLUSH PRIVILEGES;" \
"EOF" \
'' \
'apache2-foreground' \
> /usr/local/bin/start-services.sh && chmod +x /usr/local/bin/start-services.sh

CMD ["/usr/local/bin/start-services.sh"]