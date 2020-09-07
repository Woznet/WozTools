function Get-PipelineInfo {
	param (
		[Parameter(Mandatory)]
		[String]$Cmdlet
	)
	Write-Verbose -Message ('Pipeline informaiton for {0}.' -f $Cmdlet)
	(Get-Help -Name $Cmdlet).Parameters.Parameter |	Where-Object PipelineInput -ne 'False' |
	Select-Object -Property Name, @{N = 'ByValue' ; E = { if ($_.PipelineInput -Like '*ByValue*') {$True}
	else {$False} }}, @{N = 'ByPropertyName' ; E = { if ($_.PipelineInput -Like '*ByPropertyName*') {$True}
	else {$False} }}, @{N = 'Type' ; E = {$_.Type.Name}}
}
