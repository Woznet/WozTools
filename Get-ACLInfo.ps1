Function Get-ACLInfo {
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
  [cmdletbinding()]
  Param(
    [Parameter(Position=0,ValueFromPipeline,ValueFromPipelineByPropertyName)]
    [ValidateScript({Test-Path -Path $_})]
    [string[]]$Path = '.'
  )
  Begin {
    Write-Verbose -Message ('Starting {0}' -f $myinvocation.mycommand)
    #create a format file on the fly
    $xml = @'
<?xml version="1.0" encoding="utf-8" ?>
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
    #create a temp file
    $tmpfile = [IO.Path]::GetTempFileName()
    #add the necessary file extension
    $tmpfile += '.ps1xml'
    #pipe the xml text to the temp file
    Write-Verbose -Message ('Creating {0}' -f $tmpfile)
    $xml | Out-File -FilePath $tmpfile
    <#
        update format data. I'm setting error action to SilentlyContinue
        because everytime you run the function it creates a new temp file
        but Update-FormatData tries to reload all the format files it
        knows about in the current session, which includes previous versions
        of this file which have already been deleted.
    #>
    Write-Verbose -Message 'Updating format data'
    Update-FormatData -AppendPath $tmpfile -ErrorAction SilentlyContinue
  } #Begin
  Process {
    Foreach ($folder in $path) {
      Write-Verbose -Message ('Getting ACL for {0}' -f $folder)
      #get the folder ACL
      $acl= Get-ACL -Path $path
      #a regex to get a file path
      [regex]$regex = '\w:\\\S+'
      #get full path from ACL object
      $folderpath = $regex.match($acl.path).Value
      #get Access rules
      $access = $acl.Access
      #get builtin and system ACLS
      $sysACL= $access | Where-Object {$_.identityreference -match 'BUILTIN|NT AUTHORITY|EVERYONE|CREATOR OWNER'}
      #get non builtin and system ACLS
      $nonSysACL = $access | Where-Object {$_.identityreference -notmatch 'BUILTIN|NT AUTHORITY|EVERYONE|CREATOR OWNER'}
      #grab some properties and add them to a hash table.
      $hash = @{
        Path = $folderpath
        Owner = $acl.Owner
        TotalACL = $access.count
        SystemACL = ($sysACL | measure-object).Count
        UserACL = ($nonSysACL | measure-object).Count
        AccessRules = $access
      }
      #write a new object to the pipeline
      $obj = New-object -TypeName PSObject -Property $hash
      #add a type name for the format file
      $obj.PSObject.TypeNames.Insert(0,'JDH.ACLInfo')
      $obj
    } #foreach
  } #Process
  End {
    #delete the temp file if it still exists
    if (Test-Path -Path $tmpfile) {
      Write-Verbose -Message ('Deleting {0}' -f $tmpfile)
      Remove-Item -Path $tmpFile
    }
    Write-Verbose -Message ('Ending {0}' -f $myinvocation.mycommand)
  } #end
}