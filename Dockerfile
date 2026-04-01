FROM php:8.2-apache

# تثبيت عميل MySQL وملحقات PHP
RUN apt-get update && apt-get install -y default-mysql-client && \
    docker-php-ext-install mysqli pdo pdo_mysql

# نسخ الملفات
COPY . /var/www/html/

# جعل سكريبت الدخول قابلاً للتنفيذ
RUN chmod +x /var/www/html/docker-entrypoint.sh

# تعيين نقطة الدخول
ENTRYPOINT ["/var/www/html/docker-entrypoint.sh"]
