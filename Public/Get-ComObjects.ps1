function Get-ComObjects {
  [CmdletBinding()]
  param(
    [ValidateScript({
      $_.Count -eq $_.Where{ -not [String]::IsNullOrEmpty($_) }.Count
    })]
    [string[]]
    $Filter
  )

  $Filter = $Filter.ForEach('ToLower')
  $rgx = [regex]::new('^\w+\.\w+$', 'Compiled')

  Get-ChildItem Registry::HKEY_CLASSES_ROOT -ea SilentlyContinue -pv k | &{process{
    if( $rgx.Match($k.PSChildName).Success ){
      $clsidExists =
        try {
          $obj = [Microsoft.Win32.Registry]::ClassesRoot.OpenSubkey($k.PSChildName)
          ($false,$true)[ 'CLSID' -in $obj.GetSubKeyNames() ]
        }
        catch [Management.Automation.RuntimeException] {
          $false
        }
        finally {
          try{ $obj.Dispose() }catch{}
        }
      if( $clsidExists -and $Filter ){
        if( $Filter.Where{ $k.PSChildName.ToLower().Contains($_) } ){
          $_.PSChildName
        }
      }
      elseif( $clsidExists ){
        $_.PSChildName
      }
    }
  }}
}
