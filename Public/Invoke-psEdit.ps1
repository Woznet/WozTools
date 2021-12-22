Function Invoke-psEdit {
  [Alias('psEdit')]
  param(
    [Parameter(
        Mandatory,
        ValueFromPipeline,
        ValueFromPipelineByPropertyName
    )]
    [Alias('FullName','FileNames')]
    [ValidateScript({
          if (-not (Test-Path -Path $_)) {
            throw '{1}Something went wrong.{1}Check Path - {0}' -f $_,[environment]::NewLine
          }
          return $true
    })]
    [string[]]$Path
  )
  Begin {
    if (-not ($psISE)) { throw 'PowerShell ISE Only' }
    Write-Verbose -Message ('Starting - {0}' -f $MyInvocation.MyCommand)
  }
  Process {
    foreach ($FileName in $Path) {
      $Resolved = Resolve-Path -Path $FileName
      Write-Verbose -Message ('Opening - {0}' -f $Resolved)
      $null = $psISE.CurrentPowerShellTab.Files.Add($Resolved)
    }
  }
  End {
    Write-Verbose -Message ('Ending - {0}' -f $MyInvocation.Mycommand)
  }
}
