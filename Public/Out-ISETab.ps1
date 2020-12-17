Function Out-ISETab {
  Param(
    [Parameter(Mandatory,ValueFromPipeline)]
    [object]$InputObject,
    [ValidateScript({
          if ($_ | Test-Path) {
            throw 'Choose a path that does not exist.'
          }
          if (-Not ($_ | Test-Path -PathType Leaf -IsValid)) {
            throw 'The Path argument must be a file.'
          }
          if (-not ([System.IO.Path]::IsPathRooted($_))) {
            throw 'The Path must be rooted'
          }
          return $true
    })]
    [System.IO.Path]$SaveAs
  )
  Begin {
    if(!($psISE)){ throw 'Must run in PowerShell ISE' }
    $Data = @()
  }
  Process {
    $Data += $InputObject
  }
  End {
    $NewFile = $psISE.CurrentPowerShellTab.Files.Add()
    $NewFile.Editor.InsertText(($Data | Out-String))
    $NewFile.Editor.SetCaretPosition(1,1)
    if ($SaveAs) {
      Write-Verbose -Message ('Saving to: {0}' -f $SaveAs) -Verbose:$VerbosePreference
      $NewFile.SaveAs($SaveAs)
    }
  }
}
