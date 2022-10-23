function Convert-FileLength {
	[CmdletBinding()]
	[Alias('Convert-Size')]
  param(
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ValueFromPipeline)]
    [Alias('Size')]
    [long]$Length
  )
  begin {
    # TODO: Change "SizeConverter" to "LengthConverter"
	try {
    $null = [WozDev.Win32API.SizeConverter]
  }
  catch {
    Write-Verbose ' ~ Required Type not loaded, starting Add-Type process ~' -Verbose
    $MemberDef =  @'
[DllImport("Shlwapi.dll", CharSet = CharSet.Auto)]
public static extern long StrFormatByteSize(
long fileSize,
System.Text.StringBuilder buffer,
int bufferSize
);
'@
    $SizeConverter = Add-Type -Name SizeConverter -Namespace 'WozDev.Win32API' -MemberDefinition $MemberDef
  }

  }
  process {
	  if ([WozDev.Win32API.SizeConverter] -as [type]) {
	    $StringBuilder = [System.Text.StringBuilder]::new(1024)
      $null = [WozDev.Win32API.SizeConverter]::StrFormatByteSize(
	      $Length,
	      $StringBuilder,
	      $StringBuilder.Capacity
	    )
      return $StringBuilder.ToString()
	  }
	  else {
		  # Add ANSI color for missing SizeConverter
		  return $Length
	  }
  }
}

