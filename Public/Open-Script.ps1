function Open-Script {
  [Alias('Open')]
  Param(
    [Parameter(Mandatory,ValueFromPipeline)]
    [ValidateScript({($_ | Test-Path -PathType Leaf)})]
    [String[]]$Path
  )
  begin {
    if ($psISE) { $ISEFiles = $psISE.CurrentPowerShellTab.Files }
  }
  Process {
    foreach($File in $Path){
      switch ($psISE) {
        $true {
          $null = $ISEFiles.Add((Get-Item -Path $File).Fullname) ; break
        }
        $false {
          & powershell_ise.exe -File (Get-Item -Path $File).Fullname ; break
        }
      }
      Start-Sleep -Milliseconds 500
    }
  }
}
