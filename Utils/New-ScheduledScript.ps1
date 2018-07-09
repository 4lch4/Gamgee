# =============================================================================
#  Created On:   2018/06/24 @ 15:10
#  Created By:   Alcha
#  Organization: HassleFree Solutions, LLC
#  Filename:     New-ScheduledScript.ps1
#  Description:  Creates a new Scheduled Task for a given script.
# =============================================================================
$PowerShellPath = 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe'
Import-Module ScheduledTasks

function New-ScheduledScript () {
  param (
    [Parameter(Mandatory = $true, Position = 0)]
    [System.String]
    $ScriptPath,
    
    [Parameter(Mandatory = $false, Position = 1)]
    [ValidateSet('Minutely', 'Hourly', 'Daily', 'Weekly', 'Monthly', IgnoreCase = $true)]
    [System.String]
    $Trigger = 'Daily',
    
    [Parameter(Position = 2)]
    [Alias('Time')]
    [System.DateTime]
    $TriggerTime = '2AM'
  )
  
  $TaskAction = New-ScheduledTaskAction -Execute $PowerShellPath -Argument "-NonInteractive -NoLogo -File '$ScriptPath'"
  $Trigger = $Trigger.ToLower()
  
  switch ($Trigger) {
    'minutely' {
      $TaskTrigger = New-ScheduledTaskTrigger -At $TriggerTime -RepetitionInterval (New-TimeSpan -Minutes 1)
    }
    
    'hourly' {
      $TaskTrigger = New-ScheduledTaskTrigger -At $TriggerTime -RepetitionInterval (New-TimeSpan -Hours 1)
    }
    
    'daily' {
      $TaskTrigger = New-ScheduledTaskTrigger -At $TriggerTime -Daily
    }
    
    'weekly' {
      $TaskTrigger = New-ScheduledTaskTrigger -At $TriggerTime -Weekly
    }
    
    'monthly' {
      $TaskTrigger = New-ScheduledTaskTrigger -At $TriggerTime -WeeksInterval 4
    }
    
    default {
      throw 'Invalid Trigger provided.'
    }
  }
  
  $ScriptName = Get-ScriptName $ScriptPath
  
  Register-ScheduledTask -Action $TaskAction -Trigger $TaskTrigger -Settings (New-ScheduledTaskSettingsSet) -TaskName "Executing $ScriptName $Trigger."
}

<#
.SYNOPSIS
  Parses the given path to a script for the name of the file without extension.

.DESCRIPTION
  Parses the given path to a script by using Split-Path and doing a substring to
remove the extension.

.PARAMETER ScriptPath
  The path to the script you wish to get the name of.

.EXAMPLE
  PS C:\> Get-ScriptName 'C:\Users\Alcha\Documents\Get-InstalledSoftware.ps1'
  Get-InstalledSoftware
#>
function Get-ScriptName () {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true, Position = 0)]
    [System.String]
    $ScriptPath
  )
  
  $ScriptName = Split-Path $ScriptPath -Leaf
  $ScriptName = $ScriptName.Substring(0, $ScriptName.IndexOf('.'))
  
  Write-Verbose "Converted $ScriptPath to $ScriptName..."
  
  return $ScriptName
}
