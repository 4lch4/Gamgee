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
	[OutputType([string])]
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
