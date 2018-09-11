# ===========================================================================
#  Created on:   	11/19/2016 @ 10:07 AM
#  Created by:   	Alcha
#  Organization: 	HassleFree Solutions, LLC
#  Filename:     	Gamgee.psm1
#  ------------------------------------------------------------------------
#  Module Name: Gamgee
# ===========================================================================

function Export-Gamgee {
  [CmdletBinding()]
  param ()

  $ModuleDir = "C:\Users\Alcha\Documents\WindowsPowerShell\Modules"
  $Gamgee = "$ModuleDir\Gamgee"
  Remove-TrailingWhitespace -FileDir $Gamgee
  Copy-Item -Path .\ -Destination $ModuleDir -Force
}

function Get-ScriptDirectory {
  [CmdletBinding()]
	[OutputType([System.String])]
	param ()
	if ($null -ne $hostinvocation) {
		Split-Path $hostinvocation.MyCommand.path
	}
	else {
		Split-Path $script:MyInvocation.MyCommand.Path
	}
}

<#
.SYNOPSIS
	Attempts to move you up one directory from your current location.
#>
function Move-Up {
	[CmdletBinding()]
	[Alias('up')]
	param ()

	Set-Location -Path '..'
}

<#
.SYNOPSIS
	Launch a PowerShell console as an Administrator.

.DESCRIPTION
	Launches a PowerShell console as an Administrator by using "Start-Process
PowerShell -Verb runAs".

.EXAMPLE
	PS C:\> Start-PowerShellAsAdmin
#>
function Start-PowerShellAsAdmin {
	[CmdletBinding()]
	[Alias('AdminPosh')]
	param ()

	Start-Process PowerShell -Verb runAs
}

function Start-GitKraken {
	[CmdletBinding()]
	[Alias('kraken', 'gk')]
	param ()
	Write-Output 'Launching GitKraken...'
	Start-Process -FilePath "C:\Users\Alcha\AppData\Local\gitkraken\Update.exe" `
								-ArgumentList '--processStart "gitkraken.exe"'
}

function Restart-PM2App {
	[CmdletBinding()]
	[Alias('Restart-App', 'restart-pm2', 'rpm2')]
	param (
		# The name of the PM2 app to restart
		[Parameter(Position = 0, Mandatory = $true)]
		[System.String]
		$AppName,

		# Whether or not you'd like to follow the log after restart, default is true
		[Parameter(Position = 1)]
		[bool]
		$FollowLog = $true
	)

	pm2 restart $AppName

	if ($FollowLog) { pm2 logs $AppName }
}