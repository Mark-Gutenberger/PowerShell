###########################################################################################
#                                      START CODE                                         #
###########################################################################################

function kdsghfklajhg {
	wsl.exe bash
};
Set-Alias wsl kdsghfklajhg;
Set-Alias bash kdsghfklajhg;
Set-Alias rn React-Native;
# fallback prompt, ya know, just in case something Fs up
# function Prompt() {
# "PS $($executionContext.SessionState.Path.CurrentLocation)$( '>' * ($nestedPromptLevel + 1)) ";
# };

function Prompt() {
	$Chicken = "🐔";
	Write-Host("$Chicken ") -NoNewLine -ForegroundColor white
	Write-Host($(Get-Date -Format "HH:mm:ss")) -NoNewLine -ForegroundColor white
	Write-Host(" " + "pwsh" + " ") -NoNewLine -ForegroundColor 2 # green
	Write-Host($(Get-Location)) -NoNewLine -ForegroundColor 1 # blue
	Write-Host(" > ") -NoNewLine -ForegroundColor white
	return " "
};

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

function iuoagfjhawefp() {
	$fore = $Host.UI.RawUI.ForegroundColor
	$regex_opts = ([System.Text.RegularExpressions.RegexOptions]::IgnoreCase `
			-bor [System.Text.RegularExpressions.RegexOptions]::Compiled)

	# TODO: add more extensive file matching support.
	# NOTE: these matching patterns are optimized for windows.

	$audio_files = New-Object System.Text.RegularExpressions.Regex(
		"\.(mp3|midi|mid)$", $regex_opts
	);
	$compressed_files = New-Object System.Text.RegularExpressions.Regex(
		'\.(zip|tar|gz|rar|jar|war|db|bdb|pdb|sqlite|blf|regtrans-ms)$', $regex_opts
	);
	$executable_files = New-Object System.Text.RegularExpressions.Regex(
		'\.(exe|bat|cmd|py|pl|ps1|psm1|vbs|rb|reg)$', $regex_opts
	);
	$text_files = New-Object System.Text.RegularExpressions.Regex(
		'\.(txt|cfg|conf|ini|csv|data|log|log1|log2|log3|log4|pdf|doc|docx|odt)$', $regex_opts
	);
	$code_files = New-Object System.Text.RegularExpressions.Regex(
		'\.(xml|html|js|jsx|ts|tsx|java|c|cc|cpp|h|hh|hpp|cs|rs|go|sh|bash|pl|class|php|json|jsonc|json5|yaml|yml)$', $regex_opts
	);
	Write-Host("=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-") -ForegroundColor 14
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
	Write-Host("")
	getDirSize
};

Set-Alias ls iuoagfjhawefp;
Set-Alias list iuoagfjhawefp;
