function Get-PathFromClipboard {
  (Get-Clipboard).Trim() -replace '"' | Get-Item
}