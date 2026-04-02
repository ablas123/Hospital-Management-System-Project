<?php
$password = 'admin123';
$hash = password_hash($password, PASSWORD_DEFAULT);
echo "Password: $password<br>Hash: $hash<br>";
echo "UPDATE user_tbl SET password = '$hash' WHERE user_email = 'newadmin@hospital.com';";
?>
