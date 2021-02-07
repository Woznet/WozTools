Function Get-CommandParameters {
  Param (
    [Parameter(Mandatory)]
    [ValidateScript({
          if( -Not (Get-Command -Name $_) ){
            throw 'Command does not exist'
          }
          return $true
    })]
    [string]$Command
  )

  $CPara = [System.Collections.Generic.List[string]]@()
  $CPara.AddRange([System.Management.Automation.PSCmdlet]::CommonParameters)
  $CPara.AddRange([System.Management.Automation.PSCmdlet]::OptionalCommonParameters)

  (Get-Command -Name $Command).ParameterSets.Parameters | Where-Object {$_.Name -notin $CPara} |
  Select-Object -Property Name,Aliases,IsMandatory,Value* -Unique | Format-Table -RepeatHeader
}
