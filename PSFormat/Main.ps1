Get-ChildItem -Path .\ -Include *.ps1,*.psm1 -Recurse | Edit-DTWBeautifyScript -IndentType Tabs

function PS-Format () {
	Get-ChildItem -Path .\ -Include *.ps1,*.psm1 -Recurse | Edit-DTWBeautifyScript -IndentType Tabs
};
