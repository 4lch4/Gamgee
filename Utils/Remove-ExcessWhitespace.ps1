# =============================================================================
#  Created on:   6/8/2018 @ 17:48
#  Created by:   Alcha
#  Organization: HassleFree Solutions, LLC
#  Filename:     Remove-ExcessWhitespace.ps1
# =============================================================================

# .EXTERNALHELP .\Remove-ExcessWhitespace-Help.xml
function Remove-ExcessWhitespace {
  [CmdletBinding()]
  param (
    [ValidateScript( { return Test-Path $_ })]
    [System.IO.FileInfo]$FileDir
  )

  $ScriptFiles = Get-ChildItem -Path $FileDir -Filter '*.ps1' -Recurse
  $ProcessCount = 0

  foreach ($Script in $ScriptFiles) {
    $Content = Get-Content $Script.FullName
    Write-Verbose "Processing $Script..."

    for ($x = 0; $x -lt $Content.Length; $x++) {
      $Line = $Content[$x].ToString()
      $Content[$x] = $Line.TrimEnd()
    }

    $ProcessCount++
    Out-File -FilePath $Script.FullName -InputObject $Content
  }

  Write-Verbose "Completed processing $ProcessCount files..."
}
