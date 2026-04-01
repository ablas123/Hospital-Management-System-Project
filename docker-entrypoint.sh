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

# Create a working copy
cp "$SQL_FILE" "$TEMP_SQL"

echo "🔧 Fixing SQL file for MySQL 8.0 compatibility..."

# 1. Fix TIME columns: replace DEFAULT current_timestamp() with DEFAULT "00:00:00"
sed -i -E 's/(`[a-z_]+_time` time NOT NULL DEFAULT) current_timestamp\(\)/\1 "00:00:00"/g' "$TEMP_SQL"

# 2. Fix DATE columns: replace DEFAULT current_timestamp() with DEFAULT (CURRENT_DATE)
sed -i -E 's/(`[a-z_]+_date` date NOT NULL DEFAULT) current_timestamp\(\)/\1 (CURRENT_DATE)/g' "$TEMP_SQL"

# 3. Also catch any other DATE columns that might have been missed
sed -i -E 's/(`[a-z_]+_date` date[^,]*, DEFAULT) current_timestamp\(\)/\1 (CURRENT_DATE)/g' "$TEMP_SQL"

mysql_cmd="mysql --host=$DB_HOST --port=$DB_PORT --user=$DB_USER --password=$DB_PASS --ssl-ca=$SSL_CA"

# Check if tables already exist
if $mysql_cmd -e "USE $DB_NAME; SHOW TABLES LIKE 'setting';" 2>/dev/null | grep -q setting; then
    echo "✅ Database already initialized. Skipping import."
else
    echo "📥 Initializing database (fresh install)..."
    $mysql_cmd -e "DROP DATABASE IF EXISTS $DB_NAME; CREATE DATABASE $DB_NAME;"
    # Import with verbose output to see which statements execute
    $mysql_cmd $DB_NAME < "$TEMP_SQL"
    echo "✅ Database initialization completed."
fi

# Start Apache
apache2-foreground
