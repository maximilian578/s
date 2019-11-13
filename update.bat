@echo off
cls
del yuzu-keys-installer.bat
powershell.exe (new-object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/zeewanderer/s/master/yuzu-tool.bat', 'yuzu-tool.bat')
yuzu-keys-installer.bat
exit
