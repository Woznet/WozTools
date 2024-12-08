function Set-Slideshow {
    <#
.SYNOPSIS
Configures the desktop wallpaper to a slideshow using the specified folder.

.DESCRIPTION
Sets the desktop wallpaper slideshow using images from the specified folder.
Allows customization of display mode, interval, and shuffle options.
Optionally returns slideshow details with $PassThru parameter.

.PARAMETER FolderPath
The path to the folder containing images for the slideshow. Must be a valid directory.

.PARAMETER Fit
Specifies how wallpapers are displayed. Options are Center, Tile, Stretch, Fit, Fill, or Span.
Defaults to Fill.

.PARAMETER Interval
Time interval between changing wallpapers.
Defaults to 10 minutes.

.PARAMETER NoShuffle
Disables shuffling wallpapers.
By default, wallpapers are shuffled.

.PARAMETER PassThru
Returns the current slideshow configuration.

.EXAMPLE
Set-Slideshow -FolderPath 'C:\Wallpapers' -Fit Fill -Interval (New-TimeSpan -Minutes 5)

Sets a slideshow with the Fill display mode, changes wallpapers every 5 minutes, and shuffles wallpapers.

.EXAMPLE
Set-Slideshow -FolderPath 'C:\Wallpapers' -Fit Center -NoShuffle -PassThru

Sets a slideshow with the Center display mode, disables shuffling, and returns the current slideshow configuration.

.NOTES
Uses the Vanara.Windows.Shell.WallpaperManager library to set the desktop wallpaper slideshow.
https://www.nuget.org/packages/Vanara.Windows.Shell.Common
#>
    [CmdletBinding()]
    [OutputType()]
    Param(
        # Path to the folder containing slideshow images
        [Parameter(Mandatory, Position = 0)]
        [ValidateScript({
                if (-not (Test-Path $_ -PathType Container)) {
                    throw ('Unable to find the directory - {0}' -f $_)
                }
                return $true
            })]
        [string]$FolderPath,

        # Specifies how the wallpapers are displayed
        [Parameter()]
        [ValidateSet('Center', 'Tile', 'Stretch', 'Fit', 'Fill', 'Span')]
        [string]$Fit = 'Fill',

        # Time interval between changing wallpapers
        [Parameter()]
        [TimeSpan]$Interval = [timespan]::FromMinutes(10),

        # Disables shuffling wallpapers
        [switch]$NoShuffle,

        [switch]$PassThru
    )
    process {
        try {
            # Load the required assembly
            $JoinPath = @{
                Path = $PSScriptRoot
                ChildPath = '..\Lib\Vanara.Windows.Shell.Common\WozDev-SetSlideshow.dll'
                Resolve = $true
                ErrorAction = 'Stop'
            }
            $AssemblyPath = Join-Path @JoinPath
            if (-not (Get-Module -Name 'WozDev-SetSlideshow')) {
                Import-Module -Path $AssemblyPath
            }

            # Determine Shuffle value
            $Shuffle = -not $NoShuffle

            # Convert Fit parameter to Vanara enum
            $WallpaperFit = [enum]::Parse([Vanara.Windows.Shell.WallpaperFit], $Fit, $true)

            # Set slideshow
            [Vanara.Windows.Shell.WallpaperManager]::SetSlideshow(
                $FolderPath,
                $WallpaperFit,
                $Interval,
                $Shuffle
            )
            if ($PassThru) {
                $SlideshowInfo = [Vanara.Windows.Shell.WallpaperManager]::Slideshow
                Write-Output $SlideshowInfo
            }
        }
        catch {
            [System.Management.Automation.ErrorRecord]$e = $_
            [pscustomobject]@{
                Type = $e.Exception.GetType().FullName
                Exception = $e.Exception.Message
                Reason = $e.CategoryInfo.Reason
                Target = $e.CategoryInfo.TargetName
                Message = $e.InvocationInfo.PositionMessage
            } | Out-String | Write-Host -ForegroundColor Red -NoNewline
            throw $_
        }
    }
}
