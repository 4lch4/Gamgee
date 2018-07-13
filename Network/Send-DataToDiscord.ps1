# =============================================================================
#	 Created on:   07/07/18 @ 07:41
#	 Created by:   Alcha
#	 Organization: HassleFree Solutions, LLC
#	 Filename:     Send-DataToDiscord.ps1
# =============================================================================
<#
.SYNOPSIS
  Enables you to send data to a Discord webhook URL.

.DESCRIPTION
  Sends data to a Discord webhook URL for use however deemed fit. If no url is
provided, the default value is the testing channel within the HassleFree
Solutions Discord server. If no content is provided, some preset text will be
sent stating this is a test message and to please ignore it.

.PARAMETER Content
  The content/data that you wish to send to the webhook.

.PARAMETER WebhookUrl
  The url for the webhook where you wish to send your data. Defaults to the #testing channel in the HassleFree Solutions Discord server.

.EXAMPLE
  PS C:\> .\Send-ToDiscord.ps1
  "Message sent."

.EXAMPLE
  PS C:\> .\Send-ToDiscord.ps1 -Content "This is a test message."
  "Message sent."

.EXAMPLE
  PS C:\> .\Send-ToDiscord.p1 -WebhookUrl "Insert URL Here."
  "Message sent."

.NOTES
  I got the idea for this script from here: http://bit.ly/GingrNinja_Webhooks
#>
function Send-ToDiscord () {
  [CmdletBinding()]
  [Alias('std')]
  param (
    [Parameter(Mandatory = $false,
      Position = 0,
      HelpMessage = 'What is the data you wish to send to Discord?')]
    [Alias('Data')]
    [System.String]
    $Content,

    [Parameter(Mandatory = $false,
      Position = 1,
      HelpMessage = 'What is the url for the webhook to send the dat?')]
    [Alias('Uri', 'Url', 'Webhook')]
    [System.String]
    $WebhookUrl = 'https://discordapp.com/api/webhooks/356242669812449280/pHCF1LCWRS06ziSty4VFcgEMgvxUzFFSleujSuh-wc8KEdbzlvcepF04bUiWxsKfImRB'
  )

  if ($Content.Length -eq 0) { $Content = Get-TestContent }

  $Payload = [PSCustomObject]@{ content = $Content }

  try {
    $JSONPayload = ConvertTo-Json -InputObject $Payload
    Invoke-RestMethod -Method Post -Uri $WebhookUrl -Body $JSONPayload

    Write-Output 'Your message has been sent.'
  }
  catch { Write-Error $_ }
}

function Get-TestContent () {
  "This is all just some test data.`n`n" + "Please ignore this message."
}

