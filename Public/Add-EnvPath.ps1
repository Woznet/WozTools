Function Add-EnvPath {
  <#
      .SYNOPSIS
      Add a Folder to Environment Variable PATH

      .DESCRIPTION
      Add Folders to Environment Variable PATH for Machine, User or Process scope
      And removes missing PATH locations

      .PARAMETER Path
      Folder or Folders to add to PATH

      .PARAMETER VariableTarget
      Which Env Path the directory gets added to.
      Machine, User or Process

      .PARAMETER PassThru
      Display updated PATH variable

      .INPUTS
      [String] - Folder Path, accepts multiple folders

      .OUTPUTS
      String - List of the New Path Variable

      .EXAMPLE
      Add-EnvPath -Path 'C:\temp' -VariableTarget Machine
  #>
  param(
    [Parameter(Mandatory,ValueFromPipeline)]
    [ValidateScript({
          if (-not (Test-Path -Path $_ -PathType Container)) {
            throw 'Path must be a Folder'
          }
          return $true
    })]
    [String[]]$Path,
    [System.EnvironmentVariableTarget]$VariableTarget = [System.EnvironmentVariableTarget]::Machine,
    [switch]$PassThru
  )
  begin {
    if (-not (Test-IfAdmin)) { throw 'RUN AS ADMINISTRATOR' }
    $OldPath = [System.Environment]::GetEnvironmentVariable('PATH',$VariableTarget).Split(';').TrimEnd('\') | Convert-Path -ErrorAction SilentlyContinue
    $NewPath = [System.Collections.ArrayList]::new()
    $NewPath.AddRange($OldPath)
  }
  process{
    foreach($NDir in $Path) {
      $NDir = (Convert-Path -Path $NDir -ErrorAction SilentlyContinue).TrimEnd('\')
      if ($NewPath -notcontains $NDir) { $null = $NewPath.Add($NDir) }
      else {
        Write-Warning -Message ('SKIPPING:{0} - duplicates not included' -f $NDir)
      }
    }
  }
  end {
    [System.Environment]::SetEnvironmentVariable('PATH',(($NewPath | Sort-Object -Unique) -join ';'),$VariableTarget)
    if ($PassThru) {
      $Confirm = [System.Environment]::GetEnvironmentVariable('PATH',$VariableTarget).Split(';')
      return $Confirm
    }
  }
}
