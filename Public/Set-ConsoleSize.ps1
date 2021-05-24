function Set-ConsoleSize {
  [CmdletBinding()]
  [Alias('SetWindow')]
  param(
    [int]$Width = 145,
    [int]$Height = 45
  )
  if ($env:WT_SESSION) {throw 'Does Not Work in Microsoft Terminal'}
  if ($Host.Name -notmatch 'ConsoleHost') {break}
  [console]::SetWindowSize($Width,$Height)
}
