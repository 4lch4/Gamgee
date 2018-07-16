# =============================================================================
#  Created On:   2018/07/10 @ 23:30
#  Created By:   Alcha
#  Organization: HassleFree Solutions, LLC
#  Filename:     TimerTools.ps1
#  Description:  Contains timer based functions for Gamgee.
# =============================================================================

<#
.SYNOPSIS
  Starts a timer and writes to output when complete.

.DESCRIPTION
  Starts a timer by using the Start-Sleep cmdlet and passing in the provided
values after converting them to seconds.

.PARAMETER Milliseconds
  How many milliseconds long should this timer last?

.PARAMETER Seconds
  How many seconds long should this timer last?

.EXAMPLE
  PS C:\> Start-Timer -Seconds 5
Timer complete!
#>
function Start-Timer {
  [CmdletBinding()]
  [Alias('New-Timer', 'Timer')]
  param (
    [Parameter(Mandatory = $false, Position = 0)]
    $Milliseconds,

    [Parameter(Mandatory = $false, Position = 1)]
    $Seconds
  )

  $TotalSeconds = 0

  if ($null -ne $Seconds) { $TotalSeconds += $Seconds }
  if ($null -ne $Milliseconds) { $TotalSeconds += ($Milliseconds / 100) }

  Start-Sleep -Seconds $TotalSeconds
  Write-Host 'Timer complete!'
}
