function Get-FunctionCode {
  <#
      .Synopsis
      Get the code of a powershell function
      .EXAMPLE
      # Gets the code for New-Guid
      Get-FunctionCode New-Guid
      .EXAMPLE
      # Outputs the code for New-Guid into a new PowerShell ISE Tab
      Get-FunctionCode -Function New-Guid -OutISE
      .EXAMPLE
      # Gets the code for New-Guid and saves it to V:\temp\New-Guid.ps1
      Get-FunctionCode New-Guid -OutFile V:\temp\New-Guid.ps1
      .EXAMPLE
      # Outputs the code for New-Guid into a new PowerShell ISE Tab and saves it to V:\temp\New-Guid.ps1
      Get-FunctionCode -Function New-Guid -OutISE -OutFile V:\temp\New-Guid.ps1
  #>
  Param(
    # Function Name
    [Parameter(Mandatory)]
    [ValidateScript({
          if (-not (Get-Command -Name $_ -CommandType Function -ErrorAction SilentlyContinue)) {
            throw ('Cannot find function - {0}' -f $_)
          }
          return $true
    })]
    [String]$Function,
    [ValidateScript({
          if (-not ($psISE)) {
            throw ('{0}-OutISE can only be use within PowerShell ISE' -f ("`n"))
          }
          return $true
    })]
    [switch]$OutISE,
    [ValidateScript({
          if($_ | Test-Path -PathType Leaf) {
            throw 'File already exists'
          }
          return $true
    })]
    [string]$OutFile
  )
  Process {
    $CmdInfo = Get-Command -Name $Function -CommandType Function
    $FCode = 'function {0} {2}{1}{3}' -f $CmdInfo.Name,$CmdInfo.Definition,('{'),('}')
    $FCode = ($FCode.Split("`n") | ForEach-Object { $_ -replace '\s*$' }) -join "`n"
    if($OutISE) {
      $IseFile1 = $psISE.CurrentPowerShellTab.Files.Add()
      $IseFile1.Editor.Text = $FCode
      $IseFile1.Editor.SetCaretPosition(1,1)
      if($OutFile) {
        $IseFile1.SaveAs($OutFile,[System.Text.UTF8Encoding]::new($false))
      }
    }
    else {
      if($OutFile) {
        [System.IO.File]::WriteAllLines($OutFile,$FCode,[System.Text.UTF8Encoding]::new($false))
      }
      $FCode | Write-Output
    }
  }
}
