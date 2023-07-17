function Join-Url {
  <#
      .SYNOPSIS
      Combines a base uri and a child uri into a single uri.

      .DESCRIPTION
      `Join-Url` combines a base uri and a child uri into a single uri.

      .PARAMETER Base
      Specify the Base Uri which the Child-Uri is appended to.

      .PARAMETER Child
      Specify the Uri that is appended to the value of the `Base` parameter.
      Machine, User or Process

      .PARAMETER OutUri
      Output is returned as an Uri object instead of a string.

      .INPUTS
      [Uri] - Base url

      .OUTPUTS
      String - Default
      Uri - when the OutUri parameter is used.

      .EXAMPLE
      Join-Url -Base 'https://graph.microsoft.com/v1.0/' -Child 'groups'
  #>
  [CmdletBinding()]
  param(
    [Parameter(Mandatory,ValueFromPipeline,Position=0)]
    [uri]$Base,
    [Parameter(Mandatory,Position=1)]
    [string]$Child,
    [switch]$OutUri
  )
  process {
    if (-not ($Base.ToString().EndsWith('/'))) {
      [uri]$Base = '{0}/' -f $Base.ToString()
    }
    $Uri = [uri]::new($Base,$Child.TrimStart('/'))
    if ($OutUri) {
      return $Uri
    }
    else {
      return $Uri.ToString()
    }
  }
}
