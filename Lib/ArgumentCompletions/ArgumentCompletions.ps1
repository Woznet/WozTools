if ($PSVersionTable.PSEdition -ne 'Core') {
    if (-not ('ArgumentCompletionsAttribute' -as [type])) {
        # add the attribute [ArgumentCompletions()]:
        $Code = @'
using System;
using System.Collections.Generic;
using System.Management.Automation;

public class ArgumentCompletionsAttribute : ArgumentCompleterAttribute
{
    private static ScriptBlock _createScriptBlock(params string[] completions)
    {
        string text = "\"" + string.Join("\",\"", completions) + "\"";
        string code =
            "param($Command, $Parameter, $WordToComplete, $CommandAst, $FakeBoundParams);@(' + text + ') -like \"*$WordToComplete*\" | ForEach-Object { [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_) }";
        return ScriptBlock.Create(code);
    }

    public ArgumentCompletionsAttribute(params string[] completions)
        : base(_createScriptBlock(completions)) { }
}
'@
        $null = Add-Type -TypeDefinition $Code *>&1
    }
}