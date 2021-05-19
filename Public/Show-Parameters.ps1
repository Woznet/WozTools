function Show-Parameters {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)]
    [String[]]$Command
  )
  process{
    foreach($Com in $Command) {
      Get-Command -Name $Com -PipelineVariable pv1| Select-Object -ExpandProperty ParameterSets | Select-Object -ExpandProperty Parameters | Where-Object {$_.Name -notmatch (
          ([System.Management.Automation.PSCmdlet]::CommonParameters+[System.Management.Automation.PSCmdlet]::OptionalCommonParameters) -join '|'
      )} | Select-Object -Property Name,IsMandatory,Value*,Aliases -Unique | Format-Table -AutoSize -RepeatHeader -GroupBy @{n='CommandName';e={$pv1.Name}}
    }
  }
}
