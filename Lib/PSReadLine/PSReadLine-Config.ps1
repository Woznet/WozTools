using namespace System.Management.Automation
using namespace System.Management.Automation.Language
using namespace Microsoft.PowerShell


if (-not ($psISE)) {
  if ($Host.PrivateData.ToString() -eq 'Microsoft.PowerShell.Host.ISE.ISEOptions') {
    return $false
  }
  if (-not (Get-Module -Name PSReadLine -ErrorAction Ignore)) {
    Import-Module -Name PSReadLine -Global -PassThru:$false -ErrorAction Stop
  }

  Set-PSReadLineOption -PredictionSource History
  if ($PSVersionTable.PSEdition -eq 'Core') {
    try {
      Import-Module -Global -Name Az.Tools.Predictor -PassThru:$false -ErrorAction Stop
    }
    catch [System.IO.FileNotFoundException] {
      Write-Warning -Message 'Az.Tools.Predictor - Has not been installed yet.'
      Write-Warning -Message 'Attempting to install it now.'
      Find-Module -Name Az.Accounts,Az.Tools.Predictor | Install-Module -Scope AllUsers -Force -PassThru:$false
      Import-Module -Global -Name Az.Tools.Predictor -PassThru:$false -ErrorAction Stop
    }

    try {
      Set-PSReadLineOption -PredictionSource HistoryAndPlugin -ErrorAction Stop
    }
    catch {
      [System.Management.Automation.ErrorRecord]$e = $_
      [PSCustomObject]@{
        Exception = $e.Exception.Message
        Reason    = $e.CategoryInfo.Reason
        Target    = $e.CategoryInfo.TargetName
        Script    = $e.InvocationInfo.ScriptName
        Message   = $e.InvocationInfo.PositionMessage
      }
      Set-PSReadLineOption -PredictionSource History -ErrorAction Stop
    }
  }



  Set-PSReadLineOption -Colors @{
    Selection        = "$([char]27)[92;7m"
    InLinePrediction = "$([char]27)[36;7;238m"
    ListPrediction   = '#1aa75a'
  }

  Set-PSReadLineOption -PromptText (
    # Good
    ('{0}[0m> ' -f ([char]27)),
    # Error
    ('{0}[38;5;196m> {0}[0m' -f ([char]27))
  )

  Set-PSReadLineOption -EditMode Windows
  Set-PSReadLineOption -ShowToolTips
  Set-PSReadLineOption -ContinuationPrompt '  '
  Set-PSReadLineOption -PredictionViewStyle ListView
  Set-PSReadLineOption -HistorySaveStyle SaveIncrementally
  Set-PSReadLineOption -HistorySearchCursorMovesToEnd

  Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
  Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

  Set-PSReadLineKeyHandler -Chord Ctrl+b -Function BackwardWord
  Set-PSReadLineKeyHandler -Chord Ctrl+f -Function ForwardWord
  Set-PSReadLineKeyHandler -Chord 'Ctrl+d,Ctrl+c' -Function CaptureScreen



  #######################################################

  Add-Type -AssemblyName Microsoft.PowerShell.PSReadLine2


  Set-PSReadLineKeyHandler -Key '"',"'" -BriefDescription SmartInsertQuote -LongDescription 'Insert paired quotes if not already on a quote' -ScriptBlock {
    param($Key, $Arg)
    $Quote = $Key.KeyChar
    $SelectionStart = $null
    $SelectionLength = $null
    [PSConsoleReadLine]::GetSelectionState([ref]$SelectionStart, [ref]$SelectionLength)
    $Line = $null
    $Cursor = $null
    [PSConsoleReadLine]::GetBufferState([ref]$Line, [ref]$Cursor)
    # If text is selected, just quote it without any smarts
    if ($SelectionStart -ne -1) {
      [PSConsoleReadLine]::Replace($SelectionStart, $SelectionLength, $Quote + $Line.SubString($SelectionStart, $SelectionLength) + $Quote)
      [PSConsoleReadLine]::SetCursorPosition($SelectionStart + $SelectionLength + 2)
      return
    }
    $Ast = $null
    $Tokens = $null
    $ParseErrors = $null
    [PSConsoleReadLine]::GetBufferState([ref]$Ast, [ref]$Tokens, [ref]$ParseErrors, [ref]$null)

    function FindToken {
      param($Tokens, $Cursor)
      foreach ($Token in $Tokens) {
        if ($Cursor -lt $Token.Extent.StartOffset) { continue }
        if ($Cursor -lt $Token.Extent.EndOffset) {
          $Result = $Token
          $Token = $Token -as [StringExpandableToken]
          if ($Token) {
            $Nested = FindToken -Tokens $Token.NestedTokens -Cursor $Cursor
            if ($Nested) { $Result = $Nested }
          }
          return $Result
        }
      }
      return $null
    }
    $Token = FindToken -Tokens $Tokens -Cursor $Cursor
    # If we're on or inside a **quoted** string token (so not generic), we need to be smarter
    if ($Token -is [StringToken] -and $Token.Kind -ne [TokenKind]::Generic) {
      # If we're at the start of the string, assume we're inserting a new string
      if ($Token.Extent.StartOffset -eq $Cursor) {
        [PSConsoleReadLine]::Insert("$Quote$Quote ")
        [PSConsoleReadLine]::SetCursorPosition($Cursor + 1)
        return
      }
      # If we're at the end of the string, move over the closing quote if present.
      if ($Token.Extent.EndOffset -eq ($Cursor + 1) -and $Line[$Cursor] -eq $Quote) {
        [PSConsoleReadLine]::SetCursorPosition($Cursor + 1)
        return
      }
    }
    if ($null -eq $Token -or
    $Token.Kind -eq [TokenKind]::RParen -or $Token.Kind -eq [TokenKind]::RCurly -or $Token.Kind -eq [TokenKind]::RBracket) {
      if ($Line[0..$Cursor].Where{$_ -eq $Quote}.Count % 2 -eq 1) {
        # Odd number of quotes before the cursor, insert a single quote
        [PSConsoleReadLine]::Insert($Quote)
      }
      else {
        # Insert matching quotes, move cursor to be in between the quotes
        [PSConsoleReadLine]::Insert("$Quote$Quote")
        [PSConsoleReadLine]::SetCursorPosition($Cursor + 1)
      }
      return
    }
    # If cursor is at the start of a token, enclose it in quotes.
    if ($Token.Extent.StartOffset -eq $Cursor) {
      if ($Token.Kind -eq [TokenKind]::Generic -or $Token.Kind -eq [TokenKind]::Identifier -or
      $Token.Kind -eq [TokenKind]::Variable -or $Token.TokenFlags.hasFlag([TokenFlags]::Keyword)) {
        $End = $Token.Extent.EndOffset
        $Len = $End - $Cursor
        [PSConsoleReadLine]::Replace($Cursor, $Len, $Quote + $Line.SubString($Cursor, $Len) + $Quote)
        [PSConsoleReadLine]::SetCursorPosition($End + 2)
        return
      }
    }
    # We failed to be smart, so just insert a single quote
    [PSConsoleReadLine]::Insert($Quote)
  }

  #######################################################

  Set-PSReadLineKeyHandler -Key '(','{','[' -BriefDescription InsertPairedBraces -LongDescription 'Insert matching braces' -ScriptBlock {
    param($Key, $Arg)
    $CloseChar = switch ($Key.KeyChar) {
      <#case#> '(' { [char]')'; break }
      <#case#> '{' { [char]'}'; break }
      <#case#> '[' { [char]']'; break }
    }
    $SelectionStart = $null
    $SelectionLength = $null
    [PSConsoleReadLine]::GetSelectionState([ref]$SelectionStart, [ref]$SelectionLength)
    $Line = $null
    $Cursor = $null
    [PSConsoleReadLine]::GetBufferState([ref]$Line, [ref]$Cursor)
    if ($SelectionStart -ne -1) {
      # Text is selected, wrap it in brackets
      [PSConsoleReadLine]::Replace($SelectionStart, $SelectionLength, $Key.KeyChar + $Line.SubString($SelectionStart, $SelectionLength) + $CloseChar)
      [PSConsoleReadLine]::SetCursorPosition($SelectionStart + $SelectionLength + 2)
    }
    else {
      # No text is selected, insert a pair
      [PSConsoleReadLine]::Insert("$($Key.KeyChar)$CloseChar")
      [PSConsoleReadLine]::SetCursorPosition($Cursor + 1)
    }
  }




  #######################################################

  # F1 for help on the command line - naturally
  Set-PSReadLineKeyHandler -Key F1 -BriefDescription CommandHelp -LongDescription 'Open the help window for the current command' -ScriptBlock {
    [CmdletBinding()]
    param($Key, $Arg)
    $Ast = $null
    $Tokens = $null
    $Errors = $null
    $Cursor = $null
    [PSConsoleReadLine]::GetBufferState([ref]$Ast, [ref]$Tokens, [ref]$Errors, [ref]$Cursor)
    $CommandAst = $Ast.FindAll({
        $Node = $Args[0]
        $Node -is [CommandAst] -and
        $Node.Extent.StartOffset -le $Cursor -and
        $Node.Extent.EndOffset -ge $Cursor
    }, $true) | Select-Object -Last 1
    if ($CommandAst -ne $null) { $CommandName = $CommandAst.GetCommandName()
      if ($CommandName -ne $null) { $Command = $ExecutionContext.InvokeCommand.GetCommand($CommandName, 'All')
        if ($Command -is [AliasInfo]) { $CommandName = $Command.ResolvedCommandName }
        if ($CommandName -ne $null) {
          try {
            $null = Get-Command -Name $CommandName -ErrorAction Stop
            Get-Help -Name $CommandName -ShowWindow
          }
          catch {
            [System.Management.Automation.ErrorRecord]$e = $_
            [PSCustomObject]@{
              Type      = $e.Exception.GetType().FullName
              Exception = $e.Exception.Message
              Reason    = $e.CategoryInfo.Reason
              Target    = $e.CategoryInfo.TargetName
              Script    = $e.InvocationInfo.ScriptName
              Message   = $e.InvocationInfo.PositionMessage
            }
          }
        }
      }
    }
  }

  #######################################################

  # Ctrl + e - Replace all aliases with the full command
  Set-PSReadlineKeyHandler -Chord 'Ctrl+e' -Description 'Replace all aliases with the full command' -BriefDescription 'ExpandAliases' -ScriptBlock {
    $Ast    = $null
    $Tokens = $null
    $Errors = $null
    $Cursor = $null
    [PSConsoleReadLine]::GetBufferState(
      [ref]$Ast,
      [ref]$Tokens,
      [ref]$Errors,
      [ref]$Cursor
    )
    $StartAdjustment = 0
    foreach ($Token in $Tokens) {
      if ($Token.TokenFlags -band [TokenFlags]::CommandName) {
        $Alias = $ExecutionContext.InvokeCommand.GetCommand($Token.Extent.Text, 'Alias')
        if ($Alias -ne $null) {
          $ResolvedCommand = $Alias.Definition
          if ($ResolvedCommand -ne $null) {
            $Extent = $Token.Extent
            $Length = $Extent.EndOffset - $Extent.StartOffset
            [PSConsoleReadLine]::Replace(
              $Extent.StartOffset + $StartAdjustment,
              $Length,
              $ResolvedCommand
            )
            $StartAdjustment += ($ResolvedCommand.Length - $Length)
          }
        }
      }
    }
  }

  #######################################################



  Set-PSReadLineKeyHandler -Chord Ctrl+w -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert('| Where-Object {$_. }')
    [Microsoft.PowerShell.PSConsoleReadLine]::BackwardChar()
    [Microsoft.PowerShell.PSConsoleReadLine]::BackwardChar()
  }


  #######################################################
}