function Invoke-InDirectory {
  <#
      .SYNOPSIS
      Invoke a scriptblock from within one or more directories

      .DESCRIPTION
      A longer description.

      .PARAMETER Path
      Path of one or more directories which the scriptblock will be invoked in

      .PARAMETER ScriptBlock
      Specifies the commands to run

      .INPUTS
      System.IO.DirectoryInfo
      System.String

      You can pipe the output from Get-Item,
      DirectoryInfo object,
      A string that contains a path

      .OUTPUTS
      This function will output whatever is returned from the scriptblock each time it is run.

      .EXAMPLE
      Invoke-InDirectory -Path 'X:\git\WozTools' -ScriptBlock { git fetch --all }

      .EXAMPLE
      Get-ChildItem -Path 'X:\git\' -Directory  | Invoke-InDirectory  -ScriptBlock { git fetch --all }

      .EXAMPLE
      'X:\git\WozTools','.\Git Stuff'  | Invoke-InDirectory  -ScriptBlock { git fetch --all }

      .NOTES
      Original Source:
      https://gist.github.com/chriskuech/a32f86ad2609719598b073293d09ca03#file-tryfinally-2-ps1
  #>
  Param(
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ValueFromPipeline)]
    [ValidateScript({
          if(-not (Test-Path -Path $_ -PathType Container)) {
            throw 'Folder does not exist'
          }
          return $true
    })]
    [Alias('FullName')]
    # Path of one or more directories which the scriptblock will be invoked in
    [String[]]$Path,
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    # Specifies the commands to run
    [scriptblock]$ScriptBlock
  )
  process {
    foreach($Loc in $Path) {
      try {
        Push-Location -Path $Loc
        . $ScriptBlock
      }
      finally {
        Pop-Location
      }
    }
  }
}
