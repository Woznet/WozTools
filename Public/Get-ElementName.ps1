function Get-ElementName {
  <#
      .SYNOPSIS
      Get the name of an element.

      .DESCRIPTION
      This function returns the name of an element.

      .PARAMETER Expression
      The expression to get the name of.

      .EXAMPLE
      Get-ElementName { $PSVersionTable }
      PSVersionTable
  #>
  [CmdletBinding()]
  [Alias('nameof')]
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
