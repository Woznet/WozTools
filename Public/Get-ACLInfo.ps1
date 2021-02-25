function Get-ACLInfo {
  <#
      .SYNOPSIS
      Get a summary of a folder ACL

      .DESCRIPTION
      This command will examine the ACL of a given folder and create a custom object.
      The object will include a count of access rules based on the identity
      reference. Any ACL that belongs to a builtin or system account, or Everyone and
      Creator Owner, will be counted as a SystemACL. Everything else will be counted
      as a UserACL. You might use this information to identify folders or files where
      ACLS aren't what you expect.

      The custom object also contains an AccessRules property which will be a
      collection of the access rules for that object.

      SystemACL   : 7
      Owner       : BUILTIN\Administrators
      UserACL     : 1
      AccessRules : {System.Security.AccessControl.FileSystemAccessRule, System.Security.
      AccessControl.FileSystemAccessRule, System.Security.AccessControl.
      FileSystemAccessRule, System.Security.AccessControl.FileSystemAccess
      Rule...}
      Path        : C:\work
      TotalACL    : 8

      It is assumed you will use this with the FileSystem provider.

      This version of the command uses a format file which is loaded "on the fly" so
      by default, information is presented as a nicely formatted table without the
      AccessRules property.

      .PARAMETER Path
      The path of the folder to analyze. The default is the current directory.

      .EXAMPLE
      PS C:\> Get-ACLInfo D:\Files
      Get acl data on the Files folder.

      .EXAMPLE
      PS C:\> dir e:\groups\data -recurse | where {$_.PSIsContainer} | get-aclinfo
      Get acl information for every folder under e:\groups\data.

      .NOTES
      NAME        :  Get-ACLInfo
      VERSION     :  0.9
      LAST UPDATED:  6/21/2012
      AUTHOR      :  Jeffery Hicks (http://jdhitsolutions.com/blog)

      .LINK
      Get-ACL

      .INPUTS
      Strings

      .OUTPUTS
      Custom object
  #>
  Param(
    [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
    [ValidateScript({Test-Path -Path $_})]
    [string[]]$Path = $PWD.Path
  )
  Begin {
    Write-Verbose -Message ('Starting {0}' -f $MyInvocation.MyCommand)
    $Xml = @'
<?xml version="1.0" encoding="utf-8"?>
<Configuration>
	<ViewDefinitions>
		<View>
			<Name>JDH.ACLInfo</Name>
			<ViewSelectedBy>
				<TypeName>JDH.ACLInfo</TypeName>
			</ViewSelectedBy>
			<TableControl>
				<TableHeaders>
					<TableColumnHeader>
						<Width>50</Width>
					</TableColumnHeader>
					<TableColumnHeader/>
					<TableColumnHeader>
						<Width>8</Width>
					</TableColumnHeader>
					<TableColumnHeader>
						<Width>9</Width>
					</TableColumnHeader>
					<TableColumnHeader>
						<Width>7</Width>
					</TableColumnHeader>
				</TableHeaders>
				<TableRowEntries>
					<TableRowEntry>
						<TableColumnItems>
							<TableColumnItem>
								<PropertyName>Path</PropertyName>
							</TableColumnItem>
							<TableColumnItem>
								<PropertyName>Owner</PropertyName>
							</TableColumnItem>
							<TableColumnItem>
								<PropertyName>TotalACL</PropertyName>
							</TableColumnItem>
							<TableColumnItem>
								<Propertyname>SystemACL</Propertyname>
							</TableColumnItem>
							<TableColumnItem>
								<Propertyname>UserACL</Propertyname>
							</TableColumnItem>
						</TableColumnItems>
					</TableRowEntry>
				</TableRowEntries>
			</TableControl>
		</View>
	</ViewDefinitions>
</Configuration>
'@
    $TempFile = [System.IO.Path]::GetTempFileName() + '.ps1xml'
    Write-Verbose -Message ('Creating {0}' -f $TempFile)
    $Xml | Out-File -FilePath $TempFile
    Write-Verbose -Message 'Updating Format Data'
    Update-FormatData -AppendPath $TempFile -ErrorAction SilentlyContinue
  }
  Process {
    Foreach ($Folder in $Path) {
      Write-Verbose -Message ('Getting ACL for {0}' -f $Folder)
      $ACL = Get-ACL -Path $Folder
      [regex]$Regex = '\w:\\\S+'
      $FolderPath = $Regex.Match($ACL.Path).Value
      $Access = $ACL.Access
      $SysACL= $Access | Where-Object {$_.IdentityReference -match 'BUILTIN|NT AUTHORITY|EVERYONE|CREATOR OWNER'}
      $NonSysACL = $Access | Where-Object {$_.IdentityReference -notmatch 'BUILTIN|NT AUTHORITY|EVERYONE|CREATOR OWNER'}
      $Obj = [PSCustomObject] @{
        Path = $FolderPath
        Owner = $ACL.Owner
        TotalACL = $Access.Count
        SystemACL = ($SysACL | Measure-Object).Count
        UserACL = ($NonSysACL | Measure-Object).Count
        AccessRules = $Access
      }
      $Obj.PSObject.TypeNames.Insert(0,'JDH.ACLInfo')
      $Obj
    }
  }
  End {
    if (Test-Path -Path $TempFile) {
      Write-Verbose -Message ('Deleting {0}' -f $TempFile)
      Remove-Item -Path $TempFile
    }
  }
}
