# Get public, private, and lib definition files.
$Public  = @(Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue)
$Private = @(Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue)
$Lib =     @(Get-ChildItem -Path $PSScriptRoot\Lib\ -Recurse -Include ('*.ps1','*.cs') -ErrorAction SilentlyContinue)
# Dot source the files
foreach ($Import in @($Public + $Private + $Lib)) {
# foreach ($Import in @($Public + $Private)) {
# foreach ($Import in $Public) {
  try {
    switch ($Import.Extension) {
      '.ps1' {
        Write-Verbose -Message ('Importing - {0}' -f $Import.Name)
        . $Import.FullName
      }
      '.cs' {
        Write-Verbose -Message ('Adding Type - {0}' -f $Import.Name)

        #  *>$null to skip warning on ArgumentCompletions.cs
        Add-Type -Path $Import.FullName -PassThru:$false *>$null
      }
    }
  }
  catch {
    Write-Error -Message ('Failed to import function {0}: {1}' -f ($Import.FullName),$_)
  }
}

# Export-ModuleMember -Function $Public.Basename -Alias *
Export-ModuleMember -Function * -Alias *
