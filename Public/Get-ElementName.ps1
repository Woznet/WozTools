function Get-ElementName {
  [Alias('nameof')]
  [CmdletBinding()]
  param(
    [Parameter(Position=0, Mandatory)]
    [ValidateNotNull()]
    [ScriptBlock] $Expression
  )
  end {
    if ($Expression.Ast.EndBlock.Statements.Count -eq 0) {
      return
    }

    $FirstElement = $Expression.Ast.EndBlock.Statements[0].PipelineElements[0]
    if ($FirstElement.Expression.VariablePath.UserPath) {
      return $FirstElement.Expression.VariablePath.UserPath
    }

    if ($FirstElement.Expression.Member) {
      return $FirstElement.Expression.Member.SafeGetValue()
    }

    if ($FirstElement.GetCommandName) {
      return $FirstElement.GetCommandName()
    }

    if ($FirstElement.Expression.TypeName.FullName) {
      return $FirstElement.Expression.TypeName.FullName
    }
  }
}
