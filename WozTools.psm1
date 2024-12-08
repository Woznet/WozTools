
# Load pre req files
Add-Type -Path (Join-Path $PSScriptRoot -ChildPath 'Lib\KeyboardInput\KeyboardInput.cs' -Resolve) -PassThru:$false
Add-Type -Path (Join-Path $PSScriptRoot -ChildPath 'Lib\LengthFormatter\LengthFormatter.cs' -Resolve) -PassThru:$false

. (Join-Path $PSScriptRoot -ChildPath 'Lib\ArgumentCompletions\ArgumentCompletions.ps1' -Resolve)
. (Join-Path $PSScriptRoot -ChildPath 'Lib\SecureStringTransform\SecureStringTransform.ps1' -Resolve)

# Update-FormatData -AppendPath (Join-Path $PSScriptRoot -ChildPath 'Lib\Formatting\MyCustomFileInfo.format.ps1xml' -Resolve)

# Get public, private, and lib definition files.
$Public = @(Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -File -ErrorAction Stop)
$Private = @(Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -File -ErrorAction Stop)

# foreach ($Import in @($Lib + $Private + $Public)) {
foreach ($Import in @($Private + $Public)) {
    try {
        . $Import.FullName
    }
    catch {
        Write-Error -Message ('Failed to import function {0}: {1}' -f ($Import.FullName), $_)
    }
}

Export-ModuleMember -Function $Public.Basename -Alias 'Convert-Size', 'Get-Ansi', 'nameof', 'dlgit', 'GetShortPath','Get-PSWinUpdate', 'ExtractRar', 'cgit', 'ReArm', 'Start-Cpl'
# Export-ModuleMember -Function * -Alias *
