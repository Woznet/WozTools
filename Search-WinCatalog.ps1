function Search-WinCatalog {
  [CmdletBinding()]
  [Alias('dl-msu')]
	param(
		[Parameter(Mandatory)]
		[String]$KB,
		[ValidateSet('Windows 10','Server 2019')]
		[string]$OS = 'Windows 10'
	)
	$chrome = Join-Path -Path ${env:ProgramFiles(x86)} -ChildPath 'Google\Chrome Beta\Application\chrome.exe' -Resolve
	switch ($OS) {
		'Windows 10' {
			$url = 'https://www.catalog.update.microsoft.com/Search.aspx?q=x64%20windows%2010%20{0}%20' -f $KB
			Start-Process -FilePath $chrome -ArgumentList $url
		}
		'Server 2019' {
			$url = 'https://www.catalog.update.microsoft.com/Search.aspx?q=x64%20server%202019%20{0}%20' -f $KB
			Start-Process -FilePath $chrome -ArgumentList $url
		}
	}
}