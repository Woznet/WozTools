function Get-ShortPath {
  param(
    [Parameter()]
    [ValidateScript({
          if (-not ($_ | Test-Path -IsValid)) {
            throw 'Path is not valid.'
          }
          return $true
    })]
    [string]$Path = $PWD.Path
  )
  if (-not ($null -eq $Host.UI.RawUI.WindowSize.Width)) {
    $DirChar = [System.IO.Path]::DirectorySeparatorChar
    $MaxPromptPath = [int]($Host.UI.RawUI.WindowSize.Width/3);
    $CurrPath = $Path -replace '^[^:]+::';
    if ($CurrPath.Length -ge $MaxPromptPath) {
      $PathParts = $CurrPath.Split($DirChar);
      $MyPath = $PathParts[0],'...',$PathParts[$PathParts.Length - 1] -join $DirChar;
      $Counter = $PathParts.Length - 2;
      while(($MyPath.Replace('...',('...',$PathParts[$Counter] -join $DirChar)).Length -lt $MaxPromptPath) -and ($Counter -ne 0)) {
        $MyPath = $MyPath.Replace('...',('...',$PathParts[$Counter] -join $DirChar));
        $Counter--;
      }
    }
    else {
      $MyPath = $CurrPath;
    }
    return $MyPath;
  }
}