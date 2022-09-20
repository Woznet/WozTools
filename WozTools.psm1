# Get public and private function definition files.

[Diagnostics.CodeAnalysis.SuppressMessageAttribute('UseApprovedVerbs', '')]

$Signature =  @'
[DllImport("Shlwapi.dll", CharSet = CharSet.Auto)]
public static extern long StrFormatByteSize(
long fileSize,
System.Text.StringBuilder buffer,
int bufferSize
);
'@
$SizeConverter = Add-Type -Name SizeConverter -Namespace 'WozDev.Win32API' -MemberDefinition $Signature -PassThru


$Public  = @(Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue)
# $Private = @(Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue)
# Dot source the files
# foreach ($Import in @($Public + $Private)) {
foreach ($Import in $Public) {
  try {
    . $Import.FullName
  }
  catch {
    Write-Error -Message ('Failed to import function {0}: {1}' -f ($Import.FullName),$_)
  }
}

Export-ModuleMember -Function $Public.Basename -Alias *
