# Join-Path $PSScriptRoot -ChildPath WozTools-Config.ps1

Add-Type -Path (Join-Path $PSScriptRoot -ChildPath 'AlphaFS\Net452\AlphaFS.dll') -PassThru:$false
Add-Type -Path (Join-Path $PSScriptRoot -ChildPath 'PForEach\PForEach.dll') -PassThru:$false

Add-Type -Path (Join-Path $PSScriptRoot -ChildPath 'KeyboardInput\KeyboardInput.cs') -PassThru:$false
Add-Type -Path (Join-Path $PSScriptRoot -ChildPath 'LengthFormatter\LengthFormatter.cs') -PassThru:$false


. (Join-Path $PSScriptRoot -ChildPath 'ArgumentCompletions\ArgumentCompletions.ps1')

. (Join-Path $PSScriptRoot -ChildPath 'SecureStringTransform\SecureStringTransform.ps1')

Update-FormatData -PrependPath (Join-Path $PSScriptRoot -ChildPath 'Formatting\MyCustomFileInfo.format.ps1xml')

. (Join-Path $PSScriptRoot -ChildPath 'PSReadLine\PSReadLine-Config.ps1')



# Join-Path $PSScriptRoot -ChildPath 'AlphaFS\Net452\AlphaFS.xml'

# Join-Path $PSScriptRoot -ChildPath 'ArgumentCompletions\ArgumentCompletions.cs'

# Join-Path $PSScriptRoot -ChildPath 'PSScriptAnalyzerSettings\PSScriptAnalyzerSettings.psd1'
