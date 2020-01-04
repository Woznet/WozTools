Function Open-Script {
  [Alias('Open')]
  Param(
    [Parameter(Mandatory,ValueFromPipeline,Position=0)]
    [ValidateScript({($_ | Test-Path -PathType Leaf)})]
    [IO.FileInfo[]]$Path
  )
  Begin{
    if (!($psISE)){
      Write-Warning -Message 'You must be in the PowerShell ISE to run this command.'
    }
  }
  Process {
    foreach($f in $Path){
      $null = $psISE.CurrentPowerShellTab.Files.Add((Get-Item -Path $f).Fullname)
    }
  }
}