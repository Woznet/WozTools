function Get-EnumerateFiles {
  Param(
    [Parameter(Mandatory)]
    [string]$Path,
    [string]$Filter = '*'
  )
  begin {
    try {  
      $AlphaFSDll = [System.IO.Path]::Combine((Split-Path -Path $PSScriptRoot -Parent),'Lib\AlphaFS\Net452\AlphaFS.dll')
      $null = [System.Reflection.Assembly]::LoadFile($AlphaFSDll)
    }
    catch {
      [System.Management.Automation.ErrorRecord]$e = $_
      [PSCustomObject]@{
        Type      = $e.Exception.GetType().FullName
        Exception = $e.Exception.Message
        Reason    = $e.CategoryInfo.Reason
        Target    = $e.CategoryInfo.TargetName
        Script    = $e.InvocationInfo.ScriptName
        Line      = $e.InvocationInfo.ScriptLineNumber
        Column    = $e.InvocationInfo.OffsetInLine
      }
    }

    function Invoke-GenericMethod {
      [CmdletBinding()]
      Param(
        $Instance,
        [string]$MethodName,
        [type[]]$TypeParameters,
        [object[]]$MethodParameters
      )
      [System.Collections.ArrayList]$private:ParameterTypes = @{}
      foreach ($private:ParamType In $MethodParameters) {$null = $ParameterTypes.Add($ParamType.GetType())}
      $private:Method = $Instance.GetMethod($MethodName, 'Instance,Static,Public', $null, $ParameterTypes, $null)
      if ($null -eq $Method) {
        throw ('Method: [{0}]::{1} not found.' -f $Instance.ToString(),$MethodName)
      }
      else {
        $Method = $Method.MakeGenericMethod($TypeParameters)
        $Method.Invoke($Instance, $MethodParameters)
      }
    }
    $AlphaFiles = [System.Collections.ArrayList]@()
  }
  process {
  
    $SplattAlpha = @{
      Instance = ([Alphaleonis.Win32.Filesystem.Directory])
      MethodName = 'EnumerateFileSystemEntryInfos'
      TypeParameters = 'Alphaleonis.Win32.Filesystem.FileSystemEntryInfo'
      MethodParameters = $Path, $Filter,([Alphaleonis.Win32.Filesystem.DirectoryEnumerationOptions]'FilesAndFolders, Recursive, SkipReparsePoints, ContinueOnException'), ([Alphaleonis.Win32.Filesystem.PathFormat]::FullPath)
    }
    # $SplattAlpha
    foreach ($private:Folder in (Invoke-GenericMethod @SplattAlpha)) {
      # $Folder.FullPath
      $null = $AlphaFiles.Add($Folder)
    }
    $AlphaFiles
  }
}







