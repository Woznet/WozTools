class NullEncoder : System.Text.UTF8Encoding {
}

function Get-Encoding {
    <#
        .SYNOPSIS
        Gets Encoding for BOM and Non-BOM text files.

        .DESCRIPTION
        Returns the encoding of text files.
        For BOM-encoded files, the fast .NET methods are used, and confidence level is always 100%.
        For Non-BOM-encoded files, extensive heuristicts are applied, and confidence level varies depending on file content.
        Heuristics are calculated by a porting of the Mozilla Universal Charset Detector (https://github.com/errepi/ude)
        Important: this library is subject to the Mozilla Public License Version 1.1, alternatively licensed
        either under terms of GNU General Public License Version 2 or later, or GNU Lesser General Public License Version 2.1 or later.

        .PARAMETER Path
        Path to text file

        .PARAMETER BomOnly
        Returns information for BOM-encoded files only.

        .EXAMPLE
        Get-Encoding -Path c:\sometextfile.txt
        Returns the encoding of the text file specified

        .EXAMPLE
        Get-ChildItem -Path $home -Filter *.txt -Recurse | Get-Encoding
        Returns the encoding of any text file found anywhere in the current user profile.

        .NOTES
        Make sure you respect the license terms of the ported charset detector DLL.

        Source: https://github.com/TobiasPSP/GetEncoding/blob/main/Modules/EncodingAnalyzer/1.0.3/loader.psm1

        .LINK
        https://github.com/TobiasPSP/GetEncoding
        https://github.com/errepi/ude
        https://techblog.dorogin.com/changing-source-files-encoding-and-some-fun-with-powershell-df23bf8410ab
#>
    param(
        [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline, Mandatory)]
        [ValidateScript({
                if (-not ($_ | Test-Path -PathType Leaf) ) {
                    throw 'File does not exist'
                }
                return $true
            })]
        [Alias('FullName')]
        [string]$Path,

        [switch]$BomOnly
    )
    begin {
        if (-not ([Ude.Charsets])) {
            try {
                # load charset detector dll:
                Add-Type -Path ([System.IO.Path]::Combine($PSScriptRoot, '..\Lib\Ude\Ude.dll')) -ErrorAction Stop
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
        }

        $CDet = [Ude.CharsetDetector]::new()
        $NullEncoder = [NullEncoder]::new()
    }
    process {
        # try and read the BOM encoding:
        # submit a dummy encoder class that is used if the encoding cannot be
        # determined from BOM. This way we know that additional heuristic analysis is needed:
        $Reader = [System.IO.StreamReader]::new($Path, $NullEncoder, $true)
        # must read the file at least once to get encoding:
        $null = $Reader.Peek()
        $Encoding = $Reader.CurrentEncoding
        $Reader.Close()
        $Reader.Dispose()
        # if the encoding equals default encoding then there was no bom:
        $Bom = $Encoding -ne $NullEncoder
        $BodyName = $Encoding.BodyName
        $Confidence = 100

        # if there was no bom and non-bom files were not excluded...
        if (($Bom -eq $false) -and ($BomOnly.IsPresent -eq $false)) {
            # ...do a heuristic analysis based on file content:
            [System.IO.FileStream]$Stream = [System.IO.File]::OpenRead($Path)
            $CDet.Feed($Stream)
            $CDet.DataEnd()
            $BodyName = $CDet.Charset
            $Confidence = [int]($CDet.Confidence * 100)
            # add a workaround for the awkward default encoding created by Set-Content on Windows PowerShell:
            if ($Confidence -eq 0 -and $null -eq $BodyName) {
                $Confidence = 25
                $BodyName = 'ANSI'
            }
            $Stream.Close()
            $Stream.Dispose()
        }

        # return findings as a custom object:
        if ($Bom -or !$BomOnly.IsPresent) {
            [PSCustomObject]@{
                BOM        = $Bom
                Encoding   = $BodyName.ToUpper()
                Confidence = $Confidence
                Path       = $Path
            }
        }
    }
}
