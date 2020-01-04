function Get-Functions {
  [CmdletBinding()]
  [Alias("gfunc")]
  [OutputType([System.Management.Automation.FunctionInfo])]
  param()
  $funcs = Get-ChildItem -Path function:\
  return $funcs
}