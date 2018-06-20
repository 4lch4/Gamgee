function Update-FilenameCharacter {
  [CmdletBinding()]
	param (
		[Parameter(Position = 0)]
		[Alias('Dir', 'Directory')]
		[String]
		$Path = ".",
		
		[Parameter(Position = 1)]
		[String[]]
		$OldValues = " ",
		
		[Parameter(Position = 2)]
		[String]
		$NewValue = "_",
		
		[Parameter(Position = 3)]
		[Switch]
		$Recurse
	)
	
	if ($Recurse.IsPresent) {
		$Files = Get-ChildItem -Path $Path -Recurse
	}
	else {
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

# .EXTERNALHELP .\Remove-TrailingWhitespace-Help.xml
function Remove-TrailingWhitespace {
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