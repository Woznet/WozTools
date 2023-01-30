Add-Font
--------
### Synopsis
Add fonts to system

---
### Description

Install a font from file path using CSharp code, compatitable fonts are available for use within the console font list.

---
### Examples
#### EXAMPLE 1
```PowerShell
Add-Font -Path C:\temp\mononoki-nerdfont.ttf
```

---
### Parameters
#### **Path**

Path of Font File, can accept multiple font files
Supported File Types - .ttc, .ttf, .fnt, .otf, .fon






|Type        |Required|Position|PipelineInput|
|------------|--------|--------|-------------|
|`[String[]]`|true    |1       |false        |



---
#### **Remove**




|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |



---
### Syntax
```PowerShell
Add-Font [-Path] <String[]> [-Remove] [<CommonParameters>]
```
---
### Notes
Administartor privileges are required
