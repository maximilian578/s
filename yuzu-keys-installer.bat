@echo off
title Yuzu Keys Installer
cls


:update
set /p menu="Do you want to update script? (Y/N): "
if %menu%==Y goto UY
if %menu%==y goto UY
if %menu%==N goto A
if %menu%==n goto A
else (
    echo Invalid input. Please try again.
	goto :update
)

:UY
cls
echo Updating
echo.
IF EXIST update.bat (
	del update.bat
	echo Removing old script...
)
echo Downloading new version...
powershell.exe (new-object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/hipeopeo/s/master/update.bat', 'update.bat')
if %errorlevel% == 0 (
	update.bat
) else (
	Exiting due to error in :UY, %errorlevel%
)
exit

:A
set /p menu="Do you want to install Yuzu? (Y/N/System Archives/Cancel): "
if %menu%==Y goto Yes
if %menu%==y goto Yes
if %menu%==N goto No
if %menu%==n goto No
if %menu%==C goto C
if %menu%==c goto C
if %menu%==System Archives goto SA
if %menu%==SA goto SA
if %menu%==system archives goto SA
if %menu%==sa goto SA
else (
	cls
	echo Invalid input. Please try again...
	goto :A
)
cls
set /p pause="Press any key to continue!... "

:Yes
cls
echo.
echo This will download the Yuzu installer, and run it. Allow it to install.
echo.
IF EXIST yuzu_installer.exe (
	echo Removing old version...
	del yuzu_installer.exe
)
powershell.exe (new-object System.Net.WebClient).DownloadFile('https://www.dropbox.com/s/4vdziiwebovju8x/yuzu_install.exe?dl=1', 'yuzu_install.exe')
if %errorlevel% == 0 (
	echo We will now install yuzu, then delete the installer.
	yuzu_install.exe
) else (
	echo Error encountered in :Yes, %errorlevel%
	echo Cleaning up...
)
del yuzu_install.exe
del yuzu_install.log
echo Done.
pause

:No
cls
echo Okay, that means it's time to download the keys.
echo.
echo We will now download the keys.
cd %appdata%\yuzu
IF EXIST keys\prod.keys (
	echo Deleting old keys...
	rmdir /Q /S keys
)
IF EXIST keys\title.keys (
	echo Deleting old keys...
	rmdir /Q /S keys
)
mkdir keys
cd keys
echo Writing new keys to %appdata%\yuzu\keys
powershell.exe (new-object System.Net.WebClient).DownloadFile('https://s.hipeopeodev.us/prod.keys', 'prod.keys')
powershell.exe (new-object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/hipeopeo/s/master/title.keys', 'title.keys')
if %errorlevel% == 0 (
	echo Successfully downloaded title.keys, prod.keys
) else (
	echo Error in :No, %errorlevel%
)
pause

:SA
echo.
echo We will now download the System Archives. This may take a while, it will be blank, but let it run.
cd %appdata%\yuzu\nand\system
powershell.exe (new-object System.Net.WebClient).DownloadFile('https://www.dropbox.com/s/0gwmpgus9t4q1dm/System_Archives.zip?dl=1', 'System_Archives.zip')
if %errorlevel% == 0(
	echo unzipping System Archives.
	powershell.exe (new-object System.Net.WebClient).DownloadFile('https://www.dropbox.com/s/wcdhkat6oz0i3tm/unzip.exe?dl=1', 'unzip.exe')
	echo Writing System Archives to %appdata%\yuzu\keys\nand\system
	unzip.exe System_Archives.zip
) else(
	echo Fatal error in :SA, cleaning up and exiting.
	del System_Archives.zip
	del unzip.exe
	exit
)
echo Cleaning up...
del System_Archives.zip
del unzip.exe
pause

:C
cls
echo Thanks to /u/yuzu_pirate, /u/Azurime, and /u/bbb651 for their contributions to /r/YuzuP I R A C Y.
echo.
echo This program made by /u/Hipeopeo.
echo.
echo Thanks to the yuzu devs for making Yuzu!
pause
