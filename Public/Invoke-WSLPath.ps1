function Invoke-WSLPath {
  <#
      .Synopsis
      Covert a path inbetween the Windows and the WSL format

      .DESCRIPTION
      Use "wslpath" to convert the path

      .EXAMPLE
      # Convert Windows Path to WSL - /mnt/c/temp/
      Invoke-WSLPath -Path 'C:\temp\'

      .EXAMPLE
      # Convert WSL Path to Windows - \\wsl$\Ubuntu-18.04\usr\bin\ssh
      Invoke-WSLPath -Path '/usr/bin/ssh' -ToWindows
  #>
  [CmdletBinding(DefaultParameterSetName='WSL')]
  [Alias('wslpath')]
  [OutputType()]
  Param(
    # Path to be converted
    [Parameter(
        Mandatory,
        ValueFromPipeline
    )]
    [ValidateScript({
          if(-not ($_ | Test-Path -IsValid) ){
            throw 'Path is not valid'
          }
          return $true
    })]
    [string[]]$Path,
    # Convert Path to Windows format
    [Parameter(ParameterSetName='Win')]
    [switch]$ToWindows,
    # Convert Path to WSL format - Default
    [Parameter(ParameterSetName='WSL')]
    [switch]$ToWSL
  )
  Begin {
    if (-not (Get-Command -Name wsl.exe -ErrorAction SilentlyContinue)) {throw 'Cannot locate WSL'}
    $ArgList = [System.Collections.ArrayList]@()
    $Results = [System.Collections.Generic.List[string]]@()
    $ConvertTo = switch ($PSCmdlet.ParameterSetName) {
      'WSL' { '-u' ; break }
      'Win' { '-w' ; break }
      default { throw 'something went wrong' }
    }
  }
  Process {
    foreach ($Item in $Path) {
      $ArgList.AddRange((
          'wslpath', '-a',
          $ConvertTo, ([regex]::Escape($Item))
      ))
      $CPath = & wsl $ArgList 2>$null
      $Results.Add($CPath)
      $ArgList.Clear()
    }
  }
  End {
    return $Results
  }
}
