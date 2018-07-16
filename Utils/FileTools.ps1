# =============================================================================
#  Created On:   2018/06/20 @ 12:52
#  Created By:   Alcha
#  Organization: HassleFree Solutions, LLC
#  Filename:     FileTools.ps1
#  Description:  Contains various functions for modifying/working with files.
# =============================================================================

<#
.SYNOPSIS
  Updates/replaces the given character(s) in all the filenames in the given path.

.DESCRIPTION
  Updates/replaces the given character(s) for the new given character in all the
filenames present in the given path. If the Recurse switch parameter is
provided, then every file in every subdirectory is updated as well.

.PARAMETER Path
  The path to where the files you wish to udpate are.

.PARAMETER OldValues
  The character(s) in the filenames that you wish to replace.

.PARAMETER NewValue
  The character(s) in the filenames that you wish to be used as the new filename
value.

.PARAMETER Recurse
  Determines if you wish to update all files in subdirectories as well as the
provided one.

.EXAMPLE
  PS C:\> Update-FilenameCharacter -Path C:\Development -OldValue " " -New "_"
Updates all the files in the C:\Development directory (none of the
subdirectories) so that any filenames with a space, has the space replaced with
an underscore.

.EXAMPLE
  PS C:\> Update-Filename -Path C:\Development -Old " " -New "." -Recurse
Updates all files in the C:\Development directory, and every subdirectory within
it, so that any filenames with a space present has the space replaced with a
period.

.EXAMPLE
  PS C:\> Update-Filename -Path C:\Development -Old " ", "_" -New "-" -Recurse
Updates all files in the C:\Development directory, and every subdirectory within
it, so that any filenames with a space or underscore present has that character
replaced with a hyphen.
#>
function Update-FilenameCharacter {
  [CmdletBinding()]
  [Alias('Update-Filename', 'Replace-FilenameCharacter')]
  param (
    [Parameter(Position = 0)]
    [Alias('Dir', 'Directory')]
    [String]
    $Path = ".",

    [Parameter(Position = 1)]
    [Alias('Old')]
    [String]
    $OldValue = " ",

    [Parameter(Position = 2)]
    [Alias('New')]
    [String]
    $NewValue = "_",

    [Parameter(Position = 3)]
    [Switch]
    $Recurse
  )

  if ($Recurse.IsPresent) {
    $Files = Get-ChildItem -Path $Path -Recurse
  } else {
    $Files = Get-ChildItem -Path $Path
  }

  foreach ($File in $Files) {
    $OldName = $File.FullName
    foreach ($OldValue in $OldValues) {
      $NewName = $OldName
      if ($OldName -like "*$OldValue*") {
        $NewName = $OldName -replace $OldValue, $NewValue
      }

      if ($NewName -ne $OldName) {
        Move-Item $File.FullName $NewName

        Write-Output "OldName = $OldName"
        Write-Output "NewName = $NewName`n"
      }
    }
  }
}

<#
.SYNOPSIS
  Trims every line of the files in the given directory.

.DESCRIPTION
  Iterates through every file with a .ps1, .psd1, .psm1, .txt, or .js extension
in the given directory and then reads it line by line. Each line then has
the Trim() function called on it, in order to remove any excess whitespace.

.PARAMETER Path
  The directory containing the files you wish to cleanup.

.PARAMETER FileTypes
  An array of strings containing the file types to filter for before cleaning.
If this parameter is left empty, the following defaults are used: '*.ps1',
'*.psd1', '*.psm1', '*.txt', '*.js', '*.json'

.PARAMETER Recurse
  Determines if you wish to clean all files in subdirectories as well as the
provided one.

.EXAMPLE
  PS C:\> Remove-ExcessWhitespace -Path C:\Development\Projects\Gamgee

.EXAMPLE
  PS C:\Development\Projects\> rew .\Gamgee -Recurse
Removes all the excess whitespace from each file within the
C:\Development\Projects\Gamgee directory and every subdirectory within it.

.EXAMPLE
  PS C:\> rew C:\Development\Projects\Gamgee -FileTypes '*.txt' -Recurse
Removes all the excess whitespace from each .txt file within the given directory
and every subdirectory within it.
#>
function Remove-ExcessWhitespace {
  [CmdletBinding()]
  [Alias('Clean-Whitespace', 'rew', 'Clean-Files')]
  param (
    [Parameter(Mandatory = $true,
      ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true,
      ValueFromRemainingArguments = $true,
      Position = 0,
      HelpMessage = 'Where are the files you wish to clean up?')]
    [ValidateScript( { return Test-Path $_ })]
    [Alias('FilePath', 'FileDir', 'Dir')]
    [System.String]
    $Path,

    [Parameter(Mandatory = $false, Position = 1,
      HelpMessage = 'What file types do you wish to clean?')]
    [System.String[]]
    $FileTypes,

    [Parameter(Mandatory = $false, Position = 2)]
    [Switch]
    $Recurse
  )

  begin {
    if ($FileTypes.Length -eq 0) {
      $FileTypes = @('*.ps1', '*.psd1', '*.psm1', '*.txt', '*.js', '*.json')
    }

    if ($Recurse.IsPresent) {
      $ScriptFiles = Get-ChildItem -Path $Path -Include $FileTypes -Recurse
    } else {
      $ScriptFiles = Get-ChildItem -Path $Path -Include $FileTypes
    }
  }

  process {
    foreach ($Script in $ScriptFiles) {
      $Content = Get-Content $Script.FullName
      Write-Verbose "Processing $Script..."

      for ($x = 0; $x -lt $Content.Length; $x++) {
        $Line = $Content[$x].ToString()
        $Content[$x] = $Line.TrimEnd() + "`n"
      }

      Out-File -FilePath $Script.FullName -InputObject $Content -Encoding 'utf8' -NoNewline
    }
  }

  end {
    Write-Verbose "Completed processing $($ScriptFiles.Length) files..."
  }
}

