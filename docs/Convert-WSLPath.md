Convert-WSLPath
---------------
### Synopsis
Covert a path in between the Windows and the WSL path formats

---
### Description

Use "wslpath" to convert the path

---
### Examples
#### EXAMPLE 1
```PowerShell
# Convert Windows Path to WSL
Convert-WSLPath -Path 'C:\temp\'
```

#### EXAMPLE 2
```PowerShell
# Convert WSL Path to Windows
Convert-WSLPath -Path '/usr/bin/ssh' -ToWindows
```

---
### Parameters
#### **Path**

Path to be converted






|Type        |Required|Position|PipelineInput |
|------------|--------|--------|--------------|
|`[String[]]`|true    |named   |true (ByValue)|



---
#### **ToWindows**

Convert Path from WSL format to Windows format






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |



---
#### **ToWSL**

Convert Path from Windows format to WSL format - Default






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |



---
### Syntax
```PowerShell
Convert-WSLPath -Path <String[]> [-ToWSL] [<CommonParameters>]
```
```PowerShell
Convert-WSLPath -Path <String[]> [-ToWindows] [<CommonParameters>]
```
---
