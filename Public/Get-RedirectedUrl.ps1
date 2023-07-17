Function Get-RedirectedUrl {
  Param(
    [Parameter(Mandatory,ValueFromPipeline)]
    [ValidateScript({
          if (-not ([uri]::IsWellFormedUriString($_,[System.UriKind]::Absolute))) {
            throw ('{0}{1} - Failed URL Validation' -f "`n",$_)
          }
          return $true
    })]
    [String]$Url
  )
  begin {

    Add-Type -AssemblyName System.Net.Http -ErrorAction Stop
    $HttpClient = [System.Net.Http.HttpClient]::new()
  }
  process {

    try{

      $HttpRequestMessage = [System.Net.Http.HttpRequestMessage]::new([System.Net.Http.HttpMethod]::Head, $Url)
      $ClientResult = $HttpClient.SendAsync($HttpRequestMessage).GetAwaiter().GetResult().EnsureSuccessStatusCode()

      $ClientResult.RequestMessage.RequestUri.AbsoluteUri
    }
    catch {
      [System.Management.Automation.ErrorRecord]$e = $_
      [PSCustomObject]@{
        Type      = $e.Exception.GetType().FullName
        Exception = $e.Exception.Message
        Reason    = $e.CategoryInfo.Reason
        Target    = $e.CategoryInfo.TargetName
        Script    = $e.InvocationInfo.ScriptName
        Message   = $e.InvocationInfo.PositionMessage
      }
      throw $e
    }
  }
  end {
    $HttpClient.Dispose()
    $HttpRequestMessage.Dispose()
    $ClientResult.Dispose()
    [gc]::Collect()

  }
}

