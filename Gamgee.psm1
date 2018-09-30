# ===========================================================================
#  Created on:   	11/19/2016 @ 10:07 AM
#  Created by:   	Alcha
#  Organization: 	HassleFree Solutions, LLC
#  Filename:     	Gamgee.psm1
#  ------------------------------------------------------------------------
#  Module Name: Gamgee
# ===========================================================================

$WindowDllSig = @'
public static extern bool SetWindowPos( 
    IntPtr hWnd, 
    IntPtr hWndInsertAfter, 
    int X, 
    int Y, 
    int cx, 
    int cy, 
    uint uFlags); 
'@

function Set-WindowOnTop {  
	$Type = Add-Type -MemberDefinition $WindowDllSig -Name SetWindowPosition -Namespace SetWindowPos -Using System.Text -PassThru

	$Handle = (Get-Process -id $Global:PID).MainWindowHandle 
	$AlwaysOnTop = New-Object -TypeName System.IntPtr -ArgumentList (-1) 
	$Type::SetWindowPos($Handle, $AlwaysOnTop, 0, 0, 0, 0, 0x0003)
}

<#
.DESCRIPTION
	Cleans the given git repository using some commands that will peform a GC cycle
to force all references to deleted files to be expired and purged from the
packfile.

.LINK
	https://stackoverflow.com/a/11277929
#>
function Optimize-GitRepository {
	[CmdletBinding()]
	[Alias('Clean-Repo', 'Clean-GitRepo', 'cgr')]
	param (
		[Parameter(Mandatory = $false)]
		[Alias('Path')]
		[System.String]
		$RepoPath = $PWD.Path
	)
	
	if (Test-Path -Path $RepoPath) {
		Set-Location -Path $RepoPath
		git for-each-ref --format='delete %(refname)' refs/original | git update-ref --stdin
		git reflog expire --expire=now --all
		git gc --aggressive --prune=now
	} else { Write-Error 'Invalid path provided.' }
}

function Copy-CurrentPathToClipboard {
	[CmdletBinding()]
	[Alias('pathtoclip', 'cptc')]
	param ()
	
	$CurrPath = $PWD.Path
	Set-Clipboard -Value $CurrPath
	Write-Output "$CurrPath has been added to the clipboard."
}

<#
function Backup-BlogPosts {
	[CmdletBinding()]
	[Alias('Archive-BlogPosts', 'Archive-Blogs','abp')]
	param (
		[Parameter(Mandatory = $false, Position = 0)]
		[System.String]
	)
	
	begin {
	}
	
	process {
	}
	
	end {
	}
}
#>

function Get-IsAdmin () {
  [CmdletBinding()]
  [Alias('IsAdmin')]
  param ()

  $Principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
  return $Principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Export-Gamgee {
  [CmdletBinding()]
  param ()

  $ModuleDir = "C:\Users\Alcha\Documents\WindowsPowerShell\Modules"
  $Gamgee = "$ModuleDir\Gamgee"
  Remove-TrailingWhitespace -FileDir $Gamgee
  Copy-Item -Path .\ -Destination $ModuleDir -Force
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
	[Alias('AdminPosh', 'Admin')]
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