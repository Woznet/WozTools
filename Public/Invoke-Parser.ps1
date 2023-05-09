function Invoke-Parser {
  <#
  .SYNOPSIS
  Get the Commands and Variables used in a script (ps1,psm1,etc), code/scriptblock or, function definition.


  .EXAMPLE
  Invoke-Parser -Path C:\temp\random-script.ps1

  #>
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

    $Tokens = [System.Collections.ObjectModel.Collection[System.Management.Automation.Language.Token]]::new()
    $ParseErrors = [System.Collections.ObjectModel.Collection[System.Management.Automation.Language.ParseError]]::new()

  }
  process {

    switch ($PSCmdlet.ParameterSetName) {
      'File' {
        $PSPath = $ExecutionContext.SessionState.Path.GetResolvedPSPathFromPSPath($Path)
        $Parser = [System.Management.Automation.Language.Parser]::ParseFile($PSPath.ProviderPath, [ref]$Tokens, [ref]$ParseErrors)
      }
      'Code' {
        $SBCode = ($Code.Split("`n") | ForEach-Object { $_ -replace '\s*$' }) -join "`n"
        $Parser = [System.Management.Automation.Language.Parser]::ParseInput($SBCode, [ref]$Tokens, [ref]$ParseErrors)
      }
      'FunctionName' {
        $CmdInfo = Get-Command -Name $FunctionName -CommandType Alias,Function,Filter -ErrorAction Stop
        if ($CmdInfo.CommandType -eq 'Alias') {
          $CmdInfo = $CmdInfo.ReferencedCommand
        }

        $Parser = [System.Management.Automation.Language.Parser]::ParseInput($CmdInfo.Definition, [ref]$Tokens, [ref]$ParseErrors)
      }
      default {
        throw 'something went wrong.'
      }
    }

    $CommandTokenKind = $Tokens | Where-Object {$_.Kind -eq 'Variable'}
    $CommandTokenFlags = $Tokens | Where-Object {$_.TokenFlags -band 'CommandName'}

    $FoundVariable = $Tokens | Where-Object {$_.Kind -eq 'Variable'} | ForEach-Object Text | Sort-Object -Unique
    $FoundCommandName = $Tokens | Where-Object {$_.TokenFlags -band 'CommandName'} | ForEach-Object Text | Sort-Object -Unique

    $OutObj = [pscustomobject]@{
      Commands = $FoundCommandName
      Variables = $FoundVariable
    }
  }
  end {
    return $OutObj
  }
}
