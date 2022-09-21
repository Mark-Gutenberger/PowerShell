Import-Module PSReadLine

$env:PYTHONIOENCODING = "utf-8"

function Invoke-Admin () {
	if ($Args.Count -eq 0) {
		return $null
	}
	elseif ($Args.Count -ge 2) {
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

Set-Alias Admin Invoke-Admin

function Invoke-Batstat () {
	WMIC PATH Win32_Battery Get EstimatedChargeRemaining
};

Set-Alias Batstat Invoke-Batstat
Set-Alias Battery Invoke-Batstat

Set-Alias WinTerm wt

function Invoke-ls() {
	# wrapper for ls command
	$ls = "C:\Users\Mark-\source\lsd\target\debug\lsd.exe"
	# run lsd
	try {
		& $ls -a $Args
	}
	catch {
		Write-Host "Error: No batch operation, program, or executable matching the pattern of ``$ls`` found...`n Please edit your powershell profile and update the variable" -ForegroundColor Yellow
		Get-ChildItem $Args
	}
};
Set-Alias ls Invoke-ls

# set for starship
$OS = $env:OS
Set-Alias $OS $env:OS
Invoke-Expression (& starship init powershell)

$host.UI.Write("`e]0;$pwd`a")

Invoke-Expression "$(thefuck --alias)"

# Config PSReadLine
Set-PSReadLineOption -EditMode Windows
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
# `ForwardChar` accepts the entire suggestion text when the cursor is at the end of the line.
# This custom binding makes `RightArrow` behave similarly - accepting the next word instead of the entire suggestion text.
Set-PSReadLineKeyHandler -Key RightArrow `
	-BriefDescription ForwardCharAndAcceptNextSuggestionWord `
	-LongDescription "Move cursor one character to the right in the current editing line and accept the next word in suggestion when it's at the end of current editing line" `
	-ScriptBlock {
	param($key, $arg)

	$line = $null
	$cursor = $null
	[Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

	if ($cursor -lt $line.Length) {
		[Microsoft.PowerShell.PSConsoleReadLine]::ForwardChar($key, $arg)
	}
 else {
		[Microsoft.PowerShell.PSConsoleReadLine]::AcceptNextSuggestionWord($key, $arg)
	}
}

Set-PSReadLineKeyHandler -Key Tab `
	-BriefDescription ForwardCharAndAcceptNextSuggestionWord `
	-LongDescription "Move cursor one character to the right in the current editing line and accept the next word in suggestion when it's at the end of current editing line" `
	-ScriptBlock {
	param($key, $arg)

	$line = $null
	$cursor = $null
	[Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

	if ($cursor -lt $line.Length) {
		[Microsoft.PowerShell.PSConsoleReadLine]::ForwardChar($key, $arg)
	}
 else {
		[Microsoft.PowerShell.PSConsoleReadLine]::AcceptSuggestion($key, $arg)
	}
}
