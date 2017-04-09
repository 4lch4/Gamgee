<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2017 v5.4.133
	 Created on:   	1/19/2017 8:46 PM
	 Created by:   	DevinL
	 Organization: 	SAPIEN Technologies, Inc.
	 Filename:     	SAPIEN_Commands.ps1
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>

function Start-VRKTrayApp {
	$ExeLocation = "C:\Program Files\SAPIEN Technologies, Inc\VersionRecall 2017\VRKTray.exe"
	if (Test-Path $ExeLocation){
		& $ExeLocation
	}
}
