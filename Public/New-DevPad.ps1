function New-DevPad {
  [Cmdletbinding()]
  param(
    [Parameter(Position = 0)]
    [ValidateScript({
          if(-not (Test-Path -Path $_ -PathType Container -IsValid)){
            throw 'Folder path is not valid.'
          }
          return $true
    })]
    # DevPad folder path
    [String]$Path = 'D:\_dev\DPad',
    # Do not set the DevPad env variable
    [switch]$NoEnvVariable
  )
  $DevPad = [System.IO.Path]::Combine($Path,[datetime]::Now.Year,[datetime]::Now.ToString('MM.dd'))

  Write-Verbose -Message ('Creating DevPad folder if it does not exist and set the current working location - {0}' -f $Path)
  New-Item -ItemType Directory -Force -Path $DevPad | Set-Location

  if (-not ($NoEnvVariable)) {

    $EVDevPad = [environment]::GetEnvironmentVariable('DevPad',[EnvironmentVariableTarget]::Machine)
		if ($EVDevPad -ne $DevPad) {
			Write-Verbose -Message ('Settings env variable DevPad to - {0}' -f $Path)
			[environment]::SetEnvironmentVariable('DevPad',$DevPad,[EnvironmentVariableTarget]::Machine)
		}
		else {
		  Write-Verbose -Message 'Skipping SetEnvironmentVariable'
		}
  }
}