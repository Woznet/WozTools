Function Out-ISETab {
  Param(
    [Parameter(Mandatory,ValueFromPipeline)]
    [psobject]$InputObject,
    [ValidateScript({
          if ($_ | Test-Path) {
            throw 'Choose a path that does not exist.'
          }
          return $true
    })]
    [System.IO.FileInfo]$SaveAs
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
      $NewFile.SaveAs($SaveAs.FullName,[System.Text.UTF8Encoding]::new($false))
    }
  }
}
