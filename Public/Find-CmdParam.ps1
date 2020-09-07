function Find-CmdParam {
  [cmdletbinding()]
  Param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$Command,
    [switch]$ShowAll
  )
  Begin{
    $common = @(
      'Verbose','Debug','ErrorAction','WarningAction',
      'InformationAction','ErrorVariable','WarningVariable',
      'InformationVariable','OutVariable','OutBuffer',
      'PipelineVariable','WhatIf','Confirm'
    )
    $Params = [System.Collections.Generic.List[string]]::new()
    $Params += (@'
{1}Command: {0}
--------------------
---- Parameters ----
'@ -f $Command,([environment]::NewLine))
  }
  Process{
    if($ShowAll){
      $Params += (Get-Command -Name $Command).Parameters.Keys | Select-Object -Unique
    }
    else{
      $Params += (Get-Command -Name $Command).Parameters.Keys | Select-Object -Unique | Where-Object { $_ -notin $common }
    }
  }
  End{
    return $Params
  }
}
