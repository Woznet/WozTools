function Write-PSLog {
  param(
    [ValidateSet('Info', 'Warn', 'Error', 'Start', 'End', IgnoreCase = $false)]
    [string]$Severity = 'Info',
    [Parameter(Mandatory)]
    [string]$Message,
    [ValidateScript({
          if (-not ($_ | Test-Path -PathType Container -IsValid)) {
            throw 'Path is not a valid directory.'
          }
          return $true
    })]
    [string]$LogDirectory = 'C:\PSLogDir',
    [ValidateScript({
          if (-not ($_ | Test-Path -PathType Leaf -IsValid)) {
            throw 'LogFileName is not a valid.'
          }
          return $true
    })]
    [string]$LogFileName = 'PSLogFile.json',
    [System.Management.Automation.ErrorRecord]$LastException = $_
  )
  #Identify User run as account by Home directory
  $User = $HOME | Split-Path -Leaf

  $Metadata = [PSCustomObject]@{
    Invoking_User = $User
  }

  $CallStackDepth = 0
  $FullCallStack = Get-PSCallStack
  $CallingFunction = $FullCallStack[1].FunctionName

  $LogObject = [PSCustomObject]@{
    Timestamp       = (Get-Date).ToString()
    Severity        = $Severity
    CallingFunction = $CallingFunction
    Message         = $Message
    Metadata        = $Metadata
  }

  if ($Severity -eq 'Error') {

    if ($LastException.ErrorRecord) {
      #PSCore Error
      $LastError = $LastException.ErrorRecord
    }
    else {
      #PS 5.1 Error
      $LastError = $LastException
    }

    if ($LastException.InvocationInfo.MyCommand.Version) {
      $Version = $LastError.InvocationInfo.MyCommand.Version.ToString()
    }
    $LastErrorObject = @{
      'ExceptionMessage'    = $LastError.Exception.Message
      'ExceptionSource'     = $LastError.Exception.Source
      'ExceptionStackTrace' = $LastError.Exception.StackTrace
      'PositionMessage'     = $LastError.InvocationInfo.PositionMessage
      'InvocationName'      = $LastError.InvocationInfo.InvocationName
      'MyCommandVersion'    = $Version
      'ScriptName'          = $LastError.InvocationInfo.ScriptName
    }

    # $LogObject | Add-Member -MemberType NoteProperty -Name LastError -Value $LastErrorObject
    $LogObject.psobject.Members.Add([psnoteproperty]::new('LastError',$LastErrorObject))

    $FullCallStackWithoutLogFunction = $FullCallStack | ForEach-Object {
      #loop through all the objects in the callstack result.
      #excluding the 0 position of the call stack which would represent this Write-PSLog function.
      if ($CallStackDepth -gt 0) {
        [PSCustomObject]@{
          CallStackDepth   = $CallStackDepth
          ScriptLineNumber = $_.ScriptLineNumber
          FunctionName     = $_.FunctionName
          ScriptName       = $_.ScriptName
          Location         = $_.Location
          Command          = $_.Command
          Arguments        = $_.Arguments
        }
      }
      $CallStackDepth++
    }

    # $LogObject | Add-Member -MemberType NoteProperty -Name FullCallStackDump -Value $FullCallStackWithoutLogFunction
    $LogObject.psobject.Members.Add([psnoteproperty]::new('FullCallStackDump',$FullCallStackWithoutLogFunction))

    $WriteHostColor = @{ForegroundColor = 'Red'}
  }
  if (-not (Test-Path -Path $LogDirectory -PathType Container)) {$null = New-Item -Path $LogDirectory -ItemType Directory -Force}
  $LogFilePath = Join-Path -Path $LogDirectory -ChildPath $LogFileName
  $LogObject | ConvertTo-Json  -Depth 2 | Out-File -FilePath $LogFilePath -Append -Encoding utf8

  Write-Host "$($LogObject.Timestamp) Sev=$($LogObject.Severity) CallingFunction=$($LogObject.CallingFunction) `n   $($LogObject.Message)" @WriteHostColor
  if ($Severity -eq 'Error') {throw $LastException}
}
