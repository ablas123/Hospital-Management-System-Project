<?php
// هذا الملف سينشئ تجزئة لكلمة مرور جديدة باستخدام بيئة Render الحالية
$password = 'admin123'; // غيّر إلى كلمة المرور التي تريدها
$hash = password_hash($password, PASSWORD_DEFAULT);
echo "Password: " . $password . "<br>";
echo "Hash: " . $hash . "<br>";
echo "SQL: UPDATE user_tbl SET password = '" . $hash . "' WHERE user_email = 'unique@gmail.com';";
?>
