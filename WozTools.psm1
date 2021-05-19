# Get public and private function definition files.

[Diagnostics.CodeAnalysis.SuppressMessageAttribute('UseApprovedVerbs', '')]

$Public  = @(Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue)
# $Private = @(Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue)
# Dot source the files
foreach ($Import in @($Public + $Private)) {
  try {
    . $Import.FullName
  }
  catch {
    Write-Error -Message ('Failed to import function {0}: {1}' -f ($Import.FullName),$_)
  }
}

Export-ModuleMember -Function $Public.Basename -Alias *
