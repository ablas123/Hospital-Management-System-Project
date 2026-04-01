<?php
// هذا الملف يُنشئ الجداول ويستورد البيانات إذا لم تكن موجودة
$host = getenv('DB_HOST') ?: 'gateway01.eu-central-1.prod.aws.tidbcloud.com';
$port = getenv('DB_PORT') ?: 4000;
$user = getenv('DB_USER') ?: '4Q3JgFwtV72XTzm.root';
$pass = getenv('DB_PASS') ?: 'hCCzJBE3Ko33HuTW';
$dbname = getenv('DB_NAME') ?: 'hospital_db';

$conn = new mysqli($host, $user, $pass, $dbname, $port);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// مسار ملف SQL (النسخة الاحتياطية المعدلة)
$sqlFile = __DIR__ . '/admin/System_backup_file/backup_system1740888810-c25239e543c4328636c1d292120d664e.sql';

if (!file_exists($sqlFile)) {
    die("SQL file not found at: $sqlFile");
}

// قراءة الملف وتنفيذ الاستعلامات
$sql = file_get_contents($sqlFile);
// إزالة التعليقات -- (قد لا تحتاجها)
$sql = preg_replace('/--.*$/m', '', $sql);
$queries = array_filter(array_map('trim', explode(';', $sql)));

foreach ($queries as $query) {
    if (!empty($query)) {
        if (!$conn->query($query)) {
            echo "Error executing query: " . $conn->error . "<br>";
        }
    }
}

echo "Database initialization completed.";
$conn->close();
?>
