Add-EnvPath
-----------
### Synopsis
Add a Folder to Environment Variable PATH

---
### Description

Add Folders to Environment Variable PATH for Machine, User or Process scope
And removes missing PATH locations

---
### Examples
#### EXAMPLE 1
```PowerShell
Add-EnvPath -Path 'C:\temp' -VariableTarget Machine
```

---
### Parameters
#### **Path**

Folder or Folders to add to PATH






|Type        |Required|Position|PipelineInput |
|------------|--------|--------|--------------|
|`[String[]]`|true    |1       |true (ByValue)|



---
#### **VariableTarget**

Which Env Path the directory gets added to.
Machine, User or Process



Valid Values:

* Process
* User
* Machine






|Type                         |Required|Position|PipelineInput|
|-----------------------------|--------|--------|-------------|
|`[EnvironmentVariableTarget]`|false   |2       |false        |



---
#### **PassThru**

Display updated PATH variable






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |



---
### Inputs
[String] - Folder Path, accepts multiple folders

---
### Outputs
* [String](https://learn.microsoft.com/en-us/dotnet/api/System.String)




---
### Syntax
```PowerShell
Add-EnvPath [-Path] <String[]> [[-VariableTarget] {Process | User | Machine}] [-PassThru] [<CommonParameters>]
```
---
