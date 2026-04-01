FROM php:8.2-apache
RUN docker-php-ext-install mysqli pdo pdo_mysql
COPY . /var/www/html/
RUN echo '#!/bin/bash\n\
echo "Running database initialization..."\n\
php /var/www/html/init.php\n\
echo "Starting Apache..."\n\
apache2-foreground' > /usr/local/bin/docker-entrypoint.sh && \
    chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
