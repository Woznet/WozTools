function Open-NotePadPlusPlus {
  [Alias('npp','Open-NPP')]
  [CmdletBinding()]
  param (
    [Parameter(ValueFromPipeline)]
    [AllowNull()]
    [ValidateScript({
          if( -not ($_ | Test-Path -PathType Leaf) ){
            throw 'File does not exist'
          }
          return $true
    })]
    [String[]]$Path
  )
  begin {
    $NppExe = Join-Path -Path $env:ProgramFiles,${env:ProgramFiles(x86)} -ChildPath 'Notepad++\notepad++.exe' -Resolve -ErrorAction SilentlyContinue
    if (-not ($NppExe)){ throw ('Notepad++ was not found{0}Install with Chocolatey - choco install notepadplusplus.install' -f ([System.Environment]::NewLine)) }
    if ($NppExe.Count -gt 1){
      Write-Verbose -Message ('Multiple Versions of Notepad++ found.{0}Using - {1}' -f ([System.Environment]::NewLine),($NppExe[0]))
      $NppExe = $NppExe[0]
    }
  }
  process {
    if ($Path) {
      foreach($File in $Path){
        Start-Process -FilePath $NppExe -ArgumentList ('"{0}"' -f $File)
      }
    }
    else {
      Start-Process -FilePath $NppExe
    }
  }
}
