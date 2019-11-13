<#
.Synopsis
   A tool for installing yuzu, product keys and system archives.
.DESCRIPTION
    Options:
    -help Display this message and exit.

	-update Update script file and exit.
	
	-default_install Install Yuzu, keys and system archives.

    -install_yuzu Download and launch latest yuzu installer.
        
	-install_keys Istall switch products key files.

    -install_sa Istall switch system archives.

    -credits Display credits when done.
.EXAMPLE
   ./yuzu-keys-installer.ps1 -install_yuzu -install_keys -install_sa
.EXAMPLE
   ./yuzu-keys-installer.ps1 -update
#>

param
(
	[Switch]$help,
	[Switch]$update,
	
	[Switch]$install_yuzu,
	[Switch]$install_keys,
	[Switch]$install_sa,

	[Switch]$credits
)

$location = Get-Location

$ProgressPreference = 'silentlyContinue'

function cancel()
{
	if($credits)
	{
		"Thanks to /u/yuzu_pirate, /u/Azurime, and /u/bbb651 for their contributions to /r/YuzuP I R A C Y."
		"This program made by /u/Hipeopeo."
		"Thanks to the yuzu devs for making Yuzu!"
	}
	Set-Location $location
	exit
}

if($help)
{
	Get-Help "$PSScriptRoot/$($MyInvocation.MyCommand.Name)"
	exit
}

if($update)
{
	try
	{
		Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/zeewanderer/s/master/yuzu-tool.ps1' -OutFile 'yuzu-tool.ps1'
	}
	catch
	{
		"Exiting due to error in :UY"
		exit
	}
}


if($install_yuzu) 
{

	if(Test-Path "yuzu_install.exe")
	{
		"Removing old version..."
		Remove-Item "yuzu_install.exe"
	}
	try
	{
		$reply = Invoke-WebRequest "https://api.github.com/repos/yuzu-emu/liftinstall/releases/latest"

		if($reply.StatusDescription -eq "OK")
		{
			$url = (ConvertFrom-Json $reply).assets.browser_download_url
			Invoke-WebRequest -ContentType "application/octet-stream" -Uri $url -OutFile 'yuzu_install.exe'
			Start-Process "yuzu_install.exe" -Wait
		}
		else
		{
			throw $reply
		}
	}
	catch
	{
		"Error encountered in :Yes"
		"Cleaning up..."
	}
	Remove-Item "yuzu_install.exe" | out-null
	Remove-Item "yuzu_installer.log" | out-null
}

if($install_keys)
{
	Set-Location "$env:appdata\yuzu"
	if((Test-Path "keys\prod.keys") -or (Test-Path "keys\title.keys"))
	{
		"Deleting old keys..."
		Remove-Item "keys" -Recurse -Force
	}
	(New-Item -Name "keys" -ItemType directory) | out-null
	Set-Location "keys"
	"Writing new keys to $env:appdata\yuzu\keys"
	try
	{
		Invoke-WebRequest -ContentType "application/octet-stream" -Uri 'https://raw.githubusercontent.com/zeewanderer/s/master/prod.keys' -OutFile 'prod.keys'
		Invoke-WebRequest -ContentType "application/octet-stream" -Uri 'https://raw.githubusercontent.com/zeewanderer/s/master/title.keys' -OutFile 'title.keys'
	}
	catch
	{
		"Error in :No"
	}
	"Successfully downloaded title.keys, prod.keys"
}

if($install_sa)
{
	Set-Location "$env:appdata\yuzu\nand\system"
	try
	{
		Invoke-WebRequest -ContentType "application/octet-stream" -Uri 'https://www.dropbox.com/s/0gwmpgus9t4q1dm/System_Archives.zip?dl=1' -OutFile 'System_Archives.zip'
		"unzipping System Archives."
		Invoke-WebRequest -ContentType "application/octet-stream" -Uri 'https://www.dropbox.com/s/wcdhkat6oz0i3tm/unzip.exe?dl=1' -OutFile 'unzip.exe'
		"Writing System Archives to $env:appdata\yuzu\keys\nand\system"
		.\unzip.exe -o "System_Archives.zip"
	}
	catch
	{
		"Fatal error in :SA, cleaning up and exiting"
	}
	"Cleaning up..."
	Remove-Item "System_Archives.zip" | out-null
	Remove-Item "unzip.exe" | out-null
}

cancel
