function Show-Console {
  param(
    [Parameter(ParameterSetName='Hide')]
    [switch]$Hide,
    [Parameter(ParameterSetName='ShowNormal')]
    [switch]$ShowNormal,
    [Parameter(ParameterSetName='ShowMinimized')]
    [switch]$ShowMinimized,
    [Parameter(ParameterSetName='ShowMaximized')]
    [switch]$ShowMaximized,
    [Parameter(ParameterSetName='Maximize')]
    [switch]$Maximize,
    [Parameter(ParameterSetName='ShowNormalNoActivate')]
    [switch]$ShowNormalNoActivate,
    [Parameter(ParameterSetName='Show')]
    [switch]$Show,
    [Parameter(ParameterSetName='Minimize')]
    [switch]$Minimize,
    [Parameter(ParameterSetName='ShowMinNoActivate')]
    [switch]$ShowMinNoActivate,
    [Parameter(ParameterSetName='ShowNoActivate')]
    [switch]$ShowNoActivate,
    [Parameter(ParameterSetName='Restore')]
    [switch]$Restore,
    [Parameter(ParameterSetName='ShowDefault')]
    [switch]$ShowDefault,
    [Parameter(ParameterSetName='ForceMinimized')]
    [switch]$ForceMinimized
  )
  Begin {
    if (!('Console.Window' -as [type])) {
      # .Net methods for hiding/showing the console in the background
      Add-Type -Name Window -Namespace Console -MemberDefinition '
        [DllImport("Kernel32.dll")]
        public static extern IntPtr GetConsoleWindow();

        [DllImport("user32.dll")]
        public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
      '
    }
  }
  Process {
    $sval = switch($PsCmdlet.ParameterSetName) {
      'Hide' {'0'}
      'ShowNormal' {'1'}
      'ShowMinimized' {'2'}
      'ShowMaximized' {'3'}
      'Maximize' {'3'}
      'ShowNormalNoActivate' {'4'}
      'Show' {'5'}
      'Minimize' {'6'}
      'ShowMinNoActivate' {'7'}
      'ShowNoActivate' {'8'}
      'Restore' {'9'}
      'ShowDefault' {'10'}
      'ForceMinimized' {'11'}
      'Default' {throw 'Error has occured while assigning numerial values'}
    }
    $null = [Console.Window]::ShowWindow([Console.Window]::GetConsoleWindow(), $sval)
  }
}
