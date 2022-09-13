$env:PYTHONIOENCODING="utf-8"

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

Set-Alias Admin Invoke-Admin
Set-Alias Edge MicrosoftEdge.exe;

function Invoke-Batstat () {
	WMIC PATH Win32_Battery Get EstimatedChargeRemaining
};

Set-Alias Batstat Invoke-Batstat
Set-Alias Battery Invoke-Batstat
Set-Alias WinTerm wt

function Invoke-ls() {
	# wrapper for ls command
	C:\Users\Mark-\source\lsd\target\debug\lsd.exe -a $Args

};
Set-Alias ls Invoke-ls

$OS = $env:OS
Set-Alias $OS $env:OS

$host.UI.Write("`e]0;$pwd`a")
# $host.ui.Write("🚀")

Invoke-Expression "$(thefuck --alias)"

Invoke-Expression (& starship init powershell)
# please do not configure the cli or PS1 here.
# use the starship default config file.


# Get-Date -Format MM/dd/yyyy` -` HH:mm:ss | Write-Host -ForegroundColor DarkGray
# Write-Host $(pwsh --version)
Set-Location ~
