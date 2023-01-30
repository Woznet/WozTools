Get-FunctionCode
----------------
### Synopsis
Get the code of a powershell function or filter

---
### Description
---
### Examples
#### EXAMPLE 1
```PowerShell
# Gets the code for New-Guid
Get-FunctionCode New-Guid
```

#### EXAMPLE 2
```PowerShell
# Outputs the code for New-Guid into a new PowerShell ISE Tab
Get-FunctionCode -Function New-Guid -OutISE
```

#### EXAMPLE 3
```PowerShell
# Gets the code for New-Guid and saves it to V:\temp\New-Guid.ps1
Get-FunctionCode New-Guid -OutFile V:\temp\New-Guid.ps1
```

#### EXAMPLE 4
```PowerShell
# Outputs the code for New-Guid into a new PowerShell ISE Tab and saves it to V:\temp\New-Guid.ps1
Get-FunctionCode -Function New-Guid -OutISE -OutFile V:\temp\New-Guid.ps1
```

---
### Parameters
#### **Function**

Function Name






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|true    |1       |false        |



---
#### **OutISE**




|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |



---
#### **OutFile**




|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |2       |false        |



---
### Syntax
```PowerShell
Get-FunctionCode [-Function] <String> [-OutISE] [[-OutFile] <String>] [<CommonParameters>]
```
---
