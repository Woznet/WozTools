Get-ACLInfo
-----------
### Synopsis
Get a summary of a folder ACL

---
### Description

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
AccessRules : {System.Security.AccessControl.FileSystemAccessRule,
System.Security.AccessControl.FileSystemAccessRule,
System.Security.AccessControl.FileSystemAccessRule,
System.Security.AccessControl.FileSystemAccessRule...}
Path        : C:\work
TotalACL    : 8

It is assumed you will use this with the FileSystem provider.

This version of the command uses a format file which is loaded "on the fly" so by default,
information is presented as a nicely formatted table without the AccessRules property.

---
### Related Links
* [Get-ACL](https://docs.microsoft.com/powershell/module/Microsoft.PowerShell.Security/Get-Acl)



---
### Examples
#### EXAMPLE 1
```PowerShell
Get-ACLInfo D:\Files
Get acl data on the Files folder.
```

#### EXAMPLE 2
```PowerShell
Get-ChildItem e:\groups\data -Recurse | Where-Object {$_.PSIsContainer} | Get-ACLInfo
Get acl information for every folder under e:\groups\data.
```

---
### Parameters
#### **Path**

The path of the folder to analyze. The default is the current directory.






|Type        |Required|Position|PipelineInput                 |
|------------|--------|--------|------------------------------|
|`[String[]]`|false   |1       |true (ByValue, ByPropertyName)|



---
### Inputs
Strings

---
### Outputs
* Custom object




---
### Syntax
```PowerShell
Get-ACLInfo [[-Path] <String[]>] [<CommonParameters>]
```
---
### Notes
NAME        :  Get-ACLInfo
VERSION     :  0.9
LAST UPDATED:  6/21/2012
AUTHOR      :  Jeffery Hicks (http://jdhitsolutions.com/blog)
