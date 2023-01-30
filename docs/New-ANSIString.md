New-ANSIString
--------------
### Synopsis
Generate ANSI escape code string for outputing text with color

---
### Description

Create ANSI color escape code using a RGB color value

---
### Examples
#### EXAMPLE 1
```PowerShell
# Create variable with desired color
$ANSI1 = New-ANSIString
# Create variable to reset ANSI effects
$Reset = New-ANSIString -Reset
# String getting colored
$Text = 'This is a test.  More testing... and testing'
```
'{0}{1}{2}' -f $ANSI1,$Text,$Reset
#### EXAMPLE 2
```PowerShell
# Create variable with desired foreground color
$ANSIFG1 = New-ANSIString -Red 55 -Green 120 -Blue 190 -Foreground
# Create variable with desired background color
$ANSIBG1 = New-ANSIString -Green 100 -Background
# Create variable to reset ANSI effects
$Reset = New-ANSIString -Reset
# String getting colored
$Text = 'This is a test.  More testing... and testing'
$Text2 = 'More and more and more!'
```
'{0}{1}{2}{3}{4}' -f $ANSIFG1,$Text,$ANSIBG1,$Text2,$Reset
---
### Parameters
#### **Red**

Param1 help description






|Type     |Required|Position|PipelineInput|
|---------|--------|--------|-------------|
|`[Int32]`|false   |1       |false        |



---
#### **Green**

Param2 help description






|Type     |Required|Position|PipelineInput|
|---------|--------|--------|-------------|
|`[Int32]`|false   |2       |false        |



---
#### **Blue**

Param3 help description






|Type     |Required|Position|PipelineInput|
|---------|--------|--------|-------------|
|`[Int32]`|false   |3       |false        |



---
#### **Foreground**

Param4 help description






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |



---
#### **Background**

Param5 help description






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |



---
#### **Reset**

Param6 help description






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |



---
### Outputs
* [string]




---
### Syntax
```PowerShell
New-ANSIString [[-Red] <Int32>] [[-Green] <Int32>] [[-Blue] <Int32>] [-Foreground] [<CommonParameters>]
```
```PowerShell
New-ANSIString [[-Red] <Int32>] [[-Green] <Int32>] [[-Blue] <Int32>] [-Background] [<CommonParameters>]
```
```PowerShell
New-ANSIString [-Reset] [<CommonParameters>]
```
---
### Notes
FYI: Remeber to reset the text style after every stylized text, otherwise the ANSI effects will continue to be applied to all that get output later.
