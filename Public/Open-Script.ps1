function Open-Script {
  [Alias('Open')]
  Param(
    [Parameter(Mandatory,ValueFromPipeline)]
    [ValidateScript({($_ | Test-Path -PathType Leaf)})]
    [String[]]$Path
  )
  Process {
    foreach($File in $Path){
      switch ($psISE) {
        $true {
          $null = $psISE.CurrentPowerShellTab.Files.Add((Get-Item -Path $File).FullName) ; break
        }
        $false {
          & powershell_ise.exe -File (Get-Item -Path $File).FullName ; break
        }
      }
      Start-Sleep -Milliseconds 500
    }
  }
}
