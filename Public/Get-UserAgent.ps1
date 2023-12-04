function Get-UserAgent {
    [CmdletBinding()]
    param()

    process {
        try {

            # Accessing the non-public static member 'UserAgent' from PSUserAgent class
            [Microsoft.PowerShell.Commands.PSUserAgent].GetMembers('Static, NonPublic').Where{ $_.Name -eq 'UserAgent' }.GetValue($null, $null)
        }
        catch {
            Write-CustomError -ErrorRecord $_
            throw $_
        }
    }
}
