<#	
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2016 v5.3.130
	 Created on:   	11/10/2016 10:49
	 Created by:   	DevinL
	 Organization: 	SAPIEN Technologies, Inc.
	 Filename:     	Gamgee.psm1
	-------------------------------------------------------------------------
	 Module Name: Gamgee
	===========================================================================
#>

#region Configuration functions
function Get-Config {
	[CmdletBinding()]
	Param (
		[string]
		$Name
	)
	
	(Get-Variable -Name $Name -Scope Script).Value
}

function Set-Config {
	[CmdletBinding()]
	Param (
		[string]
		$Name,
		
		$Value
	)
	
	Set-Variable -Name $Name -Scope Script -Value $Value
}
#endregion Configuration functions

function Convert-HexToDec {
	[CmdletBinding(PositionalBinding = $true)]
	[OutputType([Decimal])]
	param
	(
		[Parameter(Mandatory = $true,
				   Position = 0)]
		[ValidateScript({
				if ($_ -match '[0123456789abcde]{$Y}') {
					$HexValue = $_
				}
				else {
					throw [System.Management.Automation.ParameterBindingException] `
					"The provided input is not a valid hexadecimal value."
				}
			})]
		[Alias('Hex')]
		[String]
		$HexValue
	)
	
	if ($HexValue.StartsWith("#")) {
		$HexValue = $HexValue.Substring(1)
	}
	
	ForEach ($Value in $HexValue) {
		[Convert]::ToInt32($Value, 16)
	}
}

function Convert-DecToHex {
	[CmdletBinding(PositionalBinding = $true)]
	param
	(
		[Parameter(Mandatory = $true,
				   Position = 0)]
		[ValidateScript({
				if ($_ -match '\d{0,8}') {
					$DecimalValue = $_
				}
				else {
					throw [System.Management.Automation.ParameterBindingException] `
					"The provided input is not a valid decimal value."
				}
			})]
		[Alias('Dec', 'Decimal')]
		[Decimal[]]
		$DecimalValue
	)
	
	ForEach ($Value in $DecimalValue) {
		("{0:x}" -f [Int]$Value).ToUpper()
	}
}

function Replace-FilenameCharacter {
	param
	(
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

function Get-RandomNumber {
	param
	(
		[Parameter(Mandatory = $true,
				   Position = 0)]
		[float]
		$Min,
		
		[Parameter(Mandatory = $true,
				   Position = 1)]
		[float]
		$Max
	)
	
	$Min .. $Max | Get-Random -Count 1
}

function Get-RandomString {
	param
	(
		[Parameter(Mandatory = $false,
				   Position = 0)]
		[int]
		$CharacterCount = 10
	)
	
	$RandomString = New-Object -TypeName System.Text.StringBuilder
	
	while ($RandomString.Length -le $CharacterCount) {
		[char]$RandomChar = (46 .. 57) + (65 .. 90) + (97 .. 122) | Get-Random -Count 1
		[void]$RandomString.Append($RandomChar)
	}
	
	$RandomString.ToString()
}

function Get-TestFiles {
	$FileDirectory = Resolve-Path "\\MONGO\Inner_Share\Test_Files\Copy_Dir"
	
	Copy-Item -Path $FileDirectory -Destination "C:\" -Recurse
}

function Update-iPowerShellVersion {
	param
	(
		[Parameter()]
		[System.Version]
		$NewVersion,
		
		[Parameter()]
		[Switch]
		$Increment,
		
		[Parameter()]
		[Switch]
		$Replace
	)
	
	# Store file paths
	$StringFile = "C:\Development\Android\Projects\iPowerShell_Android\app\src\main\res\values\strings.xml"
	$GradleFile = "C:\Development\Android\Projects\iPowerShell_Android\gradle.properties"
	
	# Get file contents
	$StringFileContent = Get-Content $StringFile
	$GradleFileContent = Get-Content $GradleFile
	
	# Detect current version from Grade build file
	$CurrentVersion = $GradleFileContent | Select-Object -last 1 | ForEach-Object { ($_ -split '=')[-1] }
	$CurrentVersion = [System.Version]::New($CurrentVersion)
	
	if ($Increment.IsPresent) {
		# If the increment switch is present, increase the version number by provided value
		$NewVersion = [System.Version]::New(($CurrentVersion.Major + $NewValue.Major), `
			($CurrentVersion.Minor + $NewValue.Minor), `
			($CurrentVersion.Build + $NewValue.Build))
	}
	elseif ($Replace.IsPresent) {
		# If the replace switch is present, replace current version with provided value
		$NewVersion = [System.Version]::New($NewValue.Major, $NewValue.Minor, $NewValue.Build)
	}
	else {
		# If no switch is provided, use the same version number and warn the user
		$NewVersion = [System.Version]::New($CurrentVersion.Major, $CurrentVersion.Minor, $CurrentVersion.Build)
		Write-Warning 'Version not updated, no increment or replace switch provided.'
	}
	
	# Currently for debugging
	Write-Host "CurrentVersion = $CurrentVersion"
	Write-Host "NewVersion = $NewVersion"
	
	# Update file content with new version number
	$StringFileContent -replace "$CurrentVersion", "$NewVersion" | Set-Content $StringFile
	$GradleFileContent -replace "$CurrentVersion", "$NewVersion" | Set-Content $GradleFile
	
	# Commit changes to git repo
	$ProjectDir = Split-Path -Path $GradleFile
	
	&git -C $ProjectDir add $StringFile
	&git -C $ProjectDir add $GradleFile
	&git -C $ProjectDir commit -m "Version increased."
}

function Get-ScriptDirectory {
<#
	.SYNOPSIS
		Get-ScriptDirectory returns the proper location of the script.

	.OUTPUTS
		System.String
	
	.NOTES
		Returns the correct path within a packaged executable.
#>
	
	[OutputType([string])]
	param ()
	if ($null -ne $hostinvocation) {
		Split-Path $hostinvocation.MyCommand.path
	}
	else {
		Split-Path $script:MyInvocation.MyCommand.Path
	}
}
Get-ChildItem -Path $PSScriptRoot\*.ps1 | ForEach-Object { . $_.FullName }

Export-ModuleMember -Function Get-FrontMortyImages, Get-BackMortyImages, Get-MortySprites, Get-AllMortyImages, `
					Get-RandomString, Get-TestFiles, Replace-FilenameCharacter, Set-Config, Update-iPowerShellVersion, `
					Convert-DecToHex, Convert-HexToDec, Get-Config, Get-RandomNumber, `
					Start-VRKTrayApp, Upload-Tron, Start-Tron, Stop-Tron, Restart-Tron, Connect-TronServer, Connect-TronBetaServer