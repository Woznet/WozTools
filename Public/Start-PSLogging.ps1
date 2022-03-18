function Start-PSLogging {
  [CmdletBinding(DefaultParameterSetName = 'Default')]
  param(
    [ValidateScript({
          if (-not ($_ | Test-Path -PathType Leaf -IsValid)) {
            throw 'Invalid Path.  Path must be a file.'
          }
          return $true
    })]
    [Parameter(ParameterSetName = 'Path')]
    [string]$Path,
    [Parameter(ParameterSetName = 'Default')]
    [switch]$Default
  )
  $PSLogPath = switch ($PSCmdlet.ParameterSetName) {
    'Path' {
      $Path
    }
    default {
      [System.IO.Path]::Combine(
        ($PROFILE | Split-Path -Parent),
        'logs',
        [datetime]::Today.ToString('MMM'),
        [datetime]::Today.Day,
        ('{0}-{1}.log' -f (Get-Process -Id $PID).ProcessName,$PID)
      )
    }
  }
  $null = Import-Module -Global PSReadline -MinimumVersion 2.2.2 -ErrorAction Stop
  
  try {
    Set-PSReadLineOption -PredictionSource HistoryAndPlugin
    Import-Module -Global Az.Tools.Predictor -PassThru:$false
  }
  catch {
    Set-PSReadLineOption -PredictionSource History
  }
  'PredictionSource: {0}' -f (Get-PSReadLineOption).PredictionSource | Write-Verbose

  Set-PSReadLineOption -ShowToolTips
  Set-PSReadLineOption -HistorySaveStyle SaveIncrementally
  Set-PSReadLineOption -HistorySavePath $PSLogPath
  'HistorySavePath: {0}' -f (Get-PSReadLineOption).HistorySavePath | Write-Verbose
  $Test = Test-Path -Path $PSLogPath
  if (-not ($Test)) {
    $null = New-Item -Path $PSLogPath -ItemType File -Force
  }
}
