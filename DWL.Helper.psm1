<#	
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2016 v5.3.130
	 Created on:   	11/10/2016 10:49
	 Created by:   	DevinL
	 Organization: 	SAPIEN Technologies, Inc.
	 Filename:     	DWL.Helper.psm1
	-------------------------------------------------------------------------
	 Module Name: DWL.Helper
	===========================================================================
#>

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
		[char]$RandomChar = (65 .. 90) + (97 .. 122) | Get-Random -Count 1
		[void]$RandomString.Append($RandomChar)
	}
	
	$RandomString.ToString()
}

function Increment-iPowerShellVersion {
	param
	(
		[Parameter(Mandatory = $true,
				   Position = 0)]
		[System.Version]
		$IncrementValue
	)
	
	$StringFile = "C:\Development\Android\Projects\iPowerShell_Android\app\src\main\res\values\strings.xml"
	$GradleFile = "C:\Development\Android\Projects\iPowerShell_Android\gradle.properties"
	
	$StringFileContent = Get-Content $StringFile
	$GradleFileContent = Get-Content $GradleFile
	
	$CurrentVersion = $GradleFileContent | Select-Object -last 1 | ForEach-Object { ($_ -split '=')[-1] }
	$CurrentVersion = [System.Version]::New($CurrentVersion)
	
	$NewVersion = [System.Version]::New(($CurrentVersion.Major + $IncrementValue.Major), `
		($CurrentVersion.Minor + $IncrementValue.Minor), `
		($CurrentVersion.Build + $IncrementValue.Build))
	
	$StringFileContent -replace "$CurrentVersion", "$NewVersion" | Set-Content $StringFile
	$GradleFileContent -replace "$CurrentVersion", "$NewVersion" | Set-Content $GradleFile
	
	$ProjectDir = Split-Path -Path $GradleFile
	
	&git -C $ProjectDir add .
	&git -C $ProjectDir commit -m "Version increased."
}

Get-ChildItem -Path $PSScriptRoot -Filter '*.ps1' -Recurse | ForEach-Object { . $_.FullName }
