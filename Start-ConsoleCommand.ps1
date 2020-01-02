Function Start-ConsoleCommand {
	[CmdletBinding()]
	[Alias('scc')]
	Param(
		[AllowNull()]
		[scriptblock]$ConsoleCommand
	)
	Start-Process -FilePath powershell -ArgumentList ('{0}' -f $("-NoExit -Command $ConsoleCommand"))
}