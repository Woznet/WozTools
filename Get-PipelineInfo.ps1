Function Get-PipelineInfo {
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory)]
		[String]$Cmdlet
	)
	Write-Verbose -Message ('Pipeline informaiton for {0}.' -f $Cmdlet)
	(Get-Help -Name $Cmdlet).Parameters.Parameter |	Where-Object PipelineInput -ne 'False' |
	Select-Object -Property Name , @{N = 'ByValue' ;	E = { If ($_.PipelineInput -Like '*ByValue*') {$True}
	Else {$False} }},	@{N = 'ByPropertyName' ; E = { If ($_.PipelineInput -Like '*ByPropertyName*') {$True}
	Else {$False} }},	@{N = 'Type' ; E = {$_.Type.Name}}
}