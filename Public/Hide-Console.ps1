function Hide-Console {
  Begin {
    if (!('Console.Window' -as [type])) {
      # .Net methods for hiding/showing the console in the background
      Add-Type -Name Window -Namespace Console -MemberDefinition @'
        [DllImport("Kernel32.dll")]
        public static extern IntPtr GetConsoleWindow();

        [DllImport("user32.dll")]
        public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'@
    }
  }
  Process {
    $null = [Console.Window]::ShowWindow([Console.Window]::GetConsoleWindow(), 0)
  }
}
