FROM php:8.2-apache

# Install MySQL client and PHP extensions
RUN apt-get update && apt-get install -y default-mysql-client && \
    docker-php-ext-install mysqli pdo pdo_mysql

# Copy project files
COPY . /var/www/html/

# Make the entrypoint script executable
RUN chmod +x /var/www/html/docker-entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/var/www/html/docker-entrypoint.sh"]
