::@ECHO OFF

::
:: Description: build_backup script for Apple MacOS.
:: Build and prepare the core database folder based
:: on the given settings in my.ini and install and 
:: pre-configure phpMyAdmin.
:: 
:: Author: Stephen J. Carnam

:choice
set /P c=WARNING!!! This will destroy the data folder; continue (y/n)?
if /I "%c%" EQU "Y" goto :buildnow
if /I "%c%" EQU "N" goto :exitnow
goto :choice

:buildnow
call c:\xampplite\ds-plugins\ds-cli\platform\win32\boot.bat
mysqladmin --user=root --password= shutdown >nul 2>&1
rm -rf ./data
rm -rf ./backup.zip
mkdir .\data
mysql_install_db --datadir=c:\xampplite\mysql\data
cmd /c START mysqld --defaults-file=c:\xampplite\mysql\bin\my.ini --console
mysql --user=root --password= -e "CREATE USER 'pma'@'localhost' IDENTIFIED BY '';"
mysql --user=root --password= < c:\xampplite\phpmyadmin\sql\create_tables.sql
mysql --user=root --password= < c:\xampplite\mysql\pma_privileges.sql
mysqladmin --user=root --password= shutdown >nul 2>&1
sleep 5
del .\data\*.ini
del .\data\*.err
del .\data\*.log
bash -c "zip -r -y -9 backup.zip ./data"
exit /b

:exitnow
exit /b
