function New-DynamicParam {
  [CmdletBinding()]
  param(
    [string]$Name,
    [string[]]$Options,
    [switch]$Mandatory,
    [string]$SetName='__AllParameterSets',
    [int]$Position,
    [switch]$ValueFromPipelineByPropertyName,
    [string]$HelpMessage
  )
  #param attributes
  $ParamAttr = [Parameter]::new()
  $ParamAttr.ParameterSetName = $SetName
  if($Mandatory){
    $ParamAttr.Mandatory = $True
  }
  if($Position -ne $null){
    $ParamAttr.Position=$Position
  }
  if($ValueFromPipelineByPropertyName){
    $ParamAttr.ValueFromPipelineByPropertyName = $True
  }
  if($HelpMessage){
    $ParamAttr.HelpMessage = $HelpMessage
  }
  ##param validation set
  $ParamOptions = [ValidateSet]::new($options)
  $AttributeCollection = [Collections.ObjectModel.Collection[System.Attribute]]::new()
  $AttributeCollection.Add($ParamAttr)
  $AttributeCollection.Add($ParamOptions)
  $Parameter = [System.Management.Automation.RuntimeDefinedParameter]::new($Name, [string], $AttributeCollection)
  $Dictionary = [System.Management.Automation.RuntimeDefinedParameterDictionary]::new()
  $Dictionary.Add($Name, $Parameter)
  $Dictionary
}
