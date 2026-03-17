# استخدام صورة PHP مع Apache
FROM php:8.1-apache

# تثبيت إضافات PHP الضرورية (mysqli و pdo_mysql)
RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli
RUN docker-php-ext-install pdo_mysql && docker-php-ext-enable pdo_mysql

# نسخ ملفات المشروع إلى مجلد Apache
COPY . /var/www/html/

# منح الصلاحيات للمجلدات (للكتابة إن لزم)
RUN chown -R www-data:www-data /var/www/html/
