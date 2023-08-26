function Convert-WSLPath {
  <#
      .Synopsis
      Covert a path in between the Windows and the WSL path formats

      .DESCRIPTION
      Use "wslpath" to convert the path

      .EXAMPLE
      # Convert Windows Path to WSL
      Convert-WSLPath -Path 'C:\temp\'

      .EXAMPLE
      # Convert WSL Path to Windows
      Convert-WSLPath -Path '/usr/bin/ssh' -ToWindows
  #>
  [CmdletBinding(DefaultParameterSetName = 'WSL')]
  [Alias('wslpath')]
  [OutputType()]
  Param(
    # Path to be converted
    [Parameter(
      Mandatory,
      ValueFromPipeline
    )]
    [ValidateScript({
        if (-not ($_ | Test-Path -IsValid) ) {
          throw 'Path is not valid'
        }
        return $true
      })]
    [string[]]$Path,
    # Convert Path from WSL format to Windows format
    [Parameter(ParameterSetName = 'Win')]
    [switch]$ToWindows,
    # Convert Path from Windows format to WSL format - Default
    [Parameter(ParameterSetName = 'WSL')]
    [switch]$ToWSL
  )
  Begin {
    if (-not (Get-Command -Name wsl.exe -ErrorAction SilentlyContinue)) {
      throw 'Cannot locate WSL'
    }
    
    $ConvertTo = switch ($PSCmdlet.ParameterSetName) {
      'WSL' { '-u' ; break }
      'Win' { '-w' ; break }
    }
  }
  Process {
    foreach ($Item in $Path) {
      $ArgString = 'wslpath', '-a', $ConvertTo, ([regex]::Escape($Item))
      (& wsl.exe --exec $ArgString) -replace ([char][int]61532)
    }
  }
}
