function New-Shortcut{
  param(
    [Parameter(Mandatory)]
    [ValidateScript({
          if (-not(Test-Path -Path $_)) {
            throw '{0} - Invalid -Target' -f $_
          }
          return $true
    })]
    [String]$Target,
    [Parameter(Mandatory)]
    [ValidateScript({
          if (-not(Test-Path -Path $_ -IsValid)) {
            throw '{0} - ShortcutFile Path is Invalid' -f $_
          }
          if(-not (Test-Path -Path $_)) {
            throw '{0} already exists' -f $_
          }
          if(-not ($_ -match '[.lnk]')) {
            throw '{0} must end in .lnk' -f $_
          }
          return $true
    })]
    [String]$ShortcutFile,
    [string]$Arguments,
    [switch]$RunAsAdmin
  )
  begin{
    $WScriptShell = New-Object -ComObject WScript.Shell
  }
  process{
    $Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
    $Shortcut.TargetPath = $Target
    if ($Arguments) {$Shortcut.Arguments = $Arguments}
    $Shortcut.Save()
    Write-Verbose -Message 'Shortcut Saved'# -Verbose:$VerbosePreference

    if($RunAsAdmin) {
      $Bytes = [System.IO.File]::ReadAllBytes($ShortcutFile)
      $Bytes[0x15] = $Bytes[0x15] -bor 0x20
      [System.IO.File]::WriteAllBytes($ShortcutFile, $Bytes)
      Write-Verbose -Message ('{0} - Set to Run as Admin' -f $ShortcutFile)# -Verbose:$VerbosePreference
    }
  }
}
