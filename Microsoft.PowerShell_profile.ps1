<#
SPDX-License-Identifier: MIT
Author: Mark Gutenberger <mark-gutenberger@outlook.com>
Microsoft.Powershell_profile.ps1 (c) 2022
Desc: description
Created:  2022-02-12T00:34:39.695Z
Modified: 03/12/2022 23:14:01
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
		};
	};

	function Test-Platform-Linux {
		if (Test-Path -Path 'variable:global:IsLinux') {
			return Get-Content -Path 'variable:global:IsLinux'
		}
		else {
			return $false
		};
	};

	function Test-Platform-Darwin {
		if (Test-Path -Path 'variable:global:IsMacOS') {
			return Get-Content -Path 'variable:global:IsMacOS'
		}
		elseif (Test-Path -Path 'variable:global:IsOSX') {
			return Get-Content -Path 'variable:global:IsOSX'
		}
		else {
			return $false
		};
	};

	if (Test-Platform-Windows) {
		$env:IsOnPlatform = 'Windows'
		$env:IsOnPlatform0 = '0'
		return 'Windows'
	}
	elseif (Test-Platform-Linux) {
		$env:IsOnPlatform = 'Linux'
		$env:IsOnPlatform0 = '1'
		return 'Linux'
	}
	elseif (Test-Platform-Darwin) {
		$env:IsOnPlatform = 'Mac'
		$env:IsOnPlatform0 = '2'
		return 'Mac'
	}
	else {
		$env:IsOnPlatform = 'You have fucked up! 👏'
		$env:IsOnPlatform0 = '3'
		return 'You have fucked up! 👏'
	};
};

function Import-External-Scripts () {
	if ($env:IsOnPlatform -eq 'Windows') {
		Set-Location -Path $env:userprofile\Documents\PowerShell\
	}
	elseif ($env:IsOnPlatform -eq 'Linux||Mac') {
		Set-Location ~/.config/powershell/
	}
	else {
		return $false
		exit 0;
	};
};

<# *
   * Alias declarations:
   * #>
function Format-PSFormat () {
	Get-ChildItem -Path .\ -Include *.ps1, *.psm1 -Recurse | Edit-DTWBeautifyScript -IndentType Tabs
};
Set-Alias PSFormat Format-PSFormat;
Set-Alias PS-Format Format-PSFormat;
Set-Alias MSEdge MicrosoftEdge.exe;
Function Invoke-Color-Ls () {
	colorls -a --sd $Args
};
Set-Alias ls Invoke-Color-Ls
Set-Alias list Invoke-Color-Ls

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
	Get-Date -Format MM/dd/yyyy` -` HH:mm:ss
	# Write-Host $(pwsh --version) # pwsh does this by default
	Write-Host "Platform: " -NoNewline
	Get-Platform
	Import-External-Scripts
	Set-Location
};
Main
