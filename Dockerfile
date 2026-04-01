FROM php:8.2-apache

RUN apt-get update && apt-get install -y default-mysql-client && \
    docker-php-ext-install mysqli pdo pdo_mysql

COPY . /var/www/html/

RUN chmod +x /var/www/html/docker-entrypoint.sh

ENTRYPOINT ["/var/www/html/docker-entrypoint.sh"]
