function Get-ParameterValue {
  <#
      .Synopsis
      Get the actual values of parameters which have manually set (non-null) default values or values passed in the call     

      .Description        
      Unlike $PSBoundParameters, the hashtable returned from Get-ParameterValues includes non-empty default parameter values.
      NOTE: Default values that are the same as the implied values are ignored (e.g.: empty strings, zero numbers, nulls).   

      .Notes
      https://gist.github.com/elovelan/d697882b99d24f1b637c7e7a97f721f2/
  
      .Example
      function Test-Parameters {
      [CmdletBinding()]
      param(
      $Name = $Env:UserName,
      $Age
      )
      $Parameters = Get-ParameterValues
      # This WILL ALWAYS have a value...
      Write-Host $Parameters["Name"]
      # But this will NOT always have a value...
      Write-Host $PSBoundParameters["Name"]
      }

      .Link
      https://gist.github.com/Jaykul/72f30dce2cca55e8cd73e97670db0b09/
  #>
  [CmdletBinding()]
  param()
  $Invocation = Get-Variable -Scope 1 -Name MyInvocation -ValueOnly
  $BoundParameters = Get-Variable -Scope 1 -Name PSBoundParameters -ValueOnly
    
  $ParameterValues = [pscustomobject]@{}
  foreach ($Parameter in $Invocation.MyCommand.Parameters.GetEnumerator()) {
    try {
      $Key = $Parameter.Key
      if ($null -ne ($Value = Get-Variable -Name $Key -ValueOnly -ErrorAction Ignore)) {
        if ($Value -ne ($null -as $Parameter.Value.ParameterType)) {
          $ParameterValues.psobject.Members.Add([psnoteproperty]::new($Key, $Value))
        }
      }
      if ($BoundParameters.ContainsKey($Key)) {
        $ParameterValues.psobject.Members.Add([psnoteproperty]::new($Key, $BoundParameters[$Key]))
      }
    }
    finally {}
  }
  return $ParameterValues
}