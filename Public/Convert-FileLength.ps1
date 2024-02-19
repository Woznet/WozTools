function Convert-FileLength {
    <#
        .SYNOPSIS
        Converts a file length to a human readable format.

        .DESCRIPTION
        Converts a file length to a human readable format.

        .PARAMETER Length
        The file length to convert.

        .EXAMPLE
        Convert-FileLength -Length 123456789

        Converts the file length 123456789 to a human readable format.

        .EXAMPLE
        Get-ChildItem | Select-Object -ExpandProperty Length | Convert-FileLength

        Converts the file lengths of all files in the current directory to a human readable format.

        .NOTES
        Author: Woz
#>
    [CmdletBinding()]
    [Alias('Convert-Size')]
    param(
        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName,
            ValueFromPipeline
        )]
        [Alias('Size')]
        [long]$Length
    )
    begin {
        try {
            $null = [WozDev.LengthConverter]
        }
        catch {
            Write-Verbose 'Loading Type - WozDev.LengthConverter' -Verbose
            $MemberDef = @'
[DllImport("Shlwapi.dll", CharSet = CharSet.Auto)]
public static extern long StrFormatByteSize(long fileSize, System.Text.StringBuilder buffer, int bufferSize);
'@
            $null = Add-Type -Name LengthConverter -Namespace 'WozDev' -MemberDefinition $MemberDef
        }
        if (-not ($StringBuilder)) { $global:StringBuilder = [System.Text.StringBuilder]::new(1024) }
    }
    process {
        if ('WozDev.LengthConverter' -as [type]) {
            $null = [WozDev.LengthConverter]::StrFormatByteSize(
                $Length,
                $StringBuilder,
                $StringBuilder.Capacity
            )
            $StringBuilder.ToString() | Write-Output
        }
        else {
            # Add ANSI color for missing LengthConverter
            $Length | Write-Output
        }
    }
}
