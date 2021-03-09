function Get-PipelineInfo {
  param(
    [Parameter(Mandatory)]
    [ValidateScript({
          if (-not (Get-Command -Name $_ -ErrorAction Ignore)) {
            throw ('{0} - Command Not Found' -f $_)
          }
          return $true
    })]
    [String]$Command
  )
  Write-Verbose -Message ('Pipeline informaiton for {0}.' -f $Command)
  (Get-Help -Name $Command).Parameters.Parameter | Where-Object PipelineInput |
  Select-Object -Property Name,
  @{
    Name = 'ByValue'
    Expression = { if ($_.PipelineInput -Like '*ByValue*') { $True } else { $False } }
  },
  @{
    Name = 'ByPropertyName'
    Expression = { if ($_.PipelineInput -Like '*ByPropertyName*') { $True } else { $False } }
  },
  @{
    Name = 'Type'
    Expression = { $_.Type.Name }
  }
}
