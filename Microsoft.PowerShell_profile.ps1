<#
SPDX-License-Identifier: MIT
Author: Mark Gutenberger <mark-gutenberger@outlook.com>
Microsoft.Powershell_profile.ps1 (c) 2022
Desc: description
Created:  2022-02-12T00:34:39.695Z
Modified: 2022-03-03T14:19:01.449Z
#>

# Clear this if you want, I just prefer to see that Powershell didn't shit its pants right away.
Write-Host "pwsh " -NoNewline
Get-Location | Write-Host

# I hate that this is here, but for complete coverage, we need to unsure 1000% that is is ran

function isOnWindows {
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

function isOnLinux {
	if (Test-Path -Path 'variable:global:IsLinux') {
		return Get-Content -Path 'variable:global:IsLinux'
	}

	return $false
}

function isOnMac {
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

function Is-OnPlatform {
	if (isOnWindows) {
		$env:IsOnPlatform = 'Windows'
		$env:IsOnPlatform0 = '0'
		return 'Windows'
	}
	if (isOnLinux) {
		$env:IsOnPlatform = 'Linux'
		$env:IsOnPlatform0 = '1'
		return 'Linux'
	}
	if (isOnMac) {
		$env:IsOnPlatform = 'Mac'
		$env:IsOnPlatform0 = '2'
		return 'Mac'
	}
	$env:IsOnPlatform = 'You have fucked up! 👏'
	$env:IsOnPlatform0 = '3'
	return 'You have fucked up! 👏'
}

Write-Host "Platform: " -NoNewline
Is-OnPlatform

if ($env:IsOnPlatform -eq 'Windows') {
	# Windows version of this shit :D
	# Go here
	Set-Location -Path $env:userprofile\Documents\PowerShell\
	# Dot in external modules
	. .\Is-OnPlatform\Main.ps1
	. .\ls\Main.ps1

}
elseif ($env:IsOnPlatform -eq 'Linux') {
	# Linux version of this shit :D
	# Go here
	Set-Location ~/.config/powershell/
	# Dot in external modules
	. ~/.config/powershell/Is-OnPlatform/Main.ps1
	. ~/.config/powershell/ls/Main.ps1

}
elseif ($env:IsOnPlatform -eq 'Mac') {
	# Mac version of this shit :D
	# Go here
	Set-Location ~/.config/powershell/
	# Dot in external modules
	. ~/.config/powershell/Is-OnPlatform/Main.ps1
	. ~/.config/powershell/ls/Main.ps1
}
else {
	Write-Host "You have fucked up! 👏"
	return $false
	exit 0;
}

# again, just check to see if PS is shitting bricks
Write-Host "Found profile: " -NoNewline
Get-Location | Write-Host

function Custom-wsl {
	if ($args.Count -lt 1) {
		C:\\Windows\\System32\\wsl.exe bash
	}
	elseif ($args.Contains('ubuntu')) {
		C:\\Windows\\System32\\wsl.exe $args bash
	}
	elseif ($args.Contains('debian')) {
		C:\\Windows\\System32\\wsl.exe $args
	}
	else {
		C:\\Windows\\System32\\wsl.exe $args
	}
};

Set-Alias wsl Custom-wsl;
Set-Alias bash wsl;
Set-Alias rn React-Native;
Set-Alias ls Custom-ls;
Set-Alias list Custom-ls;

# custom prompt:
# function Prompt() {
# "PS $($executionContext.SessionState.Path.CurrentLocation)$( '>' * ($nestedPromptLevel + 1)) ";
# };
function prompt () {
	Write-Host ($(Get-Date -Format "HH:mm:ss")) -NoNewline -ForegroundColor white
	Write-Host (" " + "pwsh" + " ") -NoNewline -ForegroundColor 2 # green
	Write-Host ($(Get-Location)) -NoNewline -ForegroundColor 1 # blue
	Write-Host (" > ") -NoNewline -ForegroundColor white
	return " "
};

# At the very end make sure to cd back to home. (no args needed as home is teh defualt param)

Set-Location
