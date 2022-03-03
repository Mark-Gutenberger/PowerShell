<#
SPDX-License-Identifier: MIT
Author: Mark Gutenberger <mark-gutenberger@outlook.com>
Main.ps1 (c) 2022
Desc: identifies the platform
Created:  2022-02-27T19:13:11.201Z
Modified: 2022-02-27T19:28:26.584Z
#>

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
