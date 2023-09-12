function Import-Prompt {
  # Prompt

  # Function to check wheter current Console support ANSI codes
  function Test-Ansi {
    if ($Host.PrivateData.ToString() -eq 'Microsoft.PowerShell.Host.ISE.ISEOptions') {
      return $false
    }
    $OldPos = $Host.UI.RawUI.CursorPosition.X
    Write-Host -NoNewline "$([char](27))[0m" -ForegroundColor ($Host.UI.RawUI.BackgroundColor)
    $Pos = $Host.UI.RawUI.CursorPosition.X
    if ($Pos -eq $OldPos) {


      if (-not ('WozDev.PSColorsNativeMethods' -as [type])) {
        $Sig = @'
[DllImport("kernel32.dll", SetLastError = true)]
public static extern bool SetConsoleMode(IntPtr hConsoleHandle, int dwMode);

[DllImport("kernel32.dll", SetLastError = true)]
public static extern bool GetConsoleMode(IntPtr hConsoleHandle, ref int nCmdShow);

[DllImport("kernel32.dll", SetLastError = true)]
public static extern IntPtr GetStdHandle(int nStdHandle);
'@
        Add-Type -MemberDefinition $Sig -Name PSColorsNativeMethods -Namespace WozDev
      }
      try {
        $ConsoleHandle = [WozDev.PSColorsNativeMethods]::GetStdHandle(-11)
        $ConsoleMode = 0
        $null = [WozDev.PSColorsNativeMethods]::GetConsoleMode($ConsoleHandle, [ref] $ConsoleMode)
        return $true
      }
      catch {
        return $false
      }
    }
    else {
      Write-Host -NoNewline ("`b" * 4)
      return $false
    }
  }

  $global:HasAnsi = Test-Ansi


  function global:Get-ShortPath {
    if (-not ($null -eq $Host.UI.RawUI.WindowSize.Width)) {
      $MaxPromptPath = [int]($Host.UI.RawUI.WindowSize.Width/3);
      $CurrPath = $PWD.Path -replace '^[^:]+::';
      if ($CurrPath.Length -ge $MaxPromptPath) {
        $PathParts = $CurrPath.Split([System.IO.Path]::DirectorySeparatorChar);
        $MyPath = $PathParts[0],'...',$PathParts[$PathParts.Length - 1] -join [System.IO.Path]::DirectorySeparatorChar;
        $Counter = $PathParts.Length - 2;
        while(($MyPath.Replace('...',('...',$PathParts[$Counter] -join [System.IO.Path]::DirectorySeparatorChar)).Length -lt $MaxPromptPath) -and ($Counter -ne 0)) {
          $MyPath = $MyPath.Replace('...',('...',$PathParts[$Counter] -join [System.IO.Path]::DirectorySeparatorChar));
          $Counter--;
        }
      }
      else {
        $MyPath = $CurrPath;
      }
      return $MyPath;
    }
  }


  function global:prompt {
    if ((Get-Item -Path .).PSProvider.Name -eq 'FileSystem') {
      [System.Environment]::CurrentDirectory = (Convert-Path -Path '.')
    }

    $Time = '{0}{1}{2}' -f ([char]0xAB), ([DateTime]::Now.ToShortTimeString()), ([char]0xBB)
    $HostName = [System.Net.Dns]::GetHostName()
    $History = Get-History -Count 1 -ErrorAction Ignore

    $ShortPath = Get-ShortPath

    if (-not $HasAnsi) {
      if ($History) {
        $CmdExeTime = switch (New-TimeSpan -Start $History.StartExecutionTime -End $History.EndExecutionTime) {
          { $_.TotalSeconds -lt 1 } { '[{0}ms]' -f [int]$_.TotalMilliseconds ; break }
          { $_.TotalMinutes -lt 1 } { '[{0}s]' -f [int]$_.TotalSeconds ; break }
          { $_.TotalMinutes -ge 1 } { '[{0:HH:mm:ss}]' -f [datetime]$_.Ticks ; break }
        }
        Write-Host -NoNewline -ForegroundColor White ('{0} ' -f $History.Id)
        Write-Host -ForegroundColor White $CmdExeTime
      }
      Write-Host -NoNewline -ForegroundColor DarkCyan ([char]0xA7)
      Write-Host -NoNewline -ForegroundColor Yellow $Time
      Write-Host -NoNewline -ForegroundColor Green $HostName
      Write-Host -NoNewline -ForegroundColor DarkCyan '{'
      Write-Host -NoNewline -ForegroundColor Cyan $ShortPath
      Write-Host -NoNewline -ForegroundColor DarkCyan '}'
    }
    else {
      if ($History) {
        $esc = ([char]27)
        $EndASCI = '{0}[0m' -f $esc
        $CmdExeTime = switch (New-TimeSpan -Start $History.StartExecutionTime -End $History.EndExecutionTime) {
          { $_.TotalSeconds -lt 1 } {
            $T = '[{0}ms]' -f [int]$_.TotalMilliseconds
            $StartASCI = '{0}[38;5;{1}m' -f $esc, 117
            '{3} {0}{1}{2}' -f $StartASCI, $T, $EndASCI, $History.Id
            break
          }
          { $_.TotalMinutes -lt 1 } {
            $T = '[{0}s]' -f [int]$_.TotalSeconds
            $StartASCI = '{0}[38;5;{1}m' -f $esc, 82
            '{3} {0}{1}{2}' -f $StartASCI, $T, $EndASCI, $History.Id
            break
          }
          { $_.TotalMinutes -ge 1 } {
            $T = '[{0:HH:mm:ss}]' -f [datetime]$_.Ticks
            $StartASCI = '{0}[38;5;{1}m' -f $esc, 178
            '{3} {0}{1}{2}' -f $StartASCI, $T, $EndASCI, $History.Id
            break
          }
          { $_.TotalMinutes -ge 5 } {
            $T = '[{0:HH:mm:ss}]' -f [datetime]$_.Ticks
            $StartASCI = '{0}[38;5;{1}m' -f $esc, 202
            '{3} {0}{1}{2}' -f $StartASCI, $T, $EndASCI, $History.Id
            break
          }
        }
      }
      $esc = ([char]27) ; $lcyan = 81 ; $yel = 214 ; $grn = 46 ; $dcyan = 74
      Write-Host -NoNewline ((
          '{9}{10}' +
          '{0}[38;5;{4}m{8}{0}[38;5;{2}m{5}{0}[38;5;{3}m{6}' +
          '{0}[38;5;{4}m{{{0}[38;5;{1}m{7}{0}[38;5;{4}m}}{0}[0m'
        ) -f $esc, $lcyan, $yel, $grn, $dcyan,
      $Time, $HostName, $ShortPath, ([char]0xA7), $CmdExeTime, [environment]::NewLine)
    }
    return '> '
  }
}