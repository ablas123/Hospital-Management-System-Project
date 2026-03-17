# استخدام صورة PHP مع Apache
FROM php:8.1-apache

# تثبيت إضافات PHP الضرورية (مثل mysqli)
RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli

# نسخ ملفات المشروع إلى مجلد Apache
COPY . /var/www/html/

# منح الصلاحيات للمجلدات (إذا لزم الأمر)
RUN chown -R www-data:www-data /var/www/html/
