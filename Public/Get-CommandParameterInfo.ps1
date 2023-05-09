Function Get-CommandParameterInfo {
  <#
      To Do: 
      Output formating
      Include command name in output
  #>
  Param(
    [Parameter(Mandatory)]
    [ValidateScript({
          if (-Not (Get-Command -Name $_ -ErrorAction SilentlyContinue)) {
            throw 'Command does not exist'
          }
          return $true
    })]
    [string]$Command
  )
  $CPara = @(
    [System.Management.Automation.PSCmdlet]::CommonParameters
    [System.Management.Automation.PSCmdlet]::OptionalCommonParameters
  )

  (Get-Command -Name $Command).ParameterSets | ForEach-Object {
    $_.Parameters | Where-Object {$_.Name -notin $CPara} | Select-Object -Property Name,
    @{n='ParameterType';e={$_.ParameterType.Name}},
    IsMandatory,
    @{n='VF-Pipeline';e={$_.ValueFromPipeline}},
    @{n='VF-PipelineByPropName';e={$_.ValueFromPipelineByPropertyName}},
    @{n='VF-RemainingArgs';e={$_.ValueFromRemainingArguments}},
    @{n='Aliases';e={$_.Aliases -join ','}} | Format-Table -RepeatHeader
  }
}