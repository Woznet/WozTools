Function Remove-EnvPath {
  [CmdletBinding()]
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
    if ( -not (Test-IfAdmin) ) { throw 'RUN AS ADMINISTRATOR' }
    $OldPath = [System.Environment]::GetEnvironmentVariable('PATH',$VariableTarget).Split(';').TrimEnd('\') | Sort-Object -Unique | Convert-Path -ErrorAction SilentlyContinue
    $NewPath = [System.Collections.ArrayList]::new()
    $NewPath.AddRange($OldPath)
  }
  process {
    foreach($RDir in $Path) {
      $RDir = (Convert-Path -Path $RDir -ErrorAction SilentlyContinue).TrimEnd('\')
      if ($NewPath -contains $RDir) { $NewPath.Remove($RDir) }
    }
  }
  end {
    [System.Environment]::SetEnvironmentVariable('PATH',($NewPath -join ';'),$VariableTarget)
    $Confirm = [System.Environment]::GetEnvironmentVariable('PATH',$VariableTarget).Split(';')
    return $Confirm
  }
}
