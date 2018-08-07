# =============================================================================
#  Created On:   2018/06/20 @ 12:37
#  Created By:   Alcha
#  Organization: HassleFree Solutions, LLC
#  Filename:     JournalTools.ps1
#  Description:  Contains functions for managing my journal and new entries.
# =============================================================================

$HeaderTime = Get-Date -UFormat "%Y-%m-%d @ %R"
$FutureEntryTemplate = @"
# Journal Entry for $HeaderTime

## What are you main tasks for today/what are you working on

## What technical problems are you tackling

## What am I grateful for

## How did I help someone today

## What did I do to further HassleFree Solutions
"@

$EntryTemplate = @"
# Journal Entry for $HeaderTime
"@

<#
.SYNOPSIS
  Creates a new journal entry for the day, or opens an existing one.

.DESCRIPTION
  If a journal entry for the day already exists, then it is opened in Visual
Studio Code. If one _doesn't_ exist, then it is created and opened in VSCode.

.EXAMPLE
  PS C:\> New-JournalEntry
#>
function New-JournalEntry {
  [CmdletBinding()]
  [Alias('New-Journal', 'newjournal', 'journal')]
  param ()

  $JournalDir = "E:\Writing\Journal"
  if (!(Test-Path $JournalDir)) { New-Item -Path $JournalDir -ItemType Directory -Force }

  $FileDir = Join-Path $JournalDir (Get-Date -Format 'yyyy-MM')
  if (!(Test-Path $FileDir)) { New-Item -Path $FileDir -ItemType Directory -Force }
  
  $Filename = Join-Path $FileDir ((Get-Date -Format 'yyyy-MM-dd') + '.md')

  if (Test-Path $Filename) { Write-Output "Opening existing entry." }
  else {
    New-Item -Path $Filename -ItemType File
    Out-File -FilePath $Filename -InputObject $EntryTemplate
    Write-Output "Creating new journal entry at $Filename"
  }

  code $JournalDir
  code $Filename -r
}
