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
  param ()

  $Invocation = (Get-Variable MyInvocation -Scope 1).Value
  Split-Path $Invocation.MyCommand.Path
}

Get-ChildItem -Recurse -Path $PSScriptRoot -Filter '*.ps1' -Exclude 'Test-Module.ps1' | ForEach-Object { . $_.FullName }

$ExportedFunctions = @(
  'Connect-Tron', 'Export-Gamgee', 'Get-Config', 'Set-Config',
  'Get-FileEncoding', 'Get-ForegroundProcess', 'Get-InstalledSoftware',
  'Get-MortyBack', 'Get-MortyFront', 'Get-Sprites', 'Get-ReversedString',
  'Get-ScriptDirectory', 'New-NodeModule', 'Remove-TrailingWhitespace',
  'Test-DownloadSpeed', 'Convert-DecToHex', 'Convert-HexToDec',
  'Update-FilenameCharacter', 'Get-RandomNumber', 'Get-RandomString'
)

Export-ModuleMember -Function $ExportedFunctions
