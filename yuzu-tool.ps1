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
   ./yuzu-tool.ps1 -install_yuzu -install_keys -install_sa
.EXAMPLE
   ./yuzu-tool.ps1 -update
#>

param
(
	[Switch]$help,
	[Switch]$update,
	
	[Switch]$default_install,
	[Switch]$install_yuzu,
	[Switch]$install_keys,
	[Switch]$install_sa,

	[Switch]$credits
)

$update_needed = $false

$ProgressPreference = 'silentlyContinue'

function cancel()
{
	if($credits)
	{
		"Thanks to /u/yuzu_pirate, /u/Azurime, and /u/bbb651 for their contributions to /r/YuzuP I R A C Y."
		"This program made by /u/Hipeopeo."
		"Thanks to the yuzu devs for making Yuzu!"
	}
	exit
}

try
{
	$reply = Invoke-WebRequest "https://raw.githubusercontent.com/zeewanderer/s/master/version"
	if($reply.StatusDescription -eq "OK")
	{
		$upstream_version = $reply.Content
		$current_version = Get-Content -Path "$PSScriptRoot/version"
		if($upstream_version -ne $current_version)
		{
			$update_needed = $true
			if(!$update)
			{
				Write-Host "!W New tools version available" -ForegroundColor Yellow
			}
		}
		
	}
	else
	{
		throw $reply
	}
}
catch
{
	Write-Host "!E Error checking for new version" -ForegroundColor Red
}


if($help)
{
	Get-Help "$PSScriptRoot\$($MyInvocation.MyCommand.Name)"
	exit
}

if($update)
{
	try
	{
		if ($update_needed)
		{
			Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/zeewanderer/s/master/yuzu-tool.ps1' -OutFile "$PSScriptRoot\yuzu-tool.ps1"
			Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/zeewanderer/s/master/version' -OutFile "$PSScriptRoot\version"
		}
		else
		{
			Write-Host "!W Update requested but new version not available" -ForegroundColor Yellow
		}
	}
	catch
	{
		Write-Host "!F Error while updating" -ForegroundColor Magenta
		exit
	}
}

if($default_install)
{
	$install_yuzu = $true
	$install_keys = $true
	$install_sa = $true
}

if($install_yuzu) 
{
	"Installing yuzu"
	if(Test-Path "yuzu_install.exe")
	{
		" --Removing old version"
		Remove-Item "yuzu_install.exe"
	}
	try
	{
		" --Looking for latest version..."
		$reply = Invoke-WebRequest "https://api.github.com/repos/yuzu-emu/liftinstall/releases/latest"

		if($reply.StatusDescription -eq "OK")
		{
			$url = (ConvertFrom-Json $reply).assets.browser_download_url
			" --Downloading yuzu_install.exe..."
			Invoke-WebRequest -ContentType "application/octet-stream" -Uri $url -OutFile 'yuzu_install.exe'
			" --Launching yuzu_install.exe..."
			Start-Process "yuzu_install.exe" -Wait
			" --yuzu_install.exe exited"
		}
		else
		{
			throw $reply
		}
	}
	catch
	{
		Write-Host "!E Error encountered while installing yuzu" -ForegroundColor Red
		" --Cleaning up"
	}
	Remove-Item "yuzu_install.exe" | out-null
	Remove-Item "yuzu_installer.log" | out-null
}

if($install_keys)
{
	"Installing keys"
	$location = "$env:appdata\yuzu\keys"
	try
	{
		if(Test-Path "$location")
		{
			" --Deleting old keys"
			Remove-Item "$location" -Recurse -Force
		}
		(New-Item -Path "$location" -ItemType directory) | out-null
		" --Writing new keys to $location"
	
		Invoke-WebRequest -ContentType "application/octet-stream" -Uri 'https://raw.githubusercontent.com/zeewanderer/s/master/prod.keys' -OutFile "$location\prod.keys"
		Invoke-WebRequest -ContentType "application/octet-stream" -Uri 'https://raw.githubusercontent.com/zeewanderer/s/master/title.keys' -OutFile "$location\title.keys"
	}
	catch
	{
		Write-Host "!E Error while installing keys" -ForegroundColor Red
	}
}

if($install_sa)
{
	"Installing System Archives"
	$location = "$env:appdata\yuzu\nand\system"
	try
	{
		" --Downloading System Archives..."
		Invoke-WebRequest -ContentType "application/octet-stream" -Uri 'https://www.dropbox.com/s/0gwmpgus9t4q1dm/System_Archives.zip?dl=1' -OutFile "$location\System_Archives.zip"
		" --Downloading unzip.exe..."
		Invoke-WebRequest -ContentType "application/octet-stream" -Uri 'https://www.dropbox.com/s/wcdhkat6oz0i3tm/unzip.exe?dl=1' -OutFile "$location\unzip.exe"
		" --Unzipping System Archives to $location"
		& "$location\unzip.exe" -oq "$location\System_Archives.zip" -d "$location"
	}
	catch
	{
		Write-Host "!E Error while installing System Archives" -ForegroundColor Red
	}
	" --Cleaning up..."
	Remove-Item "$location\System_Archives.zip" | out-null
	Remove-Item "$location\unzip.exe" | out-null
}

cancel
