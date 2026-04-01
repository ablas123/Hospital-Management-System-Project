FROM php:8.2-apache

# تثبيت ملحقات MySQL
RUN docker-php-ext-install mysqli pdo pdo_mysql

# نسخ ملفات المشروع إلى داخل الحاوية
COPY . /var/www/html/

# إنشاء سكريبت بدء التشغيل (init.php ثم تشغيل Apache)
RUN echo '#!/bin/bash\n\
echo "Running database initialization..."\n\
php /var/www/html/init.php\n\
echo "Starting Apache..."\n\
apache2-foreground' > /usr/local/bin/docker-entrypoint.sh && \
    chmod +x /usr/local/bin/docker-entrypoint.sh

# تحديد نقطة الدخول
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
