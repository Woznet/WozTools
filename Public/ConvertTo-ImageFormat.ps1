function ConvertTo-ImageFormat {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$SourceImagePath,
        [Parameter()]
        [string]$DestinationImagePath,
        [ArgumentCompletions('Ai', 'Heic', 'Heif', 'Ico', 'Icon', 'Jpeg', 'Jpg', 'Pdf', 'Png', 'Svg', 'Tif', 'Tiff', 'WebP')]
        [string]$SourceImageFormat,
        [ArgumentCompletions('Ai', 'Heic', 'Heif', 'Ico', 'Icon', 'Jpeg', 'Jpg', 'Pdf', 'Png', 'Svg', 'Tif', 'Tiff', 'WebP')]
        [string]$DestinationImageFormat = 'Png',
        [ArgumentCompletions('Transparent', 'White', 'Black')]
        [string]$BackgroundColor
    )
    begin {
        try {
            $null = [ImageMagick.MagickNET]
        }
        catch {
            Write-Verbose 'Loading Assemblies: Magick.NET.Core.dll and Magick.NET-Q8-AnyCPU.dll'
            $null = Add-Type -Path (Join-Path $PSScriptRoot '..\Lib\Magick.NET\Magick.NET.Core.dll' -Resolve)
            $null = Add-Type -Path (Join-Path $PSScriptRoot '..\Lib\Magick.NET\Magick.NET-Q8-AnyCPU.dll' -Resolve)
        }
        $ImageFileExtensions = @{
            Ai = '.ai'
            Heic = '.heic'
            Heif = '.heif'
            Ico = '.ico'
            Icon = '.ico'
            Jpeg = '.jpg'
            Jpg = '.jpg'
            Pdf = '.pdf'
            Png = '.png'
            Svg = '.svg'
            Tif = '.tiff'
            Tiff = '.tiff'
            WebP = '.webp'
        }
        if (-not ($DestinationImagePath)) {
            $DestinationImagePath = [System.IO.Path]::ChangeExtension($SourceImagePath, $ImageFileExtensions[$DestinationImageFormat])
            $FileInfo = [System.IO.FileInfo]::new($DestinationImagePath)
            if ($FileInfo.Exists) {
                $DestinationImagePath = [System.IO.Path]::Combine($FileInfo.DirectoryName, ('{0}_converted{1}' -f $FileInfo.BaseName, $FileInfo.Extension))
            }
        }
        [ImageMagick.MagickNET]::Initialize()
    }
    process {
        $Settings = [ImageMagick.MagickReadSettings]::new()
        if ($BackgroundColor) {
            if (-not ($null -eq [ImageMagick.MagickColors]::$BackgroundColor)) {
                $Settings.BackgroundColor = [ImageMagick.MagickColors]::$BackgroundColor
            }
            else {
                Write-Warning ('Using White for BackgroundColor. Issue creating MagickColors object using - {0}' -f $BackgroundColor)
                $Image.BackgroundColor = [ImageMagick.MagickColors]::White
            }
        }
        $Settings.Density = [ImageMagick.Density]::new(92, 92)
        if ($SourceFormat) {
            $SourceFormat = [ImageMagick.MagickFormat]$SourceImageFormat
            $Settings.Format = $SourceFormat
        }

        $Image = [ImageMagick.MagickImage]::new($SourceImagePath, $Settings)

        if ($DestinationImageFormat) {
            $DestinationFormat = [ImageMagick.MagickFormat]$DestinationImageFormat
            $Image.Write($DestinationImagePath, $DestinationFormat)
        }
        else {
            $Image.Write($DestinationImagePath)
        }
    }
    end {
        $Image.Dispose()
    }
}
