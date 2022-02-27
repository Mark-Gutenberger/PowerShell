<#
SPDX-License-Identifier: MIT
Author: Mark Gutenberger <mark-gutenberger@outlook.com>
Main.ps1 (c) 2022
Desc: description
Created:  2022-02-24T00:34:39.695Z
Modified: 2022-02-27T19:04:14.970Z
#>

function getDirSize() {
	param ($dir)
	$bytes = 0
	Get-Childitem $dir | foreach-object {
		if ($_ -is [System.IO.FileInfo]) {
			$bytes += $_.Length
		}
	}
	if ($bytes -ge 1KB -and $bytes -lt 1MB) {
		Write-Host ("Total Size: " + [Math]::Round(($bytes / 1KB), 2) + " KB")
	}
	elseif ($bytes -ge 1MB -and $bytes -lt 1GB) {
		Write-Host ("Total Size: " + [Math]::Round(($bytes / 1MB), 2) + " MB")
	}
	elseif ($bytes -ge 1GB) {
		Write-Host ("Total Size: " + [Math]::Round(($bytes / 1GB), 2) + " GB")
	}
	else {
		Write-Host ("Total Size: " + $bytes + " bytes")
	}
};


. $env:USERPROFILE\Documents\Powershell\ls\Header.ps1 ?? ~/.config/Powershell/ls/Header.ps1

function Custom-ls() {
	$fore = $Host.UI.RawUI.ForegroundColor

	# TODO: add more extensive file matching support.
	# NOTE: these matching patterns are optimized for windows.
	Write-Host("--------------------------------------------------------------------------------")
	Write-Host("")
	Invoke-Expression ("Get-ChildItem $args") | ForEach-Object {
		if ($_.GetType().Name -eq 'DirectoryInfo') {
			$Host.UI.RawUI.ForegroundColor = '1'# blue
			Write-Host($_)
			$Host.UI.RawUI.ForegroundColor = $fore
		}
		elseif ($compressed_files.IsMatch($_.Name)) {
			$Host.UI.RawUI.ForegroundColor = '2' # green
			Write-Host($_)
			$Host.UI.RawUI.ForegroundColor = $fore
		}
		elseif ($executable_files.IsMatch($_.Name)) {
			$Host.UI.RawUI.ForegroundColor = '12' # magenta
			Write-Host($_)
			$Host.UI.RawUI.ForegroundColor = $fore
		}
		elseif ($code_files.IsMatch($_.Name)) {
			$Host.UI.RawUI.ForegroundColor = '5' # magenta
			Write-Host($_)
			$Host.UI.RawUI.ForegroundColor = $fore
		}
		elseif ($text_files.IsMatch($_.Name)) {
			$Host.UI.RawUI.ForegroundColor = '14' # yellow
			Write-Host($_)
			$Host.UI.RawUI.ForegroundColor = $fore
		}
		else {
			Write-Host($_)
		}
	}

	Write-Host("--------------------------------------------------------------------------------")
	Write-Host("")
	getDirSize
};
