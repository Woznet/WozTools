function New-Shortcut{
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)]
    [ValidateScript({
          Test-Path -Path $_
    })]
    [String]$Target,
    [Parameter(Mandatory)]
    [ValidateScript({
          Test-Path -Path $_ -IsValid
    })]
    [ValidateScript({
          if( -not (Test-Path -Path $_)) {
            Throw ('{0} already exists' -f $_)
          }
          if( -not ($_ -match '[.lnk]')) {
            Throw ('{0} must end in .lnk' -f $_)
          }
          return $true
    })]
    [String]$ShortcutFile,
    [switch]$RunAsAdmin
  )
  begin{
    $WScriptShell = New-Object -ComObject WScript.Shell
  }
  process{
    $Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
    $Shortcut.TargetPath = $Target
    $Shortcut.Save()
    Write-Verbose -Message 'Shortcut Saved' -Verbose:$VerbosePreference
    
    if($RunAsAdmin -eq $True) {
      $bytes = [System.IO.File]::ReadAllBytes($ShortcutFile)
      $bytes[0x15] = $bytes[0x15] -bor 0x20
      [System.IO.File]::WriteAllBytes($ShortcutFile, $bytes)
      Write-Verbose -Verbose:$VerbosePreference -Message ('{0} - Set to Run as Admin' -f $ShortcutFile)
    }
  }
  end{}
}
