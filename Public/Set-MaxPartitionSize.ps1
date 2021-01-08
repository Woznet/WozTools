function Set-MaxPartitionSize {
  [CmdletBinding()]
  [Alias('Max-PartitionSize')]
  param()
  dynamicparam {
    $ParamName = 'DriveLetter'
    [String[]]$Values = (Get-CimInstance -ClassName Win32_Volume | Select-Object -ExpandProperty DriveLetter | Sort-Object).Replace(':', '')

    $Bucket = [System.Management.Automation.RuntimeDefinedParameterDictionary]::new()
    $AttributeList = [System.Collections.ObjectModel.Collection[System.Attribute]]::new()
    $AttribValidateSet = [ValidateSet]::new($Values)
    $AttributeList.Add($AttribValidateSet)
    $AttribParameter = [Parameter]::new()
    $AttribParameter.Mandatory = $true
    $AttributeList.Add($AttribParameter)
    $Parameter = [System.Management.Automation.RuntimeDefinedParameter]::new($ParamName, [String], $AttributeList)
    $Bucket.Add($ParamName, $Parameter)
    $Bucket
  }
  process{
    $Letter = $PSBoundParameters[$ParamName]

    $Size = (Get-PartitionSupportedSize -DriveLetter $Letter).SizeMax
    Resize-Partition -DriveLetter $Letter -Size $Size -Verbose:$VerbosePreference
    Get-Volume -DriveLetter $Letter
  }
}