<#
.SYNOPSIS
  Reads the BOM of the given file(s) and tries to determine the file encoding.

.DESCRIPTION
  Reads the BOM of the given file(s) and tries to determine the file encoding.
If the encoding cannot be determined, it is set as "unknown". For every path
provided, a PSCustomObject is returned containing two values, the full FilePath,
and the encoding. (e.g. @{"File" = C:\Temp\Test.txt; "Encoding" = 'UTF8'})

.PARAMETER Path
  The path(s) to the file you wish to determine the encoding of as a String
object.

.PARAMETER FileInfo
  The path(s) to the file you wish to determine the encoding of as a FileInfo
object.

.EXAMPLE
  PS C:\> Get-FileEncoding -Path 'C:\Temp\Test.txt'
Gets the encoding of the Test.txt file and returns the encoding like so:
File             Encoding
----             --------
C:\Temp\Test.txt UTF8
#>
function Get-FileEncoding {
  [CmdletBinding(DefaultParameterSetName = 'PathSet')]
  [OutputType([PSCustomObject])]
  param (
    [Parameter(ParameterSetName = 'PathSet',
      Mandatory = $true,
      ValueFromPipeline = $true,
      Position = 0)]
    [System.String[]]
    $Path,

    [Parameter(ParameterSetName = 'FileInfoSet',
      Mandatory = $true,
      ValueFromPipeline = $true,
      Position = 0)]
    [System.IO.FileInfo[]]
    $FileInfo
  )

  begin {
    if ($Path) {
      $FilePaths = Get-ChildItem $Path | ForEach-Object FullName
    } else {
      #$FileInfo
      $FilePaths = $FileInfo.FullName
    }

    if (!($FilePaths)) {
      throw "No filepaths found."
    }
  }

  process {
    foreach ($FilePath in $FilePaths) {
      [System.Byte[]]$Byte = Get-Content -Encoding byte -ReadCount 4 -TotalCount 4 -Path $FilePath

      if ($Byte[0] -eq 0xef -and $Byte[1] -eq 0xbb -and $Byte[2] -eq 0xbf) {
        # EF BB BF	(UTF8)
        $Encoding = 'UTF8'
      } elseif ($Byte[0] -eq 0xfe -and $Byte[1] -eq 0xff) {
        # FE FF		(UTF-16 Big-Endian)
        $Encoding = 'Unicode UTF-16 Big-Endian'
      } elseif ($Byte[0] -eq 0xff -and $Byte[1] -eq 0xfe) {
        # FF FE		(UTF-16 Little-Endian)
        $Encoding = 'Unicode UTF-16 Little-Endian'
      } elseif ($Byte[0] -eq 0 -and $Byte[1] -eq 0 -and $Byte[2] -eq 0xfe -and $Byte[3] -eq 0xff) {
        # 00 00 FE FF	(UTF32 Big-Endian)
        $Encoding = 'UTF32 Big-Endian'
      } elseif ($Byte[0] -eq 0xfe -and $Byte[1] -eq 0xff -and $Byte[2] -eq 0 -and $Byte[3] -eq 0) {
        # FE FF 00 00	(UTF32 Little-Endian)
        $Encoding = 'UTF32 Little-Endian'
      } elseif ($Byte[0] -eq 0x2b -and $Byte[1] -eq 0x2f -and $Byte[2] -eq 0x76 -and ($Byte[3] -eq 0x38 -or $Byte[3] -eq 0x39 -or $Byte[3] -eq 0x2b -or $Byte[3] -eq 0x2f)) {
        # 2B 2F 76 (38 | 38 | 2B | 2F)
        $Encoding = 'UTF7'
      } elseif ($Byte[0] -eq 0xf7 -and $Byte[1] -eq 0x64 -and $Byte[2] -eq 0x4c) {
        # F7 64 4C	(UTF-1)
        $Encoding = 'UTF-1'
      } elseif ($Byte[0] -eq 0xdd -and $Byte[1] -eq 0x73 -and $Byte[2] -eq 0x66 -and $Byte[3] -eq 0x73) {
        # DD 73 66 73	(UTF-EBCDIC)
        $Encoding = 'UTF-EBCDIC'
      } elseif ($Byte[0] -eq 0x0e -and $Byte[1] -eq 0xfe -and $Byte[2] -eq 0xff) {
        # 0E FE FF	(SCSU)
        $Encoding = 'SCSU'
      } elseif ($Byte[0] -eq 0xfb -and $Byte[1] -eq 0xee -and $Byte[2] -eq 0x28) {
        # FB EE 28 	(BOCU-1)
        $Encoding = 'BOCU-1'
      } elseif ($Byte[0] -eq 0x84 -and $Byte[1] -eq 0x31 -and $Byte[2] -eq 0x95 -and $Byte[3] -eq 0x33) {
        # 84 31 95 33	(GB-18030)
        $Encoding = 'GB-18030'
      } else {
        $Encoding = 'Unknown'
      }

      return [PSCustomObject]@{
        "File" = $FilePath; "Encoding" = $Encoding
      }
    }
  }
}
