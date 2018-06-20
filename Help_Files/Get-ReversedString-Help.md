---
schema: 2.0.0
external help file: Get-ReversedString-Help.xml
---

# Get-ReversedString

## SYNOPSIS

Reverses the provided input String(s) and returns it/them.

## SYNTAX

``` PowerShell
Get-ReversedString [-InputStr] <String[]> [<CommonParameters>]
```

## DESCRIPTION

A simple command for reversing a String in PowerShell in order to show some
basics of how to use the language.

## EXAMPLES

### Example 1

This example will simply reverse the string "Hello, World!" to "!dlroW ,olleH".

```PowerShell
Get-ReversedString -Input "Hello, World!"
```

## PARAMETERS

### -InputStr

The string to be reversed.```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### String

If a single String was provided to the command then only a single String is
returned.

### String[]

If a String array is provided to the command, then an array containing the
reversed results is returned.

## NOTES

## RELATED LINKS
