Function Remove-EnvPath {
  [Cmdletbinding(SupportsShouldProcess)]
  param(
    [parameter(Mandatory,ValueFromPipeline,Position=0)]
    [String[]]$RemovedFolder,
    [System.EnvironmentVariableTarget]$VariableTarget = [System.EnvironmentVariableTarget]::Machine
  )
  If ( ! (TEST-LocalAdmin) ) { Write-Host 'Need to RUN AS ADMINISTRATOR first'; Return 1 }
  # Get the Current Search Path from the Environment keys in the Registry
  $NewPath=  [environment]::GetEnvironmentVariable('PATH',$VariableTarget)
  # Verify item exists as an EXACT match before removing
  $Verify = $newpath.split(';') -contains $RemovedFolder
  # Find the value to remove, replace it with $NULL.  If it's not found, nothing will change
  If ($Verify) { $NewPath = $NewPath.replace($RemovedFolder,$NULL) }
  # Clean up garbage from Path
  $Newpath=$NewPath.replace(';;',';')
  # Update the Environment Path
  if ( $PSCmdlet.ShouldProcess($RemovedFolder) ) {
      [environment]::SetEnvironmentVariable('PATH',$Newpath,$VariableTarget)
    $confirm = [environment]::GetEnvironmentVariable('PATH',$VariableTarget).split(';')
    # Show our results back to the world
    Return $confirm
  }
}