ConvertTo-TitleCase
-------------------
### Synopsis
Convert Text to TitleCase

---
### Description
---
### Examples
#### EXAMPLE 1
```PowerShell
ConvertTo-TitleCase -Text 'testing'
```

#### EXAMPLE 2
```PowerShell
Get-ChildItem -Path D:\temp | Select-Object -ExpandProperty Name | ConvertTo-TitleCase
```

---
### Parameters
#### **Text**




|Type        |Required|Position|PipelineInput |
|------------|--------|--------|--------------|
|`[String[]]`|true    |1       |true (ByValue)|



---
### Inputs
System.String

---
### Outputs
* [String](https://learn.microsoft.com/en-us/dotnet/api/System.String)




---
### Syntax
```PowerShell
ConvertTo-TitleCase [-Text] <String[]> [<CommonParameters>]
```
---
