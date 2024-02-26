Function Remove-EnvPath {
    [CmdletBinding(SupportsShouldProcess)]
    Param(
        [EnvironmentVariableTarget]$VariableTarget = [EnvironmentVariableTarget]::Machine
    )
    DynamicParam {
        $RuntimeParameterDictionary = [System.Management.Automation.RuntimeDefinedParameterDictionary]::new()
        $AttributeCollection = [System.Collections.ObjectModel.Collection[Attribute]]::new()

        $ParameterAttribute = [Parameter]::new()
        $ParameterAttribute.Mandatory = $true
        $ParameterAttribute.Position = 0
        $ParameterAttribute.HelpMessage = 'Select a Path from the PATH environment variable'
        $AttributeCollection.Add($ParameterAttribute)

        # Check if VariableTarget is in the bound parameters and use it; otherwise, default to Machine
        $Target = [EnvironmentVariableTarget]::Machine
        if ($PSBoundParameters.ContainsKey('VariableTarget')) { $Target = $PSBoundParameters['VariableTarget'] }
        $EnvPath = [Environment]::GetEnvironmentVariable('PATH', $Target) -split [System.IO.Path]::PathSeparator

        # Combine and annotate PATH entries based on VariableTarget
        $AnnotatedPathEntries = [System.Collections.Generic.List[string]]::new()
        foreach ($Entry in $EnvPath) { $AnnotatedPathEntries.Add($Entry) }

        $ValidateSetAttribute = [ValidateSet]::new($AnnotatedPathEntries.ToArray())
        $AttributeCollection.Add($ValidateSetAttribute)

        $RuntimeParameter = [System.Management.Automation.RuntimeDefinedParameter]::new('Path', [string], $AttributeCollection)
        $RuntimeParameterDictionary.Add('Path', $RuntimeParameter)

        return $RuntimeParameterDictionary
    }
    begin {
        if (-not (Test-IfAdmin)) { throw 'RUN AS ADMINISTRATOR' }
        $OldPath = [Environment]::GetEnvironmentVariable('PATH', $VariableTarget).Split(';').TrimEnd('\')
        $NewPath = [System.Collections.Generic.List[string]]::new()
        $OldPath.ForEach({$NewPath.Add($_)})
    }
    process {
        $Path = $PSBoundParameters['Path']
        $Path = (Convert-Path -Path $Path -ErrorAction SilentlyContinue).TrimEnd('\')
        if ($NewPath -contains $Path) {
            if ($PSCmdlet.ShouldProcess($Path, 'Remove from env PATH')) {
                $NewPath.Remove($Path)
            }
        }
        else {
            Write-Warning -Message ('SKIPPING: {0} - was not found within - ({1}) PATH' -f $Path, $VariableTarget)
        }
    }
    end {
        [Environment]::SetEnvironmentVariable('PATH', ($NewPath -join ';'), $VariableTarget)
        $Confirm = [Environment]::GetEnvironmentVariable('PATH', $VariableTarget).Split(';')
        return $Confirm
    }
}
