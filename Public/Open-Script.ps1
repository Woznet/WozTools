function Open-Script {
  [Alias('Open')]
  Param(
    [Parameter(Mandatory,ValueFromPipeline,Position=0)]
    [ValidateScript({($_ | Test-Path -PathType Leaf)})]
    [System.IO.FileInfo[]]$Path
  )
  Begin{
    if (!($psISE)){ throw 'Must run in PowerShell ISE' }
  }
  Process {
    foreach($File in $Path){
      $null = $psISE.CurrentPowerShellTab.Files.Add((Get-Item -Path $File).Fullname)
    }
  }
}
