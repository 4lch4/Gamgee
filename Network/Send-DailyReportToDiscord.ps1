# =============================================================================
#  Created On:   2018/07/09 @ 18:44
#  Created By:   Alcha
#  Organization: HassleFree Solutions, LLC
#  Filename:     Send-DailyReportToDiscord.ps1
#  Description:  Used to send a daily report to myself on Discord using my
#   $env:DISCORD_WEBHOOK. Soon, I'll move this file into the
#   Send-DataToDiscord.ps1 or vice versa since they're so intertwined.
# =============================================================================
. $PSScriptRoot\Send-DataToDiscord.ps1

<#
.SYNOPSIS
  Sends a daily report of the given data over the $env:DISCORD_WEBHOOK.

.DESCRIPTION
  Builds a proper "display" of information using the provided Data HashTable
and sends it to the $env:DISCORD_WEBHOOK for reporting.

.PARAMETER Data
  A HashTable containing all of the information you want in the daily report.

.EXAMPLE
  PS C:\> Send-DailyReportToDiscord -Data (.\Get-PCHealth.ps1 -DataOnly)
#>
function Send-DailyReportToDiscord () {
  [CmdletBinding()]
  [Alias('Send-ReportToDiscord', 'DailyDiscordReport', 'DDR')]
  param (
    [Parameter(Mandatory = $true,
               Position = 0,
               HelpMessage = 'What is the data you wish to send in the daily report?')]
    [System.Collections.Hashtable]
    $Data
  )

  if ($env:DISCORD_ALCHA_USER_ID.Length -eq 0) {
    $MentionTag = '@Alcha#2625'
  } else {
    $MentionTag = "<@$env:DISCORD_ALCHA_USER_ID>"
  }

  $DataMsg = "$MentionTag, Here is your daily report:`n" +
  "``````markdown`n" +
    "- You currently have $($Data.InstalledApps.Length) installed programs.`n"+
    "- You are using $($Data.OS.Caption) build number $($Data.OS.BuildNumber).`n" +
    "- Your last boot time was $($Data.OS.LastBootTime).`n" +
    "- You have logged $(Get-ErrorCount $Data.AppEvent) app event errors since your last boot.`n" +
  "``````"

  Send-ToDiscord -Content $DataMsg
}

<#
.SYNOPSIS
  Get the amount of errors in the given EventLogs.

.DESCRIPTION
  Check every event in the provided EventLogs for any EntryType that matches
"Error" and increases a count variable. After parsing all entries, the count
is returned.

.PARAMETER EventLogs
  A HashTable containing the EventLogs.

.EXAMPLE
  PS C:\> Get-ErrorCount -EventLogs $EventLogs
#>
function Get-ErrorCount () {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true, Position = 0)]
    [Alias('Events', 'Logs')]
    [System.Collections.Hashtable]
    $EventLogs
  )

  $Count = 0

  foreach ($Event in $EventLogs) {
    if ($Event -match 'EntryType=Error') {
      $Count++
    }
  }

  return $Count
}

