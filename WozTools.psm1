# Get public, private, and lib definition files.
$Public = @(Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -File -ErrorAction SilentlyContinue)
$Private = @(Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -File -ErrorAction SilentlyContinue)
# $Lib = @(Get-ChildItem -Path $PSScriptRoot\Lib\ -Recurse -Include ('*.ps1', '*.cs') -File -ErrorAction SilentlyContinue)
# Dot source the files
# foreach ($Import in @($Lib + $Private + $Public)) {
foreach ($Import in @($Private + $Public)) {
    try {
        switch ($Import.Extension) {
            '.ps1' {
                Write-Verbose -Message ('Importing - {0}' -f $Import.Name) -Verbose
                . $Import.FullName
            }
            '.cs' {
                Write-Verbose -Message ('Adding Type - {0}' -f $Import.Name) -Verbose
                #  *>$null to skip warning on ArgumentCompletions.cs
                Add-Type -Path $Import.FullName -PassThru:$false *>$null
            }
            default {
                Write-Host -Object ('Bad file extension - {0}' -f $Import.Name) -ForegroundColor Red
            }
        }
    }
    catch {
        Write-Error -Message ('Failed to import function {0}: {1}' -f ($Import.FullName), $_)
    }
}

Export-ModuleMember -Function $Public.Basename -Alias *
# Export-ModuleMember -Function * -Alias *
