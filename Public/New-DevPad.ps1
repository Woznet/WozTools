function New-DevPad {
  [Cmdletbinding()]
  param(
    [Parameter(Position = 0)]
    [ValidateScript({
          if (-not (Test-Path -Path $_ -PathType Container -IsValid)) {
            throw 'Folder path is not valid.'
          }
          return $true
    })]
    # DevPad folder path
    [String]$Path = 'D:\_dev\DPad',
    # Do not set the DevPad env variable
    [switch]$NoEnvVariable
  )
  $DevPad = [System.IO.Path]::Combine($Path, [datetime]::Now.Year, [datetime]::Now.ToString('MM.dd'))
  Write-Verbose -Message ('Creating DevPad folder if it does not exist and set the current working location - {0}' -f $Path)
  New-Item -ItemType Directory -Force -Path $DevPad | Set-Location
  if ( -not ($NoEnvVariable)) {
    $IsAdmin = Test-IfAdmin
    if ($IsAdmin) {
      $RegHive = [Microsoft.Win32.RegistryKey]::OpenBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine, [Microsoft.Win32.RegistryView]::Registry64)
      $RegKey = $RegHive.OpenSubKey('System\CurrentControlSet\Control\Session Manager\Environment', $true)
      $RegKey.SetValue('DevPad', $DevPad)
      if ($RegKey.GetValue('DevPad') -eq $DevPad) {
        Write-Verbose -Message 'env:DevPad already set'
      }
      else {
        Write-Verbose -Message ('Set env:DevPad - {0}' -f $Path)
        $RegKey.SetValue('DevPad', $DevPad)
      }
    }
  }
}
