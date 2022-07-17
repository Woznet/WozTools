function Open-NotepadPlusPlus {
  <#
      .Synopsis
      Start NotepadPlusPlus and open any specified files

      .EXAMPLE
      Open-NotepadPlusPlus -Path .\Path\of\a\File.ps1

      .EXAMPLE
      Open-NotepadPlusPlus

      .INPUTS
      String

      .OUTPUTS
      none

      .NOTES
      assumes notepad++.exe is within $env:PATH
      Install with chocolatey if needed
  #>
  [Alias('npp','Open-NPP')]
  param (
    [Parameter(ValueFromPipeline)]
    [Alias('FullName')]
    [AllowNull()]
    [ValidateScript({
          if( -not ($_ | Test-Path -PathType Leaf) ) {
            throw 'File does not exist'
          }
          return $true
    })]
    [String[]]$Path
  )
  begin {
    if (-not (Get-Command -Name 'notepad++.exe')) {
      throw @'
Install notepad++
choco install notepadplusplus.install
'@
    }
    if ($Path) {
      $FileList = [System.Collections.Generic.List[string]]::new()
    }
  }
  process {
    if ($Path) {
      try {
        foreach($File in $Path){
          $FileList.Add((Resolve-Path -Path $File -ErrorAction Stop))
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
        throw $_
      }
    }
  }
  end {
    & notepad++.exe $FileList
  }
}
