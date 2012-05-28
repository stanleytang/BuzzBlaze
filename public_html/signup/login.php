<html>
<body>
<?php
//print_r($_POST);

?>
<form method="POST" action="sign_complete.php"><table><tr valign="top"><td><img src="securimage/securimage_show.php?sid=<?php echo md5(uniqid(time())); ?>" id="image" align="absmiddle" /></td><td>
<a href="securimage/securimage_play.php" style="font-size: 13px">(Audio)</a><br /><a href="#" onclick="document.getElementById('image').src = 'securimage/securimage_show.php?sid=' + Math.random(); return false">Reload Image</a>
</td></tr><tr><td><input type="text" name="code" /><input type="hidden" name="fname" value="<?php echo $_POST['fname']; ?>" /><input type="hidden" name="uname" value="<?php echo $_POST['uname']; ?>" /><input type="hidden" name="email" value="<?php echo $_POST['email']; ?>" /><input type="hidden" name="pass" value="<?php echo $_POST['pass']; ?>" /><input type="hidden" name="cpass" value="<?php echo $_POST['cpass']; ?>" />

</td><td><input type="submit" value="Submit" /></td></tr></table></form></body>
</html>