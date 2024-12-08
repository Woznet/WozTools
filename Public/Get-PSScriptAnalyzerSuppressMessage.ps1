[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')]
[CmdletBinding()]
param()

function Get-PSScriptAnalyzerSuppressMessage {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateSet(
            'PSAlignAssignmentStatement', 'PSAvoidAssignmentToAutomaticVariable', 'PSAvoidDefaultValueForMandatoryParameter',
            'PSAvoidDefaultValueSwitchParameter', 'PSAvoidExclaimOperator', 'PSAvoidGlobalAliases', 'PSAvoidGlobalFunctions',
            'PSAvoidGlobalVars', 'PSAvoidInvokingEmptyMembers', 'PSAvoidLongLines', 'PSAvoidMultipleTypeAttributes',
            'PSAvoidNullOrEmptyHelpMessageAttribute', 'PSAvoidOverwritingBuiltInCmdlets', 'PSAvoidSemicolonsAsLineTerminators',
            'PSAvoidShouldContinueWithoutForce', 'PSAvoidTrailingWhitespace', 'PSAvoidUsingAllowUnencryptedAuthentication',
            'PSAvoidUsingBrokenHashAlgorithms', 'PSAvoidUsingCmdletAliases', 'PSAvoidUsingComputerNameHardcoded',
            'PSAvoidUsingConvertToSecureStringWithPlainText', 'PSAvoidUsingDeprecatedManifestFields',
            'PSAvoidUsingDoubleQuotesForConstantString', 'PSAvoidUsingEmptyCatchBlock', 'PSAvoidUsingInvokeExpression',
            'PSAvoidUsingPlainTextForPassword', 'PSAvoidUsingPositionalParameters', 'PSAvoidUsingUsernameAndPasswordParams',
            'PSAvoidUsingWMICmdlet', 'PSAvoidUsingWriteHost', 'PSDSCDscExamplesPresent', 'PSDSCDscTestsPresent',
            'PSDSCReturnCorrectTypesForDSCFunctions', 'PSDSCStandardDSCFunctionsInResource', 'PSDSCUseIdenticalMandatoryParametersForDSC',
            'PSDSCUseIdenticalParametersForDSC', 'PSDSCUseVerboseMessageInDSCResource', 'PSMisleadingBacktick',
            'PSMissingModuleManifestField', 'PSPlaceCloseBrace', 'PSPlaceOpenBrace', 'PSPossibleIncorrectComparisonWithNull',
            'PSPossibleIncorrectUsageOfAssignmentOperator', 'PSPossibleIncorrectUsageOfRedirectionOperator', 'PSProvideCommentHelp',
            'PSReservedCmdletChar', 'PSReservedParams', 'PSReviewUnusedParameter', 'PSShouldProcess', 'PSUseApprovedVerbs',
            'PSUseBOMForUnicodeEncodedFile', 'PSUseCmdletCorrectly', 'PSUseCompatibleCmdlets', 'PSUseCompatibleCommands',
            'PSUseCompatibleSyntax', 'PSUseCompatibleTypes', 'PSUseConsistentIndentation', 'PSUseConsistentWhitespace',
            'PSUseCorrectCasing', 'PSUseDeclaredVarsMoreThanAssignments', 'PSUseLiteralInitializerForHashtable',
            'PSUseOutputTypeCorrectly', 'PSUseProcessBlockForPipelineCommand', 'PSUsePSCredentialType',
            'PSUseShouldProcessForStateChangingFunctions', 'PSUseSingularNouns', 'PSUseSupportsShouldProcess',
            'PSUseToExportFieldsInManifest', 'PSUseUsingScopeModifierInNewRunspaces', 'PSUseUTF8EncodingForHelpFile'
        )]
        [string[]]$Rule
    )
    begin {
        $SuppressTemplate = @'
[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('{0}','')]

'@

        $EndText = '[CmdletBinding()]', 'param()'

        $SB = [System.Text.StringBuilder]::new()
    }
    process {
        foreach ($R in $Rule) { $null = $SB.AppendFormat($SuppressTemplate, $R) }
    }
    end {
        $EndText.ForEach({$null = $SB.AppendLine($_)})
        $SB.ToString()
    }
}
