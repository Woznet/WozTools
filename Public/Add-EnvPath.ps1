Function Add-EnvPath{
  <#
      .SYNOPSIS
      Add Folder to Environment Variable PATH

      .DESCRIPTION
      Add Folder to Environment Variable PATH for Machine, User or Process scope
      And removes missing PATH locations

      .PARAMETER NewFolder
      Folder to add to PATH

      .PARAMETER VariableTarget
      Add NewFolder to Machine, User or Process Env Path Variable

      .INPUTS
      string - folder path

      .OUTPUTS
      List of the Path Variable after it has been changed

      .EXAMPLE
      Add-EnvPath -NewFolder 'C:\temp' -VariableTarget Machine
  #>
  [Cmdletbinding(SupportsShouldProcess)]
  param(
    [parameter(Mandatory,ValueFromPipeline,Position=0)]
    [ValidateScript({Test-Path -Path $_ -PathType Container})]
    [String[]]$NewFolder,
    [System.EnvironmentVariableTarget]$VariableTarget = [System.EnvironmentVariableTarget]::Machine
  )
  If ( ! (Test-LocalAdmin) ) { Write-Host 'Need to RUN AS ADMINISTRATOR first'; Return 1 }
  # Get the Current Search Path from the Environment keys in the Registry
  $OldPath = [System.Environment]::GetEnvironmentVariable('PATH',$VariableTarget)

  # See if the new Folder is already IN the Path
  $PathasArray = {$OldPath.Split(';')}.Invoke()

  If ($PathasArray -contains $NewFolder -or $PathAsArray -contains $NewFolder+'\') {
    Return "Folder already within `$ENV:PATH"
  }
  $remove = [System.Collections.ArrayList]::new()
  $PathasArray.ForEach({
      if (!(Test-Path -Path $_ -PathType Container )) {
        $remove.Add($_)
        Write-Host -Object ('{0} - was not found, removing form list' -f $_) -ForegroundColor Red
      }
  })
  $null = $remove.ForEach({$PathasArray.Remove($_)})
  $null = $remove
  $null = $PathasArray.Add($NewFolder)
  $NewPath = ($PathasArray | Sort-Object) -join ';'
  if ( $PSCmdlet.ShouldProcess($NewFolder) ) {
    [System.Environment]::SetEnvironmentVariable('PATH',$NewPath,$VariableTarget)
    $confirm = [System.Environment]::GetEnvironmentVariable('PATH',$VariableTarget) -split ';' | Sort-Object
    if (!(Compare-Object -ReferenceObject $($NewPath.Split(';')) -DifferenceObject $confirm -PassThru)){
      Write-Host -Object ('PATH variable successfully updated{0}{0}' -f "`n")
      Return $confirm
    }
    else {
      [System.Environment]::GetEnvironmentVariable('PATH',$VariableTarget) -split ';'
      throw 'Comparision of updated PATH var and requsted changes are different'
    }
  }
}