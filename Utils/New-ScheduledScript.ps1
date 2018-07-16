# =============================================================================
#  Created On:   2018/06/24 @ 15:10
#  Created By:   Alcha
#  Organization: HassleFree Solutions, LLC
#  Filename:     New-ScheduledScript.ps1
#  Description:  Creates a new Scheduled Task for a given script.
# =============================================================================
$PowerShellPath = 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe'
Import-Module ScheduledTasks

<#
.SYNOPSIS
  Creates a new scheduled task that executes the provided script at the provided
interval and time.

.DESCRIPTION
  Creates a new ScheduledTaskAction using the ScheduledTasks module and assigns
a ScheduledTaskTrigger with an interval and start time of whatever is provided.
The scheduled action will then start running the given script at the given start
time and repeat at the given interval/trigger.

.PARAMETER ScriptPath
  The path to the script you wish to have executed on a scheduled basis.

.PARAMETER TriggerInterval
  The interval at which you'd like your script to execute. The accepted values
are: minutely, hourly, daily, weekly, or monthly.

.PARAMETER TriggerTime
  The time at which you'd like the script to execute.

.EXAMPLE
  PS C:\> New-ScheduledScript -ScriptPath 'C:\Temp\Test.ps1'
Sets the Test.ps1 script to execute on a scheduled basis using the default of
running every day at 2 AM.
#>
function New-ScheduledScript {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true, Position = 0)]
    [System.String]
    $ScriptPath,

    [Parameter(Mandatory = $false, Position = 1)]
    [ValidateSet('Minutely', 'Hourly', 'Daily', 'Weekly', 'Monthly', IgnoreCase = $true)]
    [Alias('Interval')]
    [System.String]
    $TriggerInterval = 'Daily',

    [Parameter(Position = 2)]
    [Alias('Time')]
    [System.DateTime]
    $TriggerTime = '2AM'
  )

  $TaskAction = New-ScheduledTaskAction -Execute $PowerShellPath -Argument "-NonInteractive -NoLogo -File '$ScriptPath'"
  $TriggerInterval = $TriggerInterval.ToLower()

  switch ($TriggerInterval) {
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
      throw 'Invalid TriggerInterval provided.'
    }
  }

  Register-ScheduledTask -Action $TaskAction -Trigger $TaskTrigger -Settings (New-ScheduledTaskSettingsSet) `
  -TaskName "Executing $(Get-ScriptName $ScriptPath) $TriggerInterval."
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
function Get-ScriptName {
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
