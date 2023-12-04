using namespace System.Management.Automation.Language
using namespace System.Collections.ObjectModel

function Invoke-Parser {
    <#
    .SYNOPSIS
    Parses a PowerShell script, scriptblock, or function definition to extract used commands and variables.

    .DESCRIPTION
    The Invoke-Parser function analyzes PowerShell code from a file, a code snippet, or a function definition. It extracts and lists all the commands and variables used in the input. It supports three modes of input: File, Code, and FunctionName.

    .PARAMETER Path
    Specifies the path to a PowerShell script file. The function parses the file and extracts commands and variables used in it.

    .PARAMETER Code
    Specifies a string containing a block of PowerShell code. The function parses the code to extract commands and variables.

    .PARAMETER FunctionName
    Specifies the name of a PowerShell function. The function parses the function definition to extract commands and variables.

    .EXAMPLE
    Invoke-Parser -Path 'C:\temp\random-script.ps1'
    Parses the PowerShell script at the specified path and returns the commands and variables used in the script.

    .EXAMPLE
    Invoke-Parser -Code '$a = 1; Write-Output $a'
    Parses the provided code snippet and returns the commands and variables used in it.

    .EXAMPLE
    Invoke-Parser -FunctionName 'Get-Process'
    Parses the definition of the 'Get-Process' function and returns the commands and variables used in it.

    .INPUTS
    String

    .OUTPUTS
    PSCustomObject
    #>
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory,
            ParameterSetName = 'File'
        )]
        [ValidateScript({
            if (-not ($_ | Test-Path -PathType Leaf)) {
                throw 'File does not exist'
            }
            return $true
        })]
        # Specifies the path to a PowerShell script file. The function parses the file and extracts commands and variables used in it.
        [string]$Path,

        [Parameter(
            Mandatory,
            ParameterSetName = 'Code'
        )]
        # Specifies a string containing a block of PowerShell code. The function parses the code to extract commands and variables.
        [string]$Code,

        [Parameter(
            Mandatory,
            ParameterSetName = 'FunctionName'
        )]
        [ValidateScript({
            $Cmd = Get-Command -Name $_ -CommandType Alias,Function,Filter -ErrorAction SilentlyContinue
            if ($Cmd -and $Cmd.CommandType -in ('Function','Filter', 'Alias')) {
                return $true
            }
            throw ('{0} is not a valid Function, Filter, or Alias name.' -f $_)
        })]
        # Specifies the name of a PowerShell function. The function parses the function definition to extract commands and variables.
        [string]$FunctionName
    )
    begin {
        $Tokens = [Collection[Token]]::new()
        $ParseErrors = [Collection[ParseError]]::new()
    }
    process {
        switch ($PSCmdlet.ParameterSetName) {
            'File' {
                $PSPath = $ExecutionContext.SessionState.Path.GetResolvedPSPathFromPSPath($Path).ProviderPath
                $Parser = [Parser]::ParseFile($PSPath, [ref]$Tokens, [ref]$ParseErrors)
            }
            'Code' {
                $SBCode = ($Code -split "`n" | ForEach-Object { $_.TrimEnd() }) -join "`n"
                $Parser = [Parser]::ParseInput($SBCode, [ref]$Tokens, [ref]$ParseErrors)
            }
            'FunctionName' {
                $CmdInfo = Get-Command -Name $FunctionName -CommandType Alias,Function,Filter -ErrorAction Stop
                if ($CmdInfo.CommandType -eq 'Alias') {
                    $CmdInfo = $CmdInfo.ReferencedCommand
                }
                $SB = [System.Text.StringBuilder]::new()
                $null = $SB.Append(('function {0} {1}' -f $CmdInfo.Name,[char]::ConvertFromUtf32(123)))
                $null = $SB.Append($CmdInfo.Definition)
                $null = $SB.Append([char]::ConvertFromUtf32(125))
                $Parser = [Parser]::ParseInput($SB.ToString(), [ref]$Tokens, [ref]$ParseErrors)
            }
            default {
                throw 'Invalid ParameterSet.'
            }
        }

        if ($ParseErrors.Count -gt 0) {
            Write-Warning ('Parse errors encountered: {0}' -f $ParseErrors.Count)
        }

        $FoundVariables = $Tokens.Where({$_.Kind -eq 'Variable'}).Text | Sort-Object -Unique
        $FoundCommands = $Tokens.Where({$_.TokenFlags -band 'CommandName'}).Text | Sort-Object -Unique

        [pscustomobject]@{
            Commands = $FoundCommands
            Variables = $FoundVariables
        }
    }
}
