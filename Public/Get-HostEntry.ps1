
filter Get-HostEntry {
  [CmdletBinding(PositionalBinding=$true)]
  [OutputType([System.Net.IPHostEntry])]
  param(
    [Parameter(ValueFromPipeline)]
    [ValidateScript({
          if ($_ -as [uri]) {
            return $true
          }
          elseif($_ -as [ipaddress]) {
            return $true
          }
          else {
            throw 'Must be an ipaddress ([address]) or hostname ([uri])'
          }
    })]
    [string[]]$Address
  )
  begin {
    if (-not ($PSBoundParameters.ContainsKey('ErrorAction'))){
      Write-Verbose -Message ' ----- Setting ErrorActionPreference to SilentlyContinue ----- '
      $script:ErrorActionPreference = 'SilentlyContinue'
    }
    $R = [System.Collections.Generic.List[System.Net.IPHostEntry]]@()
  }
  process {
    foreach ($A in $Address) {
      $HE = [System.Net.Dns]::GetHostEntry($A)
      $R.Add($HE)
      $HE = $null
    }
  }
  end {
    return $R
  }
}









