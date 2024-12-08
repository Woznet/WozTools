function Get-UserAgent {
    [CmdletBinding()]
    param()
    process {
        try {
            # Accessing the non-public static member 'UserAgent' from PSUserAgent class
            $BindingFlags = [System.Reflection.BindingFlags]::NonPublic -bor [System.Reflection.BindingFlags]::Static
            $UserAgent = [Microsoft.PowerShell.Commands.PSUserAgent].GetProperty('UserAgent', $BindingFlags).GetValue($null, $null)
            $UserAgent
        }
        catch {
            # Log and rethrow the caught exception with more contextual information
            $e = [System.Management.Automation.ErrorRecord]$_
            [pscustomobject]@{
                Type      = $e.Exception.GetType().FullName
                Exception = $e.Exception.Message
                Reason    = $e.CategoryInfo.Reason
                Target    = $e.CategoryInfo.TargetName
                Script    = $e.InvocationInfo.ScriptName
                Message   = $e.InvocationInfo.PositionMessage
            } | Out-String | Write-Error
            throw $_
        }
    }
}