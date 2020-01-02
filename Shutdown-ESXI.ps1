function Shutdown-ESXI {
  [CmdletBinding(DefaultParameterSetName='Shutdown')]
  param(
    [Parameter(Mandatory)]
    [string]$VMHost,
    [Parameter(ParameterSetName='Restart')]
    [switch]$Restart
  )
  Write-Verbose -Message "Shutting Down VM's"
  Get-VM -Server $VMHost | Where-Object {$_.PowerState -eq "PoweredOn"} | Stop-VM -Confirm -Verbose
  Write-Verbose -Message "Setting Connection State - Maintenance"
  Set-VMHost -VMHost $VMHost -State Maintenance -Verbose

  switch ($psCmdlet.ParameterSetName ) {
    default {
      Write-Verbose -Message "Shutting Down ESXi Host"
      Stop-VMHost -VMHost $VMHost -Verbose
    }
    'Shutdown' {
      Write-Verbose -Message "Shutting Down ESXi Host"
      Stop-VMHost -VMHost $VMHost -Verbose
    }
    'Restart' {
      Write-Verbose -Message "Restarting ESXi Host"
      Restart-VMHost -VMHost $VMHost -Verbose
      Start-Sleep -Seconds 60
      Write-Verbose -Message "Attempting to Reconnect"
      while (-not( Connect-VIServer -Server $VMHost )) {
        Start-Sleep -Seconds 45
      }
      Write-Verbose -Message "Setting Connection State - Connected"
      Set-VMHost -VMHost $VMHost -State	Connected -Verbose
    }
  }
}