Function Invoke-psEdit {
  [Alias('psEdit')]
  param(
    [Parameter(
        ValueFromPipelineByPropertyName,
        ValueFromPipeline,
        Mandatory
    )]
    [Alias('FullName')]
    [ValidateScript({
          if (-not (Test-Path -Path $_)) {
            throw '{1}Something went wrong.{1}Check Path - {0}' -f $_,"`n"
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
    foreach ($FileName in ($ExecutionContext.SessionState.Path.GetResolvedPSPathFromPSPath($Path))) {
      Write-Verbose -Message ('Opening - {0}' -f $FileName)
      $null = $psISE.CurrentPowerShellTab.Files.Add($FileName)
    }
  }
  End {
    Write-Verbose -Message ('Ending - {0}' -f $MyInvocation.Mycommand)
  }
}
