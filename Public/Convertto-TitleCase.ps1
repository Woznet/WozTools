function ConvertTo-TitleCase {
  <#
      .Synopsis
      Convert Text to TitleCase
      .EXAMPLE
      ConvertTo-TitleCase -Text 'testing'
      .EXAMPLE
      Get-ChildItem -Path D:\temp | Select-Object -ExpandProperty Name | ConvertTo-TitleCase
      .INPUTS
      System.String
      .OUTPUTS
      System.String
  #>
  [OutputType([String])]
  Param (
    [Parameter(
        Mandatory,
        ValueFromPipeline
    )]
    [String[]]$Text
  )
  Process {
    foreach($Line in $Text){
      [CultureInfo]::CurrentCulture.TextInfo.ToTitleCase($Line)
    }
  }
}