Function Get-CommandParameters {
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

  (Get-Command -Name $Command).ParameterSets.Parameters | Where-Object {$_.Name -notin $CPara} |
  Select-Object -Property Name,@{n='ParameterType';e={$_.ParameterType.Name}},IsMandatory,Value*,@{n='Aliases';e={$_.Aliases -join ','}} -Unique | Format-Table -RepeatHeader
}
