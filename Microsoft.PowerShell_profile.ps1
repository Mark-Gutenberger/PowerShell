<#
SPDX-License-Identifier: MIT
Author: Mark Gutenberger <mark-gutenberger@outlook.com>
Microsoft.Powershell_profile.ps1 (c) 2022
Desc: description
Created:  2022-02-12T00:34:39.695Z
Modified: 2022-04-08T14:53:51.823Z
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
   * Admin
   * #>

function Invoke-Admin () {
	if ($Args.Count -eq 0) {
		Write-Host "Error: No arguments passed" -ForegroundColor Yellow
		return $null
	}
	elseif ($Args.Count -ge 2) {
		Write-Host "Error: Multiple arguments not yet supported" -ForegroundColor Yellow
		return $null
 }
	else {
		# convert args to string
		$args_ = $Args[0].ToString()
		try {
			Start-Process $args_ -Verb runAs
		}
		catch {
			Write-Host  "Error: No batch operation, program, or executable matching the pattern of ``$args_`` found...`nEnsure the path is correct or that it is accessible from your PATH variable." -ForegroundColor Red
			return $null
		};
	};
};
<# *
   * Alias declarations:
   * #>
Set-Alias time Get-Date
Set-Alias Admin Invoke-Admin
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
function Invoke-Batstat () {
	WMIC PATH Win32_Battery Get EstimatedChargeRemaining
};
Set-Alias batstat Invoke-Batstat
Set-Alias battery Invoke-Batstat

<# *
   * Starship stuff
   * #>
function Invoke-Starship-PreCommand {
	$host.UI.Write("`e]0;$pwd`a")
};

Invoke-Starship-PreCommand
Invoke-Expression (& starship init powershell) #DevSkim: ignore DS104456 until 2022-05-07




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
		[string]$global:PSDir = "~/.config/powershell/"
		Set-Location -Path $PSDir
	}
	else {
		return $false
		Write-Host "Error: prehaps pwsh is not installed correctly or you are running a custom environment." -Foregroundcolor Red
		Write-Host "Check out this file at '$PSDir' if you want to debug." -Foregroundcolor Red
		exit 0;
	};
	#endif
	# Get the config file.
	# if it doesn't exist, create it.
	$config_file = 'config.json' # REMINDER: Linux && OSX are CASE SENSITIVE.
	$config_file = $PSDir + $config_file
	if (!(Test-Path $config_file)) {
		Write-Host "`nCouldn't find config file. Creating one now at:`n`n  '$config_file'`n`n" -ForegroundColor yellow
		New-Item -path $config_file -type "file" -value "{}" -Force
	}
	[string]$config_json = $(Get-Content -Path $config_file -Raw -Force)

	function Read-Config () {
		if ($(Test-Json $config_json)) {
			# do good stuff here...
			$config_content = $(ConvertFrom-Json -InputObject $config_json -AsHashtable)
			Write-Output $config_content

		}
		else {
			Write-Host "Error: Invalid JSON in config file. `nRewriting file & archiving old file to `n  '$PSDir`config.invalid.json'." -ForegroundColor red
			New-Item -path $PSDir -name "config.invalid.json" -type "file" -value $config_json -Force
			New-Item -path $config_file -type "file" -value "{}" -Force
		}
	}
	Read-Config

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
	Get-Date -Format MM/dd/yyyy` -` HH:mm:ss | Write-Host -ForegroundColor DarkGray
	# Write-Host $(pwsh --version) # pwsh does this by default
	Write-Host "Platform: " -NoNewline
	Get-Platform | Write-Host -ForegroundColor blue
	# Import-Scripts
	Invoke-Config
	Set-Location
};
Main
