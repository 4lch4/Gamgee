---
schema: 2.0.0
external help file: New-NodeModule-Help.xml
---
# New-NodeModule

## SYNOPSIS

Creates a new Node.js module using some preferred default values.

## DESCRIPTION
  
Creates a new Node module using some default values that I prefer in each of
my projects. Such as license type, the license file itself, etc. Returns true or
false if the module was created without problem. If false is returned, there
should also be some more information regarding *why* it failed.

## PARAMETERS

### ModuleName

The name of the new module you wish to create.

### ModulePath

The path of where you would like the module to be created. If none is
provided, D:\Development\Projects\NodeJS_Packages is used.

### OpenInVSCode

A switch parameter indicating if you'd like to open the newly created module
in Visual Studio Code. Defaults to $true.

## EXAMPLES

### Create Test Module 1

This will create a new module called Test Module 1 and place the new files for
it in C:\Temp\Test Module 1\.

```PowerShell
PS C:\> New-NodeModule -ModuleName 'Test Module 1' -ModulePath C:\Temp
```

### Custom Location w/out Code

This will create a new module called outside-cli so long as there isn't already
a file or directory with the name in C:\Dev\node_packages\. Adds all new files
to the newly created C:\Dev\node_packages\outside-cli directory, and on
completion, does *not* open the directory in Visual Studio Code.

```PowerShell
PS C:\> New-NodeModule outside-cli C:\Dev\node_packages $false
```

### New Module w/out Code

This will create a new module called temp-cli-test so long as there isn't
already a file or directory with the name in D:\Dev\Projects\NodeJS_Packages
and adds all new files to the newly created temp-cli-test directory, and on
completion, does *not* open the directory in Visual Studio Code.

```PowerShell
PS C:\> New-NodeModule temp-cli-test -Open $False
```

## NOTES

The easiest way to add this to your profile is to copy this file to your
WindowsPowerShell profile path ($ENV:HOMEPATH\Documents\WindowsPowerShell) and
then add the following line somewhere in your Profile.ps1 file (if you're unsure
what this is, see http://bit.ly/poshprofiles):

. $ENV:HOMEDRIVE\$ENV:HOMEPATH\Documents\WindowsPowerShell\New-NodeModule.ps1