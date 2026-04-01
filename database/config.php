<?php
$host = getenv('DB_HOST') ?: 'gateway01.eu-central-1.prod.aws.tidbcloud.com';
$port = getenv('DB_PORT') ?: 4000;
$user = getenv('DB_USER') ?: '4Q3JgFwtV72XTzm.root';
$pass = getenv('DB_PASS') ?: 'hCCzJBE3Ko33HuTW';
$dbname = getenv('DB_NAME') ?: 'hospital_db';

$ssl_ca = __DIR__ . '/ca.pem';

$conn = mysqli_init();
mysqli_ssl_set($conn, NULL, NULL, $ssl_ca, NULL, NULL);
if (!mysqli_real_connect($conn, $host, $user, $pass, $dbname, $port, NULL, MYSQLI_CLIENT_SSL)) {
    die("Connection failed: " . mysqli_connect_error());
}
?>
