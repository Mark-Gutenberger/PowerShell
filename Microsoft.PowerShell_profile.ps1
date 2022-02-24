<#
SPDX-License-Identifier: MIT
Author: Mark Gutenberger <mark-gutenberger@outlook.com>
Microsoft.Powershell_profile.ps1 (c) 2022
Desc: description
Created:  2022-02-12T00:34:39.695Z
Modified: 2022-02-24T00:49:26.867Z
#>

. $env:USERPROFILE\Documents\Powershell\ls\Main.ps1

#custom aliases:
function Custom-wsl {
	wsl.exe bash
};

Set-Alias wsl Custom-wsl;
Set-Alias bash Custom-wsl;
Set-Alias rn React-Native;
Set-Alias ls Custom-ls;
Set-Alias list Custom-ls;

# custom prompt:
# function Prompt() {
# "PS $($executionContext.SessionState.Path.CurrentLocation)$( '>' * ($nestedPromptLevel + 1)) ";
# };
function Prompt() {
	Write-Host($(Get-Date -Format "HH:mm:ss")) -NoNewLine -ForegroundColor white
	Write-Host(" " + "pwsh" + " ") -NoNewLine -ForegroundColor 2 # green
	Write-Host($(Get-Location)) -NoNewLine -ForegroundColor 1 # blue
	Write-Host(" > ") -NoNewLine -ForegroundColor white
	return " "
};
