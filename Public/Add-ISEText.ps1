function Add-ISEText {
  <#
      .Synopsis
      Add text to the bottom of current ISE File

      .EXAMPLE
      Add-ISEText -InputObject (Get-Content $profile)

      .EXAMPLE
      'happy','go','lucky' | Add-ISEText

      .EXAMPLE
      Get-ChildItem 'C:\temp' | Add-ISEText
  #>
  [Alias('InISE')]
  Param(
    # Text to insert
    [Parameter(
        Mandatory,
        ValueFromPipeline
    )]
    [psobject[]]$InputObject
  )
  Begin {
    if(-not ($psISE)) {throw 'PowerShell ISE Only'}
  }
  Process {
    foreach ($Object in $InputObject) {
      $LastLineLength = $psISE.CurrentFile.Editor.GetLineLength($psISE.CurrentFile.Editor.LineCount) + 1
      if ($LastLineLength -ne 1) {
        $psISE.CurrentFile.Editor.SetCaretPosition($psISE.CurrentFile.Editor.LineCount,$LastLineLength)
        $psISE.CurrentFile.Editor.InsertText("`n")
      }
      $psISE.CurrentFile.Editor.SetCaretPosition($psISE.CurrentFile.Editor.LineCount,1)
      $psISE.CurrentFile.Editor.InsertText($Object)
    }
  }
}

