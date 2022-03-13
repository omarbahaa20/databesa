<?php
error_reporting(1);
echo "Welcome to AppServ MySQL Root Password Reset Program\n\n";
AppServCMD();
function AppServCMD() {
	define('STDIN',fopen("php://stdin","r"));
	echo " Enter New MySQL root Password : ";
	$input = trim(fgets(STDIN,256));
	$input = str_replace("'", "\'", $input);
	$input = str_replace('"',"\"", $input); 
	$len = strlen($input);
	if ($len < 8) {
		echo "\n   MySQL Password must be at least 8 characters!\n\n";
		sleep(5);
		exit;
	}
	echo "\n   Your Username : root";
	echo "\n   Your Password : $input";
	echo "\n\n   Please wait ...................................\n\n";
	$file="C:\AppServ\MySQL/bin/cmd.txt";
	$handle = fopen("$file", 'w+');
	fwrite($handle, "alter user root@localhost identified with mysql_native_password BY '$input';");
	exec ("net stop mysql8");
	$cmd="C:\AppServ\MySQL\bin\mysqld.exe --init-file=C:\AppServ\MySQL/bin/cmd.txt";
	pclose(popen("start /B ". $cmd, "r")); 
	sleep(2);
	exec ("C:\AppServ\MySQL\bin\mysqladmin -u root -p$input shutdown");
	sleep(4);
	exec ("net start mysql8");
	unlink($file);
} // end function
?>