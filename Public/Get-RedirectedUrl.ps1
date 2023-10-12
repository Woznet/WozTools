Function Get-RedirectedUrl {
  <#
      .SYNOPSIS
      Get the redirected url from the Uri entered in the Uri parameter

      .DESCRIPTION
      Uses HttpClient and the Head method to reterieve the RequestMessage.RequestUri.AbsoluteUri from the submitted Uri

      .PARAMETER Uri
      The url that is to be checked for a redirected url

      .INPUTS
      [string] - Url, accepts multiple Urls

      .OUTPUTS
      [string] - returns the redirected url

      .EXAMPLE
      Get-RedirectedUrl https://aka.ms/ad/list

      https://github.com/microsoft/aka#readme

      .EXAMPLE
      'https://aka.ms/admin',
      'https://aka.ms/azad',
      'https://aka.ms/intune',
      'https://aka.ms/in',
      'https://aka.ms/entratemplates' | Get-RedirectedUrl

      https://admin.microsoft.com/
      https://portal.azure.com/Error/UE_404?aspxerrorpath=/#view/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/~/Overview
      https://intune.microsoft.com/Error/UE_404?aspxerrorpath=/
      https://intune.microsoft.com/Error/UE_404?aspxerrorpath=/
      https://www.microsoft.com/en-us/download/details.aspx?id=57600
  #>
  Param(
    [Parameter(Mandatory,ValueFromPipeline,Position = 0)]
    [ValidateScript({
          if (-not ([uri]::IsWellFormedUriString($_,[System.UriKind]::Absolute))) {
            throw ('{0}{1} - An invalid request URI was provided. Either the request URI must be an absolute URI or BaseAddress must be set.' -f "`n",$_)
          }
          return $true
    })]
    # Uri to get the redirected uri
    [string]$Uri
  )
  begin {
    Add-Type -AssemblyName System.Net.Http -ErrorAction Stop
    $HttpClient = [System.Net.Http.HttpClient]::new()

    $Awaiter = @()
  }
  process {
    
    $HttpRequestMessage = [System.Net.Http.HttpRequestMessage]::new([System.Net.Http.HttpMethod]::Head, $Uri)
    $Awaiter += $HttpClient.SendAsync($HttpRequestMessage).GetAwaiter()

  }
  end {
    try{
      $ClientResultAll = $Awaiter.GetResult()
      $AbsoluteUri = $ClientResultAll.RequestMessage.RequestUri.AbsoluteUri

      $HttpClient.Dispose()
      $HttpRequestMessage.Dispose()
      $ClientResultAll.Dispose()
      [gc]::Collect()

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
      throw $_
    }

    return $AbsoluteUri
  }
}
