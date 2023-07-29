function Invoke-7zExtract {
  [CmdletBinding()]
  [Alias('ExtractRar')]
  param(
    [Parameter(
      Mandatory,
      ValueFromPipelineByPropertyName,
      ValueFromPipeLine
    )]
    [Alias('FullName')]
    [string[]]$Path,
    [ValidateScript({
        if (-not (Test-Path $_ -PathType Container -IsValid)) {
          throw ('Invalid directory path - {0}' -f $_)
        }
        return $true
      })]
    [string]$Out = $PWD.ProviderPath,
    [switch]$SeperateDirs
  )
  begin {
    if (-not (Get-Command -Name 7z -ErrorAction Ignore)) { throw 'Unable to locate 7z.' }
    if (-not (Test-Path $Out -PathType Container)) {
      try {
        $null = New-Item -Path $Out -ItemType Directory -Force -ErrorAction Stop
      }
      catch {
        throw $_
      }
    }
  }
  process {
    foreach ($RarFile in $Path) {
      $OutDir = Join-Path $Out -ChildPath (. { if ($SeperateDirs) { $RarFile | Split-Path -LeafBase } })
      Write-Verbose ('{2}Archive - {0}{2}OutDir - {1}' -f $RarFile, $OutDir, [System.Environment]::NewLine)
      Write-Verbose ('& 7z x {0} -o"{1}"' -f $RarFile, $OutDir)
      & 7z x $RarFile -o"$OutDir"
    }
  }
}
