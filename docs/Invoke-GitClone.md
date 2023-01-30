Invoke-GitClone
---------------
### Synopsis
Clone a Git Repository

---
### Description
---
### Examples
#### EXAMPLE 1
```PowerShell
Invoke-GitClone -Repo https://github.com/Woznet/WozTools.git -Path D:\git\repos
```

---
### Parameters
#### **Repo**

Git Repository to Clone






|Type        |Required|Position|PipelineInput |
|------------|--------|--------|--------------|
|`[String[]]`|true    |1       |true (ByValue)|



---
#### **Path**

Location the repository folder will be saved to






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |2       |false        |



---
### Syntax
```PowerShell
Invoke-GitClone [-Repo] <String[]> [[-Path] <String>] [<CommonParameters>]
```
---
