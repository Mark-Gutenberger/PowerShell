<#
SPDX-License-Identifier: MIT
Author: Mark Gutenberger <mark-gutenberger@outlook.com>
Microsoft.Powershell_profile.ps1 (c) 2022
Desc: description
Created:  2022-02-12T00:34:39.695Z
Modified: 2022-03-10T03:24:21.506Z
#>
<# *
   * Self explanatory...
   * #>
function Get-Platform {
	function Test-Platform-Windows {
		# This will work on 6.0 and later but is missing on
		# older versions
		if (Test-Path -Path 'variable:global:IsWindows') {
			return Get-Content -Path 'variable:global:IsWindows'
		}
		# This should catch older versions
		elseif (Test-Path -Path 'env:os') {
			return (Get-Content -Path 'env:os').StartsWith("Windows")
		}
		# If all else fails
		else {
			return $false
		}
	}

	function Test-Platform-Linux {
		if (Test-Path -Path 'variable:global:IsLinux') {
			return Get-Content -Path 'variable:global:IsLinux'
		}

		return $false
	}

	function Test-Platform-Darwin {
		# The variable to test if you are on Mac OS changed from
		# IsOSX to IsMacOS. Because I have Set-StrictMode -Version Latest
		# trying to access a variable that is not set will crash.
		# So I use Test-Path to determine which exist and which to use.
		if (Test-Path -Path 'variable:global:IsMacOS') {
			return Get-Content -Path 'variable:global:IsMacOS'
		}
		elseif (Test-Path -Path 'variable:global:IsOSX') {
			return Get-Content -Path 'variable:global:IsOSX'
		}
		else {
			return $false
		}
	}
	if (Test-Platform-Windows) {
		$env:IsOnPlatform = 'Windows'
		$env:IsOnPlatform0 = '0'
		return 'Windows'
	}
	if (Test-Platform-Linux) {
		$env:IsOnPlatform = 'Linux'
		$env:IsOnPlatform0 = '1'
		return 'Linux'
	}
	if (Test-Platform-Darwin) {
		$env:IsOnPlatform = 'Mac'
		$env:IsOnPlatform0 = '2'
		return 'Mac'
	}
	$env:IsOnPlatform = 'You have fucked up! 👏'
	$env:IsOnPlatform0 = '3'
	return 'You have fucked up! 👏'
}
function Import-External-Scripts () {

	if ($env:IsOnPlatform -eq 'Windows') {
		# Windows version of this shit :D
		# Go here
		Set-Location -Path $env:userprofile\Documents\PowerShell\
		# Dot in external modules
		. .\PSFormat\Main.ps1

	}
	elseif ($env:IsOnPlatform -eq 'Linux') {
		# Linux version of this shit :D
		# Go here
		Set-Location ~/.config/powershell/
		# Dot in external modules
		. ./PSFormat/Main.ps1

	}
	elseif ($env:IsOnPlatform -eq 'Mac') {
		# Mac version of this shit :D
		# Go here
		Set-Location ~/.config/powershell/
		# Dot in external modules
		. ./PSFormat/Main.ps1
	}
	else {
		Write-Host "You have fucked up! 👏"
		return $false
		exit 0;
	}
};
<# *
   * Alias declarations:
   * #>
Set-Alias rn React-Native;
Set-Alias PSFormat PS-Format;

<# *
   * Starship stuff
   * #>
function Invoke-Starship-PreCommand {
	$host.UI.Write("`e]0;$pwd`a")
};
Invoke-Starship-PreCommand
Invoke-Expression (& starship init powershell)

<# *
   * Main
   * #>
function Main () {
	Import-External-Scripts
	Write-Host "pwsh " -NoNewline
	Get-Location | Write-Host
	Write-Host "Platform: " -NoNewline
	Get-Platform
	Write-Host "Found profile: " -NoNewline
	Get-Location | Write-Host
	Set-Location
};
Main
