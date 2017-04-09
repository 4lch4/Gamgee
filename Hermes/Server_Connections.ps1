<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2017 v5.4.136
	 Created on:   	2/27/2017 9:09
	 Created by:   	DevinL
	 Organization: 	SAPIEN Technologies, Inc.
	 Filename:     	Server_Connections.ps1
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>
#Get-FileHash -Path C:\Temp\Get-BuggyInfo-Fixed.ps1 | Tee-Object -Variable 'BuggyInfo'
<#
	.SYNOPSIS
		Restarts the Linux server that hosts Hermes.
	
	.EXAMPLE
		PS C:\> Restart-HermesServer
#>
function Restart-HermesServer {
	[CmdletBinding()]
	param ()
	
	Set-Config -Name 'HermesIP' -Value '198.197.117.214'
	
	$ServerIP = Get-Config -Name "HermesIP"
	
	$BuggyInfo
	
	$ServerIP
}
 