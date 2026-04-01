#!/bin/bash
set -e

DB_HOST="gateway01.eu-central-1.prod.aws.tidbcloud.com"
DB_PORT="4000"
DB_USER="4Q3JgFwtV72XTzm.root"
DB_PASS="hCCzJBE3Ko33HuTW"
DB_NAME="hospital_db"
SSL_CA="/var/www/html/database/ca.pem"
SQL_FILE="/var/www/html/admin/System_backup_file/backup_system1740888810-c25239e543c4328636c1d292120d664e.sql"

echo "🔌 Testing connection to TiDB Cloud..."
mysql_cmd="mysql --host=$DB_HOST --port=$DB_PORT --user=$DB_USER --password=$DB_PASS --ssl-ca=$SSL_CA"

# اختبار الاتصال (سيظهر خطأ إن فشل)
if ! $mysql_cmd -e "SELECT 1;" >/dev/null 2>&1; then
    echo "❌ Cannot connect to database. Please check credentials and SSL certificate."
    exit 1
fi

# إنشاء قاعدة البيانات (بدون تجاهل الأخطاء)
echo "📦 Creating database $DB_NAME if it doesn't exist..."
$mysql_cmd -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"

# التحقق من وجود الجداول (عبر جدول setting)
if $mysql_cmd -e "USE $DB_NAME; SHOW TABLES LIKE 'setting';" | grep -q setting; then
    echo "✅ Database already initialized. Skipping import."
else
    echo "📥 Importing data..."
    $mysql_cmd "$DB_NAME" < "$SQL_FILE"
    echo "✅ Import completed."
fi

# بدء Apache
apache2-foreground
