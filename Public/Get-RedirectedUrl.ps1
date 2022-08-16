
Function Test-Url {
  param(
    [Parameter(Mandatory,ValueFromPipeline)]
    [String]$Url
  )
  Process {
    if ([System.Uri]::IsWellFormedUriString($Url,[System.UriKind]::Absolute)) {
      return $true
    }
    else {
      return $false
    }
  }
}



Function Get-RedirectedUrl {
  Param(
    [Parameter(Mandatory,ValueFromPipeline)]
    [ValidateScript({
          if (-not ($_ | Test-Url)) {
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

