function Open-Script {
  [Alias('Open')]
  Param(
    [Parameter(Mandatory,ValueFromPipeline,Position=0)]
    [ValidateScript({($_ | Test-Path -PathType Leaf)})]
    [String[]]$Path
  )
  Process {
    foreach($File in $Path){
      switch ($psISE) {
        $true {
          $null = $psISE.CurrentPowerShellTab.Files.Add((Get-Item -Path $File).Fullname)
          break
        }
        $false {
          & powershell_ise.exe -File (Get-Item -Path $File).Fullname
          break
        }
        default {
          & powershell_ise.exe -File (Get-Item -Path $File).Fullname
          break
        }
      }
    }
  }
}
