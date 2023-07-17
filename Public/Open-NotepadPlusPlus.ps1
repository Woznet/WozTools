function Open-NotepadPlusPlus {
  <#
      .Synopsis
      Open file in NotepadPlusPlus

      .EXAMPLE
      Open-NotepadPlusPlus -Path .\Path\of\a\File.ps1

      .EXAMPLE
      ### BAD EXAMPLE - funciton is stupid and will open all resolved paths
      gci .\* | Open-NotepadPlusPlus

      .INPUTS
      FileInfo, String

      .OUTPUTS
      none

      .NOTES
      assumes notepad++.exe is within $env:PATH
      Install with chocolatey if needed
  #>
  [Alias('npp','Open-NPP')]
  param(
    [Parameter(ValueFromPipelineByPropertyName,ValueFromPipeline)]
    [Alias('FullName')]
    [ValidateScript({
          if( -not ($_ | Test-Path -PathType Leaf) ) {
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
    if ($Path) {
      try {
        foreach($File in ($ExecutionContext.SessionState.Path.GetResolvedPSPathFromPSPath($Path))){
          & notepad++.exe $File
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
          Message   = $e.InvocationInfo.PositionMessage
        }
        Write-Warning $_
      }
    }
  }
}
