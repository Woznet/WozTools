function Open-NPP {
  [Alias('npp')]
  param (
    [Parameter(Position = 0)]
    [AllowNull()]
    [String[]]$Files
  )
  begin {
    $nppexe = Join-Path -Path $env:ProgramFiles -ChildPath 'Notepad++\notepad++.exe' -Resolve
    for ($x = 0; $x -lt $Files.Count; $x ++) {
      if (!(Test-Path -Path ($Files[$x]) )) {
        Write-Verbose -Message ("Unable to Find - {0} - Removing from `$Files" -f ($Files[$x]))
        $Files.Remove(($Files[$x]))
        $x--
      }
    }
  }
  process {
    if ($Files) {
      foreach($File in $Files) {
        Start-Process -FilePath $nppexe -ArgumentList $File
      }
    }
    else {
      Start-Process -FilePath $nppexe
    }
  }
}
