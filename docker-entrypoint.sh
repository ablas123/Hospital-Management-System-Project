#!/bin/bash
set -e

DB_HOST="gateway01.eu-central-1.prod.aws.tidbcloud.com"
DB_PORT="4000"
DB_USER="4Q3JgFwtV72XTzm.root"
DB_PASS="hCCzJBE3Ko33HuTW"
DB_NAME="hospital_db"
SSL_CA="/var/www/html/database/ca.pem"
SQL_FILE="/var/www/html/admin/System_backup_file/backup_system1740888810-c25239e543c4328636c1d292120d664e.sql"
TEMP_SQL="/tmp/fixed.sql"

cp "$SQL_FILE" "$TEMP_SQL"

echo "🔧 Fixing SQL file for MySQL 8.0 compatibility..."

# 1. إصلاح القيم الافتراضية
sed -i 's/datetime NOT NULL DEFAULT current_timestamp()/datetime NOT NULL DEFAULT CURRENT_TIMESTAMP/g' "$TEMP_SQL"
sed -i 's/date NOT NULL DEFAULT current_timestamp()/date NOT NULL DEFAULT (CURRENT_DATE)/g' "$TEMP_SQL"
sed -i 's/time NOT NULL DEFAULT current_timestamp()/time NOT NULL DEFAULT "00:00:00"/g' "$TEMP_SQL"

# 2. إزالة أي عبارة USE
sed -i -E 's/^[[:space:]]*USE[[:space:]]+[`]?[a-zA-Z0-9_]+[`]?[[:space:]]*;//g' "$TEMP_SQL"

# 3. إعادة ترتيب الملف: استخراج كل CREATE TABLE أولاً ثم INSERT
# نقوم بإنشاء ملفين مؤقتين
grep -i '^CREATE TABLE' "$TEMP_SQL" > /tmp/create.sql
grep -i '^INSERT INTO' "$TEMP_SQL" > /tmp/insert.sql
cat /tmp/create.sql /tmp/insert.sql > "$TEMP_SQL"

mysql_cmd="mysql --host=$DB_HOST --port=$DB_PORT --user=$DB_USER --password=$DB_PASS --ssl-ca=$SSL_CA"

# التحقق من وجود الجداول
if $mysql_cmd -e "USE $DB_NAME; SHOW TABLES LIKE 'setting';" 2>/dev/null | grep -q setting; then
    echo "✅ Database already initialized. Skipping import."
else
    echo "📥 Initializing database (fresh install)..."
    $mysql_cmd -e "DROP DATABASE IF EXISTS $DB_NAME; CREATE DATABASE $DB_NAME;"
    echo "📤 Importing data..."
    $mysql_cmd "$DB_NAME" < "$TEMP_SQL"
    echo "✅ Database initialization completed."
fi

# بدء Apache
apache2-foreground
