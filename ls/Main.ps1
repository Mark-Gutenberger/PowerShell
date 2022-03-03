<#
SPDX-License-Identifier: MIT
Author: Mark Gutenberger <mark-gutenberger@outlook.com>
Main.ps1 (c) 2022
Desc: description
Created:  2022-02-24T00:34:39.695Z
Modified: 2022-03-03T16:15:42.109Z
#>


$regex_opts = ([System.Text.RegularExpressions.RegexOptions]::IgnoreCase `
 		-bor [System.Text.RegularExpressions.RegexOptions]::Compiled)
function new_syntax ([string[]]$args0) {
	New-Object System.Text.RegularExpressions.Regex ($args0);
}

$audio_files = new_syntax (
	"\.(mp3|midi|mid)$",$regex_opts
);
$compressed_files = new_syntax (
	'\.(zip|tar|gz|rar|jar|war|db|bdb|pdb|sqlite|blf|regtrans-ms)$',$regex_opts
);
$executable_files = new_syntax (
	'\.(exe|bat|cmd|py|pl|ps1|psm1|vbs|rb|reg)$',$regex_opts
);
$text_files = new_syntax (
	'\.(txt|cfg|conf|ini|csv|data|log|log1|log2|log3|log4|pdf|doc|docx|odt)$',$regex_opts
);
$code_files = new_syntax (
	'\.(xml|html|js|jsx|ts|tsx|java|c|cc|cpp|h|hh|hpp|cs|rs|go|sh|bash|pl|class|php|json|jsonc|json5|yaml|yml)$',$regex_opts
);

function getDirSize () {
	param($dir)
	$bytes = 0
	Get-ChildItem $dir -Force | ForEach-Object {
		if ($_ -is [System.IO.FileInfo]) {
			$bytes += $_.Length
		}
	}
	if ($bytes -ge 1KB -and $bytes -lt 1MB) {
		Write-Host ("Total Size: " + [math]::Round(($bytes / 1KB),2) + " KB")
	}
	elseif ($bytes -ge 1MB -and $bytes -lt 1GB) {
		Write-Host ("Total Size: " + [math]::Round(($bytes / 1MB),2) + " MB")
	}
	elseif ($bytes -ge 1GB) {
		Write-Host ("Total Size: " + [math]::Round(($bytes / 1GB),2) + " GB")
	}
	else {
		Write-Host ("Total Size: " + $bytes + " bytes")
	}
};


function Custom-ls () {
	$fore = $Host.UI.RawUI.ForegroundColor

	# TODO: add more extensive file matching support.
	# NOTE: these matching patterns are optimized for windows.
	Write-Host ("--------------------------------------------------------------------------------")
	Write-Host ("")
	Invoke-Expression ("Get-ChildItem $args") | ForEach-Object {
		if ($_.GetType().Name -eq 'DirectoryInfo') {
			$Host.UI.RawUI.ForegroundColor = '1' # blue
			Write-Host ($_)
			$Host.UI.RawUI.ForegroundColor = $fore
		}
		elseif ($compressed_files.IsMatch($_.Name)) {
			$Host.UI.RawUI.ForegroundColor = '2' # green
			Write-Host ($_)
			$Host.UI.RawUI.ForegroundColor = $fore
		}
		elseif ($executable_files.IsMatch($_.Name)) {
			$Host.UI.RawUI.ForegroundColor = '12' # magenta
			Write-Host ($_)
			$Host.UI.RawUI.ForegroundColor = $fore
		}
		elseif ($code_files.IsMatch($_.Name)) {
			$Host.UI.RawUI.ForegroundColor = '5' # magenta
			Write-Host ($_)
			$Host.UI.RawUI.ForegroundColor = $fore
		}
		elseif ($text_files.IsMatch($_.Name)) {
			$Host.UI.RawUI.ForegroundColor = '14' # yellow
			Write-Host ($_)
			$Host.UI.RawUI.ForegroundColor = $fore
		}
		else {
			Write-Host ($_)
		}
	}

	Write-Host ("--------------------------------------------------------------------------------")
	Write-Host ("")
	getDirSize
};
