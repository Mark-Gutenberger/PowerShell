<#
SPDX-License-Identifier: MIT
Author: Mark Gutenberger <mark-gutenberger@outlook.com>
Microsoft.Powershell_profile.ps1 (c) 2022
Desc: description
Created:  2022-02-12T00:34:39.695Z
Modified: 2022-03-22T14:36:58.490Z
#>

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
	# read the values we just assigned and return them as meaningful values.
	# TODO: combine this with the scripting above.
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

# function Import-Scripts () {
# 	if ($env:IsOnPlatform -eq 'Windows') {
# 		Set-Location -Path $env:userprofile\Documents\PowerShell\
# 	}
# 	elseif ($env:IsOnPlatform -eq 'Linux') {
# 		Set-Location -Path ~/.config/powershell/
# 	}
# 	elseif ($env:IsOnPlatform -eq 'Mac') {
# 		Set-Location -Path ~/.config/powershell/
# 	}
# 	else {
# 		return $false
# 		return "Error"
# 		exit 0;
# 	};
# };

<# *
   * Alias declarations:
   * #>
function Format-PSFormat () {
	Get-ChildItem -Path .\ -Include *.ps1, *.psm1 -Recurse | Edit-DTWBeautifyScript -IndentType Tabs
};
Set-Alias PSFormat Format-PSFormat;
Set-Alias PS-Format Format-PSFormat;
Set-Alias MSEdge MicrosoftEdge.exe;
Function Invoke-ColorLs () {
	colorls -a --sd $Args
};
Set-Alias ls Invoke-ColorLs
Set-Alias list Invoke-ColorLs

<# *
   * Starship stuff
   * #>
function Invoke-Starship-PreCommand {
	$host.UI.Write("`e]0;$pwd`a")
};

Invoke-Starship-PreCommand
Invoke-Expression (& starship init powershell)

<# *
   * Config
   * #>

function Config () {
	# store where the user is located as a variable
	Get-Location > $current_location
	# cd to pwsh home.
	if ($env:IsOnPlatform -eq 'Windows') {
		$global:PSDir = "$env:userprofile\Documents\PowerShell\"
		Set-Location -Path $PSDir
	}
	elseif ($env:IsOnPlatform -eq 'Linux' -or 'Mac') {
		$global:PSDir = "~/.config/powershell/"
		Set-Location -Path $PSDir
	}
	else {
		return $false
		Write-Host "Error, prehaps pwsh is not installed correctly or you are running a custom environment."
		Write-Host "Check out this file at '$PSDir' if you want to debug."
		exit 0;
	};
	#endif
	# Get the config file.
	# if it doesn't exist, create it.
	$config_file = 'config.json'
	if (!(Test-Path $config_file)) {
		New-Item -path . -name $config_file -type "file" -value ""
		Write-Host ""
		Write-Host "Couldn't find config file. Creating one now."
	}
	# Validate the config file.
	# if it is empty or the first line is invalid json, store "{}"
	$config_content = $(Get-Content -Path config.json)
	if ($config_content -eq "" -or " " -or "  " -or "   ") {
		Set-Content -Path config.json -Value "{}"
	}
	elseif ($($config_content.Count) -gt 1 -and $($config_content[0]) -ne "{" -or "{}") {
		Set-Content -Path config.json -Value "{}"
	}
	#endif

	function Read-Config () {

	}

	# cd back to where ever you were before running the script.
	Set-Location $current_location
}

function Invoke-Config () {
	Config
}

<# *
   * Main
   * #>
function Main () {
	Get-Date -Format MM/dd/yyyy` -` HH:mm:ss
	# Write-Host $(pwsh --version) # pwsh does this by default
	Write-Host "Platform: " -NoNewline
	Get-Platform
	# Import-Scripts
	Invoke-Config
	Set-Location
};
Main
