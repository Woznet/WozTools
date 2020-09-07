function Max-PartitionSize {
  [CmdletBinding()]
  param()
  dynamicparam {
    $ParamName = 'DriveLetter'
    [String[]]$Values = (Get-WmiObject -Class win32_volume | ForEach-Object -MemberName DriveLetter | Sort-Object ).Replace(':', '')

    $Bucket = [Management.Automation.RuntimeDefinedParameterDictionary]::new()
    $AttributeList = [Collections.ObjectModel.Collection[System.Attribute]]::new()
    $AttribValidateSet = [ValidateSet]::new($Values)
    $AttributeList.Add($AttribValidateSet)
    $AttribParameter = [Parameter]::new()
    $AttribParameter.Mandatory = $true
    $AttributeList.Add($AttribParameter)
    $Parameter = [Management.Automation.RuntimeDefinedParameter]::new($ParamName, [String], $AttributeList)
    $Bucket.Add($ParamName, $Parameter)
    $Bucket
  }
  begin{
    $Letter = $PSBoundParameters[$ParamName]
  }
  process{
    $Size = (Get-PartitionSupportedSize -DriveLetter $Letter).SizeMax
    Resize-Partition -DriveLetter $Letter -Size $Size -PassThru -Verbose:$VerbosePreference
  }
  end{}
}
