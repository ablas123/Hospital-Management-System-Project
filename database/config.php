<?php 
 // بيانات الاتصال بقاعدة البيانات على InfinityFree (صالحة للاستخدام من Render)
 $hostname = "sql200.infinityfree.com";   // مضيف قاعدة البيانات (ثابت)
 $user = "if0_41411754";                  // اسم مستخدم قاعدة البيانات
 $password = "ablasmoh";                   // كلمة المرور
 $dbname = "if0_41411754_ablas";           // اسم قاعدة البيانات

 // إنشاء الاتصال
 $conn = mysqli_connect($hostname, $user, $password, $dbname);

 // التحقق من الاتصال
 if(!$conn){
     die("فشل الاتصال بقاعدة البيانات: " . mysqli_connect_error());
 }
 
 // لتحديد ترميز الاتصال (اختياري ولكنه مفيد)
 mysqli_set_charset($conn, "utf8");
?>
