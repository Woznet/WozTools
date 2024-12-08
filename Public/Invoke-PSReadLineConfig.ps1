function Invoke-PSReadLineConfig {
    [CmdletBinding()]
    param()
    try {
        if (-not (Get-Module -Name PSReadLine)) {
            Import-Module PSReadline -ErrorAction Stop
        }
        $ConfigFile = Join-Path $PSScriptRoot '..\Lib\PSReadLine\PSReadLine-Config.ps1' -Resolve
        . $ConfigFile
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
        }
        throw $_
    }
}