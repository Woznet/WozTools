function Format-CatchError {
  param(
    [Parameter(ValueFromPipeline)]
    [System.Management.Automation.ErrorRecord]$e = $_,
    [switch]$Throw
  )
  [PSCustomObject]@{
    Type      = $e.Exception.GetType().FullName
    Exception = $e.Exception.Message
    Reason    = $e.CategoryInfo.Reason
    Target    = $e.CategoryInfo.TargetName
    Script    = $e.InvocationInfo.ScriptName
    Message   = $e.InvocationInfo.PositionMessage
  }
  if ($Throw.IsPresent){
    throw $e
  }
}
