<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2017 v5.4.136
	 Created on:   	2/27/2017 9:13
	 Created by:   	DevinL
	 Organization: 	SAPIEN Technologies, Inc.
	 Filename:     	Config_Functions.ps1
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>

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