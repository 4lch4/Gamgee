# =============================================================================
#  Created On:   2018/06/20 @ 12:37
#  Created By:   Alcha
#  Organization: HassleFree Solutions, LLC
#  Filename:     JournalTools.ps1
#  Description:  Contains functions for managing my journal and new entries.
# =============================================================================

$HeaderTime = Get-Date -UFormat "%Y-%m-%d @ %R"
$EntryTemplate = @"
# Journal Entry for $HeaderTime

## What are you main tasks for today/what are you working on

## What technical problems are you tackling

## What am I grateful for

## How did I help someone today

## What did I do to further HassleFree Solutions
"@

function New-JournalEntry {
  [CmdletBinding()]
  [Alias('New-Journal', 'newjournal', 'journal')]
  param ()

  $JournalDir = "E:\Writing\Journal"
  $FileDir = Join-Path $JournalDir (Get-Date -Format 'yyyy-MM')
  $Filename = Join-Path $FileDir ((Get-Date -Format 'yyyy-MM-dd') + '.md')

  if (Test-Path $Filename) {
    Write-Host "Opening existing entry."
  }
  else {
    New-Item -Path $Filename -ItemType File
    Out-File -FilePath $Filename -InputObject $EntryTemplate
    Write-Host "Creating new journal entry at $Filename"
  }
  
  code $JournalDir
  code $Filename -r
}
