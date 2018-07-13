# =============================================================================
#  Created On:   2018/07/09 @ 18:44
#  Created By:   Alcha
#  Organization: HassleFree Solutions, LLC
#  Filename:     Send-DailyReportToDiscord.ps1
#  Description:
# =============================================================================
function Send-DailyReportToDiscord () {
  [CmdletBinding()]
  [Alias('Send-ReportToDiscord', 'DailyDiscordReport', 'DDR')]
  param (
    $Data
  )

  if ($env:DISCORD_ALCHA_USER_ID.Length -eq 0) {
    $MentionTag = '@Alcha#2625'
  } else { $MentionTag = "<@$env:DISCORD_ALCHA_USER_ID>" }


  $DataMsg = "$MentionTag, Here is your daily report:
  ``````markdown
    - You currently have $($Data.InstalledApps.Length) installed programs.
    - You are using $($Data.OS.Caption) build number $($Data.OS.BuildNumber).
    - Your last boot time was $($Data.OS.LastBootTime).
    - You have logged $(Get-ErrorCount $Data.AppEvent) app event errors since your last boot.
  ``````"

  Write-Host $DataMsg
}

function Get-ErrorCount () {
  param (
    $EventLogs
  )

  $Count = 0

  ForEach ($Event in $EventLogs) {
    if ($Event -match 'EntryType=Error') { $Count++ }
  }

  return $Count
}

