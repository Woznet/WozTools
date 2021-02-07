function Open-NotePadPlusPlus {
  [Alias('npp','Open-NPP')]
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
    $NppExe = if (Get-Command -Name 'notepad++.exe') { 'notepad++.exe' }
    elseif ($NPProg = Join-Path -Path $env:ProgramFiles -ChildPath 'Notepad++\notepad++.exe' -Resolve -ErrorAction SilentlyContinue) {
      $NPProg
    }
    else {
      throw 'Notepad++ was not found'
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
