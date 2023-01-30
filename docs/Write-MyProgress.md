Write-MyProgress
----------------
### Synopsis
Displays a progress bar within a Windows PowerShell command window.

---
### Description

The Write-Progress cmdlet displays a progress bar in a Windows PowerShell command window that depicts the status of a running command or script.

---
### Related Links
* [Source
https://github.com/Netboot-France/Write-MyProgress](Source
https://github.com/Netboot-France/Write-MyProgress.md)



---
### Examples
#### EXAMPLE 1
```PowerShell
$GetProcess = Get-Process
```
$Count = 0
$StartTime = Get-Date
foreach($Process in $GetProcess) {
$Count++
Write-MyProgress -StartTime $StartTime -Object $GetProcess -Count $Count

Write-Host "-> $($Process.ProcessName)"
Start-Sleep -Seconds 1
}
---
### Parameters
#### **Object**

Object use in your foreach processing






|Type     |Required|Position|PipelineInput|
|---------|--------|--------|-------------|
|`[Array]`|true    |1       |false        |



---
#### **StartTime**

StartTime of the foreach processing






|Type        |Required|Position|PipelineInput|
|------------|--------|--------|-------------|
|`[DateTime]`|true    |2       |false        |



---
#### **Count**

Foreach Count variable






|Type     |Required|Position|PipelineInput|
|---------|--------|--------|-------------|
|`[Int32]`|true    |3       |false        |



---
#### **Id**

Specifies an ID that distinguishes each progress bar from the others.






|Type     |Required|Position|PipelineInput|
|---------|--------|--------|-------------|
|`[Int32]`|false   |4       |false        |



---
#### **ParentId**

Specifies the parent activity of the current activity.






|Type     |Required|Position|PipelineInput|
|---------|--------|--------|-------------|
|`[Int32]`|false   |5       |false        |



---
### Syntax
```PowerShell
Write-MyProgress [-Object] <Array> [-StartTime] <DateTime> [-Count] <Int32> [[-Id] <Int32>] [[-ParentId] <Int32>] [<CommonParameters>]
```
---
### Notes
File Name   : Write-MyProgress.ps1
Author      : Woz
Date        : 2017-05-10
Last Update : 2023-01-14
Version     : 2.0.0
