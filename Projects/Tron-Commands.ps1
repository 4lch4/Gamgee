# =============================================================================
#  Created on:   6/7/2018 @ 22:08
#  Created by:   Alcha
#  Organization: HassleFree Solutions, LLC
#  Filename:     Tron-Commands.ps1
# =============================================================================

$ProductionServer = 'tron.ninja'
$TestServer = 'precognition.us'

<#
.SYNOPSIS
  Connects to the Tron server as Alcha using SSH. (e.g. ssh alcha@tron.ninja)
  
.DESCRIPTION
  Connects to either of the Tron servers, production or test depending on the
provided input. If none is provided, the production server is connected to by
default.

.PARAMETER Server
  A String representing which server to connect to (e.g. Production or Test).

.EXAMPLE
  PS C:\> Connect-Tron
  'Connecting to production server at tron.ninja'

.EXAMPLE
  PS C:\> Connect-Tron Production
  'Connecting to production server at tron.ninja'

.EXAMPLE
  PS C:\> Connect-Tron -Server Test
  'Connecting to test server at 138.197.71.218'
#>
function Connect-Tron() {
  [CmdletBinding()]
  [Alias('Tron')]
  param (
    [Parameter(Position = 0)]
    [ValidateSet('Production', 'Test', IgnoreCase = $true)]
    [System.String]$Server = 'Production'
  )
  
  switch ($Server.ToLower()) {
    'production' {
      Write-Output "Connecting to production server at $ProductionServer"
      ssh alcha@$ProductionServer
    }

    'test' {
      Write-Output "Connecting to test server at $TestServer"
      ssh alcha@$TestServer
    }

    Default { 
      Write-Output 'Connecting to production server at tron.ninja'
      ssh alcha@tron.ninja
    }
  }
}
