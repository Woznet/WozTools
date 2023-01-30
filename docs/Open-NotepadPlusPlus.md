Open-NotepadPlusPlus
--------------------
### Synopsis
Open file in NotepadPlusPlus

---
### Description
---
### Examples
#### EXAMPLE 1
```PowerShell
Open-NotepadPlusPlus -Path .\Path\of\a\File.ps1
```

#### EXAMPLE 2
```PowerShell
### BAD EXAMPLE - funciton is stupid and will open all resolved paths
gci .\* | Open-NotepadPlusPlus
```

---
### Parameters
#### **Path**

[Parameter(ValueFromPipeline)]






|Type        |Required|Position|PipelineInput                 |
|------------|--------|--------|------------------------------|
|`[String[]]`|false   |1       |true (ByValue, ByPropertyName)|



---
### Inputs
FileInfo, String

---
### Outputs
* none




---
### Syntax
```PowerShell
Open-NotepadPlusPlus [[-Path] <String[]>] [<CommonParameters>]
```
---
### Notes
assumes notepad++.exe is within $env:PATH
Install with chocolatey if needed
