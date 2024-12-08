function Get-ComObject {
    <#
.SYNOPSIS
Retrieves COM objects from the Windows Registry that match specified filter criteria.

.DESCRIPTION
The Get-ComObject function searches the HKEY_CLASSES_ROOT registry hive for COM objects
that match a given pattern and optionally filters them based on user-provided strings.
It checks each registry key to see if it conforms to a typical COM object naming format
and contains a CLSID subkey.

.PARAMETER Filter
An array of strings used to filter the COM objects by their names. The function will only
return names that contain any of the specified strings. Each string is treated in a
case-insensitive manner.

.EXAMPLE
Get-ComObject -Filter 'Microsoft', 'Excel'
This example retrieves all COM objects whose names contain either "Microsoft" or "Excel".

.NOTES
This function handles registry access and object disposal safely to prevent resource leaks.
Errors in accessing registry keys are silently ignored, which is useful in environments
with varying access permissions.

Acknowledgments:
The original version of this function was provided by https://github.com/ImportTaste

#>
    [CmdletBinding()]
    param(
        # Validates each element in the array to ensure it is not null or empty
        [ValidateScript({
                $_.Count -eq $_.Where{ -not [String]::IsNullOrEmpty($_) }.Count
            })]
        [string[]]$Filter
    )

    # Convert filter elements to lowercase for case-insensitive comparison
    $Filter = $Filter.ForEach('ToLower')

    # Regex to check for valid COM object format, compiled for better performance in repetitive use
    $Rgx = [regex]::new('^\w+\.\w+$', 'Compiled')

    # Get all child items from HKCR, ignore errors silently, useful for missing permissions or broken registry links
    Get-ChildItem Registry::HKEY_CLASSES_ROOT -ErrorAction SilentlyContinue -PipelineVariable k | & {
        process {
            # Process each registry item to see if it matches the expected COM object format
            if ( $Rgx.Match($k.PSChildName).Success ) {
                # Attempt to open the registry key and check for CLSID subkey existence
                $CLSIDExists = try {
                    $Obj = [Microsoft.Win32.Registry]::ClassesRoot.OpenSubkey($k.PSChildName)
                    ($false, $true)[ 'CLSID' -in $Obj.GetSubKeyNames() ]
										}
                catch [System.Management.Automation.RuntimeException] {
                    $false
                }
                finally {
                    # Safely dispose of the registry key object if it has been created
                    try {
                        $Obj.Dispose()
                    }
                    catch {
                        $null
                    }
                }

                # Output the PSChildName if CLSID exists and matches the filter criteria, if provided
                if ($CLSIDExists) {
                    if ($Filter) {
                        foreach ($f in $Filter) {
                            if ($k.PSChildName.ToLower().Contains($f)) {
                                $k.PSChildName
                                break
                            }
                        }
                    }
                    else {
                        $k.PSChildName
                    }
                }
            }
        }
    }
}
