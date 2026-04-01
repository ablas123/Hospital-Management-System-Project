#!/bin/bash
set -e

DB_HOST="gateway01.eu-central-1.prod.aws.tidbcloud.com"
DB_PORT="4000"
DB_USER="4Q3JgFwtV72XTzm.root"
DB_PASS="hCCzJBE3Ko33HuTW"
DB_NAME="hospital_db"
SSL_CA="/var/www/html/database/ca.pem"
SQL_FILE="/var/www/html/admin/System_backup_file/backup_system1740888810-c25239e543c4328636c1d292120d664e.sql"

# إصلاح ملف SQL قبل الاستيراد
if [ -f "$SQL_FILE" ]; then
    echo "Fixing SQL file (invalid DEFAULT values for DATE/TIME columns)..."

    # 1. إصلاح أعمدة TIME التي تستخدم current_timestamp() -> تغيير إلى "00:00:00"
    sed -i 's/`appointment_time` time NOT NULL DEFAULT current_timestamp()/`appointment_time` time NOT NULL DEFAULT "00:00:00"/g' "$SQL_FILE"

    # 2. إصلاح أعمدة DATE التي تستخدم current_timestamp() -> تغيير إلى DEFAULT (CURRENT_DATE)
    sed -i 's/`created_at` date NOT NULL DEFAULT current_timestamp()/`created_at` date NOT NULL DEFAULT (CURRENT_DATE)/g' "$SQL_FILE"
    sed -i 's/`updated_at` date NOT NULL DEFAULT current_timestamp()/`updated_at` date NOT NULL DEFAULT (CURRENT_DATE)/g' "$SQL_FILE"

    # 3. في حال وجود أي عمود DATE آخر بنفس المشكلة (مثلاً birth_date, appointment_date)
    sed -i 's/\(`[a-z_]*_date` date NOT NULL DEFAULT\) current_timestamp()/\1 (CURRENT_DATE)/g' "$SQL_FILE"
fi

mysql_cmd="mysql --host=$DB_HOST --port=$DB_PORT --user=$DB_USER --password=$DB_PASS --ssl-ca=$SSL_CA"

# التحقق من وجود الجداول مسبقاً
if $mysql_cmd -e "USE $DB_NAME; SHOW TABLES LIKE 'setting';" 2>/dev/null | grep -q setting; then
    echo "Database already initialized. Skipping import."
else
    echo "Initializing database..."
    $mysql_cmd -e "DROP DATABASE IF EXISTS $DB_NAME; CREATE DATABASE $DB_NAME;"
    $mysql_cmd $DB_NAME < "$SQL_FILE"
    echo "Database initialization completed."
fi

# بدء Apache
apache2-foreground
