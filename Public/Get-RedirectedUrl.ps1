
Function Get-RedirectedUrl {
  Param(
    [Parameter(Mandatory,ValueFromPipeline)]
    [ValidateScript({
          if (-not ([System.Uri]::IsWellFormedUriString($_,[System.UriKind]::Absolute))) {
            throw ('{0}{1} - Failed URL Validation' -f "`n",$_)
          }
          return $true
    })]
    [String]$Url
  )
  begin {
    $RUrls = [System.Collections.Generic.List[string]]::new()
  }
  process {
    $Request = [System.Net.WebRequest]::Create($Url)
    $Response = $Request.GetResponse()
    $RUrls.Add($Response.ResponseUri.ToString())
    $Response.Close()
    $Response.Dispose()
  }
  end {
    return $RUrls
  }
}

