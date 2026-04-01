#!/bin/bash
set -e

DB_HOST="gateway01.eu-central-1.prod.aws.tidbcloud.com"
DB_PORT="4000"
DB_USER="4Q3JgFwtV72XTzm.root"
DB_PASS="hCCzJBE3Ko33HuTW"
DB_NAME="hospital_db"
SSL_CA="/var/www/html/database/ca.pem"

# Build mysql command without ssl-mode
mysql_cmd="mysql --host=$DB_HOST --port=$DB_PORT --user=$DB_USER --password=$DB_PASS --ssl-ca=$SSL_CA"

# Check if tables already exist
if $mysql_cmd -e "USE $DB_NAME; SHOW TABLES LIKE 'setting';" 2>/dev/null | grep -q setting; then
    echo "Database already initialized. Skipping import."
else
    echo "Initializing database..."
    $mysql_cmd -e "DROP DATABASE IF EXISTS $DB_NAME; CREATE DATABASE $DB_NAME;"
    $mysql_cmd $DB_NAME < /var/www/html/admin/System_backup_file/backup_system1740888810-c25239e543c4328636c1d292120d664e.sql
    echo "Database initialization completed."
fi

# Start Apache
apache2-foreground
