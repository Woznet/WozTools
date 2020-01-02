Function Out-ISETab {
  [cmdletbinding()]
  Param(
    [Parameter(Position=0,Mandatory,ValueFromPipeline)]
    [object]$Inputobject,
    [ValidateScript({
          if($_ | Test-Path){
            throw 'Choose a path that does not exist.'
          }
          if(-Not ($_ | Test-Path -PathType Leaf -IsValid) ){
            throw 'The Path argument must be a file.'
          }
          return $true
    })]
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
      $newfile.SaveAs($SaveAs)
    }
  }
}