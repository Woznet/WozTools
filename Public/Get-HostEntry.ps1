function Get-HostEntry {
<#
.SYNOPSIS
Retrieves DNS host entry information for given IP addresses or hostnames.

.DESCRIPTION
The Get-HostEntry function queries DNS to get the host entry information for a specified list of IP addresses or hostnames. It accepts input directly or via the pipeline and outputs the corresponding System.Net.IPHostEntry objects.

.PARAMETER Address
Specifies the IP address or hostname for which to get the host entry information. This parameter accepts an array of strings, each representing an IP address or hostname. It can also accept input from the pipeline.

.EXAMPLE
Get-HostEntry -Address 'www.example.com'
Retrieves the host entry information for 'www.example.com'.

.EXAMPLE
'8.8.8.8', '8.8.4.4' | Get-HostEntry
Retrieves the host entry information for the IP addresses '8.8.8.8' and '8.8.4.4' using pipeline input.

.INPUTS
System.String[]
You can pipe a string array of IP addresses or hostnames to Get-HostEntry.

.OUTPUTS
System.Net.IPHostEntry
Returns an array of IPHostEntry objects that represent the DNS host entry information for each IP address or hostname provided.

.NOTES
Ensure that the input addresses or hostnames are valid. The function validates if each input is a well-formed IP address or URI but does not verify their existence in DNS.

.LINK
https://docs.microsoft.com/en-us/dotnet/api/system.net.dnshostentry

#>
    [CmdletBinding()]
    [OutputType([System.Net.IPHostEntry])]
    param(
        [Parameter(ValueFromPipeline)]
        [ValidateScript({
            if (-not $_ -as [uri] -or -not $_ -as [ipaddress]) {
                throw 'Input must be an IP address or a valid hostname.'
            }
            return $true
        })]
        [string[]]$Address = '127.0.0.1'
    )
    begin {
        $Results = [System.Collections.Generic.List[System.Net.IPHostEntry]]@()
    }
    process {
        foreach ($A in $Address) {
            try {
                $HostEntry = [System.Net.Dns]::GetHostEntry($A)
                $Results.Add($HostEntry)
            }
            catch {
                Write-Error "Failed to get host entry for '$A': $_"
            }
        }
    }
    end {
        return $Results
    }
}
