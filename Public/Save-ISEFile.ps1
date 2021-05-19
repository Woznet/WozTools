Function Save-ISEFile {
  [CmdletBinding()]
  param(
    [ValidateScript({
          if ($_.Exists) { throw ('{1}{0} | Already Exists' -f $_.FullName,("`n")) }
          return $true
    })]
    [System.IO.FileInfo]$Path,
    [ValidateScript({
          if (-not ($psISE.CurrentPowerShellTab.Files[$_])) {
            throw '{2}Parameter must be between "{0}" - "{1}"' -f (0 - $psISE.CurrentPowerShellTab.Files.Count),($psISE.CurrentPowerShellTab.Files.Count - 1),("`n")
          }
          return $true
    })]
    [int]$i = -1,
    [switch]$ShowFile
  )
  $File = $psISE.CurrentPowerShellTab.Files[$i]
  if($ShowFile) { $File ; return }
  try {
    switch ($File.IsUntitled) {
      $true {
        if($Path) {
          if (-not (Split-Path -Path $Path -Parent | Test-Path)) {
            mkdir -Path (Split-Path -Path $Path -Parent)
          }
          $File.SaveAs($Path,[System.Text.UTF8Encoding]::new($false))
          break
        }
        else { throw ('{0}| -Path - Must be Set' -f $File.DisplayName) }
      }
      $false {
        $File.Save([System.Text.UTF8Encoding]::new($false))
        break
      }
    }
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
  }
}
