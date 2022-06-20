function Get-ItemFromClipboard {
  <#
      .Synopsis
      Get file path from clipboard

      .DESCRIPTION
      Trims single and double quotes from path stored in clipboard then passes results to Get-Item
      
      for use primarily with Windows Explorer "Copy Path"
      Get-ItemFromClipboard trims single and double quotes from around path and then pipes result into Get-Item
  #>
  try {
    (Get-Clipboard).Trim('"',"'") | Get-Item -ErrorAction Stop
  }
  catch {
    [System.Management.Automation.ErrorRecord]$e = $_
    [PSCustomObject]@{
      Type      = $e.Exception.GetType().FullName
      Exception = $e.Exception.Message
      Reason    = $e.CategoryInfo.Reason
      Target    = $e.CategoryInfo.TargetName
      Script    = $e.InvocationInfo.ScriptName
      Line      = $e.InvocationInfo.ScriptLineNumber
      Column    = $e.InvocationInfo.OffsetInLine
    }
    # throw $_
  }
}
