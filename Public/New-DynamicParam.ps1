Function New-DynamicParam {
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
  $ParamAttr = New-Object -TypeName System.Management.Automation.ParameterAttribute
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
  $ParamOptions = New-Object -TypeName System.Management.Automation.ValidateSetAttribute -ArgumentList $options
  $AttributeCollection = New-Object -TypeName 'Collections.ObjectModel.Collection[System.Attribute]'
  $AttributeCollection.Add($ParamAttr)
  $AttributeCollection.Add($ParamOptions)
  $Parameter = New-Object -TypeName System.Management.Automation.RuntimeDefinedParameter 	-ArgumentList @($Name, [string], $AttributeCollection)
  $Dictionary = New-Object -TypeName System.Management.Automation.RuntimeDefinedParameterDictionary
  $Dictionary.Add($Name, $Parameter)
  $Dictionary
}