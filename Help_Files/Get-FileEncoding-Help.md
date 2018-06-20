---
schema: 2.0.0
external help file: Get-FileEncoding-Help.xml
---
# Get-FileEncoding

## SYNOPSIS

Gets the file encoding from the provided file.

## DESCRIPTION

Determines the encoding by looking at the Byte Order Mark (BOM). Based on a port
of C# code from [this post](http://www.west-wind.com/Weblog/posts/197245.aspx).

## PARAMETERS

### Path

The path to the file you wish to determine the encoding of.

### FileInfo

The FileInfo object that represents the file of interest.

## EXAMPLES

### Example 1

This example will get all the files within the current directory that are not
encoded with ASCII.

```PowerShell
Get-ChildItem *.ps1 | Select-Object FullName, `
  @{n='Encoding';e={Get-FileEncoding $_.FullName}} | `
  Where-Object {$_.Encoding -ne 'ASCII'}
```

### Example 2

This example is the same as Example 1, however it fixes encoding using the
Set-Content cmdlet.

```PowerShell
Get-ChildItem *.ps1 | `
  Select-Object FullName, @{n='Encoding';e={Get-FileEncoding $_.FullName}} | `
  Where-Object {$_.Encoding -ne 'ASCII'} | `
  ForEach-Object {(Get-Content $_.FullName) | Set-Content $_.FullName -Encoding ASCII}
```
