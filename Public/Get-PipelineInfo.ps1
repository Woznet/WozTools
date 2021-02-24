function Get-PipelineInfo {
  param(
    [Parameter(Mandatory)]
    [ValidateScript({
          if (-not (Get-Command -Name $_ -ErrorAction SilentlyContinue)) {
            throw ('Cannot find command - {0}' -f $_)
          }
          return $true
    })]
    [String]$Command
  )
  Write-Verbose -Message ('Pipeline informaiton for {0}.' -f $Command)
  (Get-Help -Name $Command).Parameters.Parameter | Where-Object {$_.PipelineInput -ne 'False'} |
  Select-Object -Property Name, @{N = 'ByValue' ; E = { if ($_.PipelineInput -Like '*ByValue*') {$True}
  else {$False} }}, @{N = 'ByPropertyName' ; E = { if ($_.PipelineInput -Like '*ByPropertyName*') {$True}
  else {$False} }}, @{N = 'Type' ; E = {$_.Type.Name}}
}
