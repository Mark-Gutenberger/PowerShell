<#
SPDX-License-Identifier: MIT
Author: Mark Gutenberger <mark-gutenberger@outlook.com>
Header.ps1 (c) 2022
Desc: Yeah I code like a C developer.. so?
Created:  2022-02-24T00:50:51.167Z
Modified: 2022-02-27T19:04:08.704Z
#>

$regex_opts = ([System.Text.RegularExpressions.RegexOptions]::IgnoreCase `
		-bor [System.Text.RegularExpressions.RegexOptions]::Compiled)
function new_syntax([string[]]$args0) {
	New-Object System.Text.RegularExpressions.Regex($args0);
}

$audio_files = new_syntax(
	"\.(mp3|midi|mid)$", $regex_opts
);
$compressed_files = new_syntax(
	'\.(zip|tar|gz|rar|jar|war|db|bdb|pdb|sqlite|blf|regtrans-ms)$', $regex_opts
);
$executable_files = new_syntax(
	'\.(exe|bat|cmd|py|pl|ps1|psm1|vbs|rb|reg)$', $regex_opts
);
$text_files = new_syntax(
	'\.(txt|cfg|conf|ini|csv|data|log|log1|log2|log3|log4|pdf|doc|docx|odt)$', $regex_opts
);
$code_files = new_syntax(
	'\.(xml|html|js|jsx|ts|tsx|java|c|cc|cpp|h|hh|hpp|cs|rs|go|sh|bash|pl|class|php|json|jsonc|json5|yaml|yml)$', $regex_opts
);
