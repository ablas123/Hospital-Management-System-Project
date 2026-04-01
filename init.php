<?php
$host = getenv('DB_HOST') ?: 'gateway01.eu-central-1.prod.aws.tidbcloud.com';
$port = getenv('DB_PORT') ?: 4000;
$user = getenv('DB_USER') ?: '4Q3JgFwtV72XTzm.root';
$pass = getenv('DB_PASS') ?: 'hCCzJBE3Ko33HuTW';
$dbname = getenv('DB_NAME') ?: 'hospital_db';

$ssl_ca = __DIR__ . '/database/ca.pem';

$conn = mysqli_init();
mysqli_ssl_set($conn, NULL, NULL, $ssl_ca, NULL, NULL);
if (!mysqli_real_connect($conn, $host, $user, $pass, '', $port, NULL, MYSQLI_CLIENT_SSL)) {
    die("Connection failed: " . mysqli_connect_error());
}

// التحقق من وجود جدول setting (علامة على اكتمال الاستيراد)
$conn->select_db($dbname);
$check = $conn->query("SHOW TABLES LIKE 'setting'");
if ($check && $check->num_rows > 0) {
    echo "Database already initialized. Skipping.\n";
    $conn->close();
    return;
}

// إذا وصلنا إلى هنا، ننظف قاعدة البيانات ونعيد استيرادها
$conn->query("DROP DATABASE IF EXISTS `$dbname`");
$conn->query("CREATE DATABASE `$dbname`");
$conn->select_db($dbname);

$sqlFile = __DIR__ . '/admin/System_backup_file/backup_system1740888810-c25239e543c4328636c1d292120d664e.sql';
if (!file_exists($sqlFile)) {
    die("SQL file not found at: $sqlFile");
}

$sql = file_get_contents($sqlFile);
if ($sql === false) {
    die("Could not read SQL file.");
}

// تنفيذ الاستعلامات (تجاهل التعليقات)
$queries = array_filter(array_map('trim', explode(';', $sql)));
foreach ($queries as $query) {
    if (!empty($query) && !preg_match('/^--/', $query)) {
        if (!$conn->query($query)) {
            echo "Error executing query: " . $conn->error . "<br>\n";
        }
    }
}
echo "Database initialization completed.\n";
$conn->close();
?>
