function Open-RegPath {
  [CmdletBinding()]
  param(
    [Parameter()]
    [validatescript({
          $Rpath = 'registry::' + $_
          if (-not(Test-Path -Path $Rpath)){
            throw 'Cannot Find Registry Path - {0}' -f $_
          }
          return $true
    })]
    [String]$RegPath = $(Get-Clipboard)
  )
  $wsh = New-Object -ComObject wscript.shell
  $wsh.RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Applets\Regedit\LastKey",$RegPath,'REG_SZ')
  $wsh.Run('regedit.exe -m')
}
