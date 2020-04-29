Function Out-ISETab {
  [cmdletbinding(DefaultParameterSetName='nosave')]
  Param(
    [Parameter(Mandatory,ValueFromPipeline,ParameterSetName='nosave')]
    [object]$Inputobject,
    [ValidateScript({
          if($_ | Test-Path) {
            throw 'Choose a path that does not exist.'
          }
          if(-Not ($_ | Test-Path -PathType Leaf -IsValid)) {
            throw 'The Path argument must be a file.'
          }
          return $true
    })]
    [Parameter(ParameterSetName='save')]
    [IO.FileInfo]$SaveAs
  )
  Begin {
    if(!($psise)){
      throw 'Must run in PowerShell ISE'
    }
    $data = @()
  }
  Process {
    $data += $Inputobject
  }
  End {
    $newfile = $psISE.CurrentPowerShellTab.Files.Add()
    $newfile.Editor.InsertText(($data | Out-String))
    $newfile.Editor.SetCaretPosition(1,1)
    if ($SaveAs) {
      if ([IO.Path]::IsPathRooted($SaveAs)){
        $SaveAs = Resolve-Path -Path $SaveAs -Verbose:$VerbosePreference
      }
      Write-Verbose -Message ('Saving to: {0}' -f $SaveAs) -Verbose:$VerbosePreference
      $newfile.SaveAs($SaveAs)
    }
  }

}