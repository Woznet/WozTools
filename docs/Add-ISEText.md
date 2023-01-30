Add-ISEText
-----------
### Synopsis
Add text to the bottom of current ISE File

---
### Description
---
### Examples
#### EXAMPLE 1
```PowerShell
Add-ISEText -InputObject (Get-Content $profile)
```

#### EXAMPLE 2
```PowerShell
'happy','go','lucky' | Add-ISEText
```

#### EXAMPLE 3
```PowerShell
Get-ChildItem 'C:\temp' | Add-ISEText
```

---
### Parameters
#### **InputObject**

Text to insert






|Type          |Required|Position|PipelineInput |
|--------------|--------|--------|--------------|
|`[PSObject[]]`|true    |1       |true (ByValue)|



---
### Syntax
```PowerShell
Add-ISEText [-InputObject] <PSObject[]> [<CommonParameters>]
```
---
