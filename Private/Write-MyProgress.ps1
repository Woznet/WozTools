function Write-MyProgress {
  Param(
    [CmdletBinding(DefaultParameterSetName = 'Normal')]
    [Parameter(
        Mandatory,
        ParameterSetName = 'Normal'
    )]
    [Array]$Object,
    [Parameter(
        Mandatory,
        ParameterSetName = 'Normal'
    )]
    [DateTime]$StartTime,
    [Parameter(
        Mandatory,
        ParameterSetName = 'Normal'
    )]
    [Int]$Count,
    [Int]$Id = $null,
    [Int]$ParentId = -1,
    [Parameter(
        Mandatory,
        ParameterSetName = 'Cleanup'
    )]
    [switch]$Cleanup
  )
  switch ($PSCmdlet.ParameterSetName) {
    'Normal' {
      $SecondsElapsed = ([datetime]::Now - $StartTime).TotalSeconds
      $PercentComplete = ($Count / ($Object.Count)) * 100

      $Argument = @{}
      $Argument.Add('Activity', ('Processing {0} of {1}' -f $Count, $Object.Count))
      $Argument.Add('PercentComplete', $PercentComplete)
      $Argument.Add('CurrentOperation', ('{0:N2}% Complete' -f $PercentComplete))
      $Argument.Add('SecondsRemaining', ($SecondsElapsed / ($Count / $Object.Count)) - $SecondsElapsed)

      if ($Id -ne $null) { $Argument.Add('Id', $Id) }
      if ($ParentId -ne $null) { $Argument.Add('ParentId', $ParentId) }

      break
    }
    'Cleanup' {
      $Argument = @{}
      $Argument.Add('Completed', $true)
      $Argument.Add('Activity', 'Write-MyProgress Cleanup')

      break
    }
  }
  Write-Progress @Argument
}
