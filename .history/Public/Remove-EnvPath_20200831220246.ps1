Function Remove-EnvPath {
  [Cmdletbinding(SupportsShouldProcess)]
  param(
    [parameter(Mandatory,ValueFromPipeline,Position=0)]
    [ValidateScript({Test-Path -Path $_ -PathType Container})]
    [String[]]$RemoveFolder,
    [System.EnvironmentVariableTarget]$VariableTarget = [System.EnvironmentVariableTarget]::Machine
  )
  If ( ! (Test-IfAdmin) ) { Write-Host 'Need to RUN AS ADMINISTRATOR first'; Return 1 }
  # Get the Current Search Path from the Environment keys in the Registry
  $NewPath = [environment]::GetEnvironmentVariable('PATH',$VariableTarget)
  # Verify item exists as an EXACT match before removing
  $Verify = $newpath.split(';') -contains $RemoveFolder
  # Find the value to remove, replace it with $NULL.  If it's not found, nothing will change
  If ($Verify) { $NewPath = $NewPath.replace($RemoveFolder,$NULL) }
  # Clean up garbage from Path
  $Newpath = $NewPath.replace(';;',';')
  # Update the Environment Path
  if ( $PSCmdlet.ShouldProcess($RemoveFolder) ) {
      [environment]::SetEnvironmentVariable('PATH',$Newpath,$VariableTarget)
    $confirm = [environment]::GetEnvironmentVariable('PATH',$VariableTarget).split(';')
    # Show our results back to the world
    Return $confirm
  }
}