function Select-All {
  [Alias('Sall')]
  param(
    [Parameter(Mandatory,ValueFromPipeline)]
    [PSObject]$InputObject
  )
  process{
    $InputObject | Select-Object -Property *
  }
}
