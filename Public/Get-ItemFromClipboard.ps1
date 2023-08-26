function Get-ItemFromClipboard {
  <#
      .Synopsis
      Get file path from clipboard

      .DESCRIPTION
      Trims single and double quotes from path stored in clipboard then passes results to Get-Item
      Designed for taking the clipboard contents from Windows Explorer "Copy Path" into PowerShell.
  #>
  try {
    (Get-Clipboard).Trim('"', "'") | Where-Object { (Test-Path -Path $_ ) -eq $true } | Get-Item -ErrorAction SilentlyContinue
  }
  catch {
    [System.Management.Automation.ErrorRecord]$e = $_
    [PSCustomObject]@{
      Type      = $e.Exception.GetType().FullName
      Exception = $e.Exception.Message
      Reason    = $e.CategoryInfo.Reason
      Target    = $e.CategoryInfo.TargetName
      Script    = $e.InvocationInfo.ScriptName
      Message   = $e.InvocationInfo.PositionMessage
    }
  }
}
