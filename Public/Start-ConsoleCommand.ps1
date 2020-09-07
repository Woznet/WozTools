Function Start-ConsoleCommand {
  [CmdletBinding()]
  [Alias('scc')]
  Param(
    [AllowNull()]
    [scriptblock]$ConsoleCommand,
    [switch]$Admin
  )
  if($Admin) {
  Start-Process -FilePath powershell -ArgumentList ('-NoExit -Command {0}' -f $ConsoleCommand) -Verb RunAs
  }
  else {
    Start-Process -FilePath powershell -ArgumentList ('-NoExit -Command {0}' -f $ConsoleCommand)
  }
}
