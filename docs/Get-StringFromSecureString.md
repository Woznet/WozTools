Get-StringFromSecureString
--------------------------
### Synopsis
Decrypt SecureString

---
### Description

Convert securestring to string with
[Microsoft.PowerShell.DesiredStateConfiguration.Internal.DscClassCache]::GetStringFromSecureString

---
### Examples
#### EXAMPLE 1
```PowerShell
$test = Get-Credential # Username - Tester, Password test1
$test.Password | Get-StringFromSecureString
```

#### EXAMPLE 2
```PowerShell
Get-StringFromSecureString -SecureString $test.Password
```

---
### Parameters
#### **SecureString**




|Type            |Required|Position|PipelineInput                 |
|----------------|--------|--------|------------------------------|
|`[SecureString]`|true    |1       |true (ByValue, ByPropertyName)|



---
### Inputs
securestring

---
### Outputs
* [String](https://learn.microsoft.com/en-us/dotnet/api/System.String)




---
### Syntax
```PowerShell
Get-StringFromSecureString [-SecureString] <SecureString> [<CommonParameters>]
```
---
