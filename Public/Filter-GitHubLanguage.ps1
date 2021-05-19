Function Filter-GitHubLanguage {
  [CmdletBinding()]
  [Alias('FLang')]
  param(
    [Parameter(Mandatory,ValueFromPipeline)]
    $InputObject,
    [string[]]$Languages = ('PowerShell','C#')
  )
  process{
    $InputObject | Where-Object {$_.language -match ($Languages -join '|')}
  }
}

