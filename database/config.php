<?php
// إعدادات الاتصال بقاعدة البيانات (تقرأ من متغيرات البيئة إن وُجدت)
$host = getenv('DB_HOST') ?: 'gateway01.eu-central-1.prod.aws.tidbcloud.com';
$port = getenv('DB_PORT') ?: 4000;
$user = getenv('DB_USER') ?: '4Q3JgFwtV72XTzm.root';
$pass = getenv('DB_PASS') ?: 'hCCzJBE3Ko33HuTW';
$dbname = getenv('DB_NAME') ?: 'hospital_db';

$conn = mysqli_connect($host, $user, $pass, $dbname, $port);
if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}
?>
