function New-Shortcut {
  [CmdletBinding()]
  [Alias()]
  param (
    [Parameter(Mandatory)]
    [ValidateScript({
          ($_ | Test-Path)
    })]
    [System.IO.FileInfo]$TargetFile,
    [Parameter(Mandatory)]
    [ValidateScript({
          ($_ | Test-Path -IsValid)
    })]
    [ValidateScript({
          if( -not ($_ -match '[.lnk]')) {
          Throw ('{0} must end in .lnk' -f $_)
        }
          return $true
    })]
    [String]$ShortcutFile,
    [switch]$RunAsAdmin
  )
  begin {
    $WScriptShell = New-Object -ComObject WScript.Shell
  }
  process {
    $Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
    $Shortcut.TargetPath = $TargetFile
    $Shortcut.Save()
    Write-Verbose -Message 'Shortcut Saved' -Verbose:$VerbosePreference
    
    if($RunAsAdmin -eq $True) {
      $bytes = [System.IO.File]::ReadAllBytes($ShortcutFile)
      $bytes[0x15] = $bytes[0x15] -bor 0x20
      [System.IO.File]::WriteAllBytes($ShortcutFile, $bytes)
      Write-Verbose -Verbose:$VerbosePreference -Message ('{0} - Set to Run as Admin' -f $ShortcutFile)
    }
  }
  end {
    if( -not ( Test-Path -Path $ShortcutFile)) {
      throw '.lnk file could not be found'
    }
  }
}