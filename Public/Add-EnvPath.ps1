Function Add-EnvPath {
  <#
      .SYNOPSIS
      Add a Folder to Environment Variable PATH

      .DESCRIPTION
      Add Path to Environment Variable PATH for Machine, User or Process scope
      And removes missing PATH locations

      .PARAMETER Path
      Folder to add to PATH

      .PARAMETER VariableTarget
      Which Env Path the directory gets added to.
      Machine, User or Process

      .INPUTS
      String - Folder Path

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
          if (-not ([System.IO.Path]::IsPathRooted($_))) {
            throw 'Path must be Rooted'
          }
          return $true
    })]
    [String[]]$Path,
    [System.EnvironmentVariableTarget]$VariableTarget = [System.EnvironmentVariableTarget]::Machine
  )
  begin {
    if (-not (Test-IfAdmin)) { throw 'RUN AS ADMINISTRATOR' }
    $OldPath = [System.Environment]::GetEnvironmentVariable('PATH',$VariableTarget).Split(';').TrimEnd('\') | Sort-Object -Unique | Convert-Path -ErrorAction SilentlyContinue
    $NewPath = [System.Collections.ArrayList]::new()
    $NewPath.AddRange($OldPath)
  }
  process{
    foreach ($NDir in $Path) {
      $NDir = (Convert-Path -Path $NDir -ErrorAction SilentlyContinue).TrimEnd('\')
      $null = if ($NewPath -notcontains $NDir) { $NewPath.Add($NDir) }
    }
  }
  end {
    [System.Environment]::SetEnvironmentVariable('PATH',($NewPath -join ';'),$VariableTarget)
    $Confirm = [System.Environment]::GetEnvironmentVariable('PATH',$VariableTarget).Split(';')
    return $Confirm
  }
}