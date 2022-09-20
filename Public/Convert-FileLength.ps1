function Convert-FileLength {
	[CmdletBinding()]
	[Alias('Convert-Size')]
  param(
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ValueFromPipeline)]
    [Alias('Length')]
    [long]$Size
  )
  begin {
<#
	try {
$null = [WozDev.Win32API.SizeConverter]
}
catch {
      $Signature =  @'
[DllImport("Shlwapi.dll", CharSet = CharSet.Auto)]
public static extern long StrFormatByteSize(
long fileSize,
System.Text.StringBuilder buffer,
int bufferSize
);
'@
      $SizeConverter = Add-Type -Name SizeConverter -Namespace 'WozDev.Win32API' -MemberDefinition $Signature -PassThru
}
#>
  }
  process {
	  if ([WozDev.Win32API.SizeConverter] -as [type]) {
	  $StringBuilder = [System.Text.StringBuilder]::new(1024)
    $null = [WozDev.Win32API.SizeConverter]::StrFormatByteSize(
	$Size,
	$StringBuilder,
	$StringBuilder.Capacity
	)
    return $StringBuilder.ToString()
	  }
	  else {
		  # Add ANSI color for missing SizeConverter
		  return $Size
	  }

  }
}