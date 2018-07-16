---
schema: 2.0.0
external help file: Remove-TrailingWhitespace-Help.xml
---
# Remove-TrailingWhitespace

## SYNOPSIS

Removes the trailing whitespace for each line of a given file.

## DESCRIPTION

Removes all trailing whitespace from each line in a given file or every file in
a given directory.

## PARAMETERS

### FileDir

The path to the file or directory of files you wish to remove the trailing
whitespace from.

## EXAMPLES

### Example 1

Removes the trailing whitespace from the `Tron-Commands.ps1` script:

```PowerShell
Remove-TrailingWhitespace -FileDir '.\Tron-Commands.ps1'
```

### Example 2

Removes the trailing whitespace from all PowerShell scripts in the development
folder:

```PowerShell
Remove-TrailingWhitespace 'E:\Development\PowerShell\Scripts'
```