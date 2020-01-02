---
external help file: loader-help.xml
Module Name: Wozlab
online version:
schema: 2.0.0
---

# Restart-Process

## SYNOPSIS
Function to restart process(es)

## SYNTAX

```
Restart-Process [[-process] <Object>] [<CommonParameters>]
```

## DESCRIPTION
Takes input via pipeline from Get-Process and restarts the process(es).
If there is more than one instance of the same application:
Then the function prompts to select the instance of the application to restart by index.
An index of -1 stops all instances of the application and
restarts the first.

## EXAMPLES

### EXAMPLE 1
```
#start 2 instances of notepad and restart the second
```

notepad
notepad
Get-Process notepad | Restart-Process
#enter index 2 when prompted

### EXAMPLE 2
```
#start 3 instances of notepad restart the first and stop the others
```

notepad
notepad
notepad
Get-Process notepad | Restart-Process
#enter index -1 when prompted

### EXAMPLE 3
```
#start notepad and calc and restart
```

Get-Process notepad,calc | Restart-Process

## PARAMETERS

### -process
Process(es) to restart piped in via Get-Process

```yaml
Type: System.Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
