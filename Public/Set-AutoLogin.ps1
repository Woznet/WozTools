function Set-AutoLogin {
  [CmdletBinding(DefaultParameterSetName = 'Enable')]
  param(
    [Parameter(ParameterSetName = 'Enable')]
    [string]$User = $env:USERNAME,
    [Parameter(Mandatory,ParameterSetName = 'Enable',
    HelpMessage='Enter Password as a String')]
    [string]$Password,
    [Parameter(ParameterSetName = 'Enable')]
    [string]$Domain = $env:USERDOMAIN,
    [Parameter(ParameterSetName = 'Disable')]
    [switch]$Disable
  )
  begin{
    $RegPath = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'
    if (-not (Test-Path -Path $RegPath)) {
      throw ('{0} - Path does not exsist' -f $RegPath)
    }
  }
  process{
    switch ($PSCmdlet.ParameterSetName){
      'Enable' {
          # autologon user domain password
          $url = 'https://live.sysinternals.com/Autologon.exe'
          $DLPath = [System.IO.Path]::Combine($env:TEMP,($url | Split-Path -Leaf))
          [System.Net.WebClient]::new().DownloadFile($url, $DLPath)

          Start-Process -FilePath $DLPath -ArgumentList ($User, $Domain, $Password) -NoNewWindow -Wait
        <#
        Set-ItemProperty -Path $RegPath -Name 'AutoAdminLogon' -Value 1 -Force -Verbose:$VerbosePreference
        Set-ItemProperty -Path $RegPath -Name 'DefaultDomainName' -Value $Domain -Force -Verbose:$VerbosePreference
        Set-ItemProperty -Path $RegPath -Name 'DefaultUserName' -Value $User -Force -Verbose:$VerbosePreference
        Set-ItemProperty -Path $RegPath -Name 'DefaultPassword' -Value $Password -Force -Verbose:$VerbosePreference
        #>
      }
      'Disable' {
        Set-ItemProperty -Path $RegPath -Name 'AutoAdminLogon' -Value 0 -Force -Verbose:$VerbosePreference
        Set-ItemProperty -Path $RegPath -Name 'DefaultPassword' -Value '' -Force -Verbose:$VerbosePreference
      }
    }
  }
}
