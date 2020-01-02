---
external help file: loader-help.xml
Module Name: Wozlab
online version:
schema: 2.0.0
---

# Get-ACLInfo

## SYNOPSIS
Get a summary of a folder ACL

## SYNTAX

```
Get-ACLInfo [[-Path] <String[]>] [<CommonParameters>]
```

## DESCRIPTION
This command will examine the ACL of a given folder and create a custom object.
The object will include a count of access rules based on the identity
reference.
Any ACL that belongs to a builtin or system account, or Everyone and
Creator Owner, will be counted as a SystemACL.
Everything else will be counted
as a UserACL.
You might use this information to identify folders or files where
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

## EXAMPLES

### EXAMPLE 1
```
Get-ACLInfo D:\Files
```

Get acl data on the Files folder.

### EXAMPLE 2
```
dir e:\groups\data -recurse | where {$_.PSIsContainer} | get-aclinfo
```

Get acl information for every folder under e:\groups\data.

## PARAMETERS

### -Path
The path of the folder to analyze.
The default is the current directory.

```yaml
Type: System.String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: .
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Strings
## OUTPUTS

### Custom object
## NOTES
NAME        :  Get-ACLInfo
VERSION     :  0.9
LAST UPDATED:  6/21/2012
AUTHOR      :  Jeffery Hicks (http://jdhitsolutions.com/blog)

## RELATED LINKS

[Get-ACL]()

