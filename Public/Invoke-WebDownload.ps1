function Invoke-WebDownload {
  [OutputType('System.IO.FileInfo')]
  [Alias('wgetDL')]
  param(
    [Parameter(Mandatory,ValueFromPipeline)]
    [Uri]$Uri,
    [ValidateScript({
          if(-Not ($_ | Test-Path -PathType Container) ){
            throw 'The Path argument must be a folder.'
          }
          return $true
    })]
    [IO.DirectoryInfo]$OutDir = $PWD.Path
  )
  process{
    $OutPath = Join-Path -Path $OutDir -ChildPath $(Split-Path -Leaf -Path $Uri)
    Invoke-WebRequest -UseBasicParsing -Uri $Uri -OutFile $OutPath -Verbose:$VerbosePreference
  }
  end{
    Get-Item -Path $OutPath
  }
}
