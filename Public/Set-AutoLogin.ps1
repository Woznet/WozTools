
# Enable autologin on computer joined to domain

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
    $regpath = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'
    if (!(Test-Path -Path $regpath)){
      throw ('{0} - Path does not exsist' -f $regpath)
    }
  }
  process{
    switch ($PSCmdlet.ParameterSetName){
      'Enable' {
        Set-ItemProperty -Path $regpath -Name 'AutoAdminLogon' -Value 1 -Force -Verbose:$VerbosePreference
        Set-ItemProperty -Path $regpath -Name 'DefaultDomainName' -Value $Domain -Force -Verbose:$VerbosePreference
        Set-ItemProperty -Path $regpath -Name 'DefaultUserName' -Value $User -Force -Verbose:$VerbosePreference
        Set-ItemProperty -Path $regpath -Name 'DefaultPassword' -Value $Password -Force -Verbose:$VerbosePreference
      }
      'Disable' {
        Set-ItemProperty -Path $regpath -Name 'AutoAdminLogon' -Value 0 -Force -Verbose:$VerbosePreference
        Set-ItemProperty -Path $regpath -Name 'DefaultPassword' -Value '' -Force -Verbose:$VerbosePreference
      }
    }
  }
}