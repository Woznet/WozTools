function Get-PublicIP {
    <#
.SYNOPSIS
Retrieves the public IP address of the local system.

.DESCRIPTION
The Get-PublicIP function queries an external service to find the public IP address of the system
on which it is run. It supports two different services: ipinfo.io and ifconfig.me, allowing the user
to choose based on preference or availability. Each service provides the IP information in JSON format.

.PARAMETER Tool
Specifies the api tool used to fetch the public IP address. The valid choices are 'ifconfig' and 'ipinfo'.
- 'ipinfo' uses the URL 'https://ipinfo.io/json' to retrieve the IP information.
- 'ifconfig' uses the URL 'https://ifconfig.me/all.json' to retrieve the IP information.
The default is 'ipinfo'.

.EXAMPLE
Get-PublicIP
Retrieves the public IP using the default 'ipinfo' service at 'https://ipinfo.io/json'.

.EXAMPLE
Get-PublicIP -Tool ifconfig
Retrieves the public IP using the 'ifconfig' service at 'https://ifconfig.me/all.json'.

.NOTES
Ensure that the machine running this script has internet access and permissions to make outbound HTTP requests.

#>
    [CmdletBinding()]
    param(
        [ValidateSet('ifconfig', 'ipinfo')]
        [string]$Tool = 'ipinfo'
    )

    # Hashtable to map tool names to service URLs
    $Url = @{
        ipinfo = 'https://ipinfo.io/json'
        ifconfig = 'https://ifconfig.me/all.json'
    }

    # Making the API call to retrieve the public IP address
    try {
        Invoke-RestMethod -Uri $Url[$Tool] -ErrorAction Stop
    }
    catch {
        Write-Error ('Failed to retrieve the IP address using {0} ({1}).' -f $Tool, $Url[$Tool])
        [System.Management.Automation.ErrorRecord]$e = $_
        [PSCustomObject]@{
            Type = $e.Exception.GetType().FullName
            Exception = $e.Exception.Message
            Reason = $e.CategoryInfo.Reason
            Target = $e.CategoryInfo.TargetName
            Script = $e.InvocationInfo.ScriptName
            Message = $e.InvocationInfo.PositionMessage
        }
        throw $_
    }
}
