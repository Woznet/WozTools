function Get-CommandNames {
  [CmdletBinding()]
  param(
    [Parameter(
        Mandatory,
        ParameterSetName = 'File'
    )]
    [ValidateScript({
          if(-not ($_ | Test-Path -PathType Leaf) ){
            throw 'File does not exist'
          }
          return $true
    })]
    [string]$Path,
    [Parameter(
        Mandatory,
        ParameterSetName = 'Code'
    )]
    [string]$Code,
    [Parameter(
        Mandatory,
        ParameterSetName = 'FunctionName'
    )]
    [ValidateScript({
          $script:vals = Get-Command -Name $_ -CommandType Alias,Function,Filter -ErrorAction SilentlyContinue
          if ($script:vals.CommandType -in ('Function','Filter')) {
            return $true
          }
          elseif ($script:vals.CommandType -eq 'Alias') {
            if ($script:vals.ReferencedCommand.CommandType -in ('Function','Filter')) {
              return $true
            }
            else {
              throw ('{0} - is invalid. The Alias definition must be a Function or Filter' -f $_)
            }
          }
          throw ('{0} - Invalid FunctionName' -f $_)
    })]
    [string]$FunctionName
  )
  begin {
    $Tokens = @()
  }
  process {

    switch ($PSCmdlet.ParameterSetName) {
      'File' {
        $PSPath = $ExecutionContext.SessionState.Path.GetResolvedPSPathFromPSPath($Path)
        [void][System.Management.Automation.Language.Parser]::ParseFile($PSPath.ProviderPath, [ref]$Tokens, [ref]$null)
      }
      'Code' {
        $SBCode = ($Code.Split("`n") | ForEach-Object { $_ -replace '\s*$' }) -join "`n"
        [void][System.Management.Automation.Language.Parser]::ParseInput($SBCode, [ref]$Tokens, [ref]$null)
      }
      'FunctionName' {
        $CmdInfo = Get-Command -Name $FunctionName -CommandType Alias,Function,Filter -ErrorAction Stop
        if ($CmdInfo.CommandType -eq 'Alias') {
          $CmdInfo = $CmdInfo.ReferencedCommand
        }

        [void][System.Management.Automation.Language.Parser]::ParseInput($CmdInfo.Definition, [ref]$Tokens, [ref]$null)
      }
      default {
        throw 'something went wrong.'
      }
    }

    $CommandTokens = $Tokens | Where-Object {$_.TokenFlags -band 'CommandName'}
    $CalledCommandNames = $CommandTokens.Text | Sort-Object -Unique

  }
  end {
    return $CalledCommandNames

  }
}

