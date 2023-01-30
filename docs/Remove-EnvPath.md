Remove-EnvPath
--------------
### Synopsis
Remove-EnvPath [-Path] <string[]> [[-VariableTarget] <EnvironmentVariableTarget>] [<CommonParameters>]

---
### Description



---
### Parameters
#### **Path**





|Type               |Required|Position|PipelineInput|
|-------------------|--------|--------|-------------|
|`[System.String[]]`|false   |named   |False        |



---
#### **VariableTarget**


Valid Values:

* Process
* User
* Machine






|Type                                |Required|Position|PipelineInput|
|------------------------------------|--------|--------|-------------|
|`[System.EnvironmentVariableTarget]`|false   |named   |False        |



---
### Inputs
System.String[]

---
### Outputs
* [Object](https://learn.microsoft.com/en-us/dotnet/api/System.Object)




---
### Syntax
```PowerShell
Remove-EnvPath [-Path] <System.String[]> [[-VariableTarget] <System.EnvironmentVariableTarget>] [<CommonParameters>]
```
---
