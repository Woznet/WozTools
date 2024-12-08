unction Open-NotepadPlusPlus {
    [CmdletBinding()]
    [Alias()]
    param(
        [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline)]
        [Alias('FullName')]
        [ValidateScript({
                if ( -not ($_ | Test-Path -PathType Leaf) ) {
                    throw 'File does not exist'
                }
                return $true
            })]
        [String[]]$Path
    )
    begin {
        if (-not (Get-Command -Name 'notepad++.exe' -ErrorAction Ignore)) {
            throw 'Install notepad++'
        }
    }
    process {
        try {
            foreach ($File in ($ExecutionContext.SessionState.Path.GetResolvedPSPathFromPSPath($Path))) {
                & notepad++.exe "$File"
            }
        }
        catch {
            [System.Management.Automation.ErrorRecord]$e = $_
            [PSCustomObject]@{
                Type = $e.Exception.GetType().FullName
                Exception = $e.Exception.Message
                Reason = $e.CategoryInfo.Reason
                Target = $e.CategoryInfo.TargetName
                Script = $e.InvocationInfo.ScriptName
                Message = $e.InvocationInfo.PositionMessage
            } | Out-String | Write-Error
            Write-Error -ErrorRecord $_
        }
    }
}
