function New-Shortcut {
  [CmdletBinding()]
  [Alias()]
  param(
    [Parameter(Mandatory)]
    [ValidateScript({
          if( -not ($_ | Test-Path))
          { throw "File or folder does not exist" }
          return $true
    })][String]$Target,
    [Parameter(Mandatory)]
    [ValidateScript({
          if( -not ($_ | Test-Path -IsValid))
          { throw "$_ - is not a valid path" }
          if(( -not ($_ -match "[.lnk]")) -or (-not ($_ -match "[.url]" )))
          { throw "$_ must be a lnk or url file" }
          return $true
    })][String]$ShortcutFile
  )
  begin {
    Write-Verbose -Message "Creating WScript.Shell ComObject"
    $WScriptShell = New-Object -ComObject WScript.Shell
  }
  process {
    Write-Verbose -Message "Creating Shortcut File"
    $Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
    Write-Verbose -Message "Setting TargetPath on Shortcut File"
    $Shortcut.TargetPath = $Target
    Write-Verbose -Message "Saving Completed Shortcut File"
    $Shortcut.Save()
  }
}