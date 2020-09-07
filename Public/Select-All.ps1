function Select-All{
  [Alias('Sall')]
  param(
    [Parameter(Mandatory,ValueFromPipeline)]
    [Object]$Object
  )
  process{
    $Object | Select-Object -Property *
  }
}
