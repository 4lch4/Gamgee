# ===========================================================================
#  Created on:   	6/7/2018 @ 09:03
#  Created by:   	Alcha
#  Organization: 	HassleFree Solutions, LLC
#  Filename:     	Gamgee.psd1
#  -------------------------------------------------------------------------
#  Module Manifest
# -------------------------------------------------------------------------
#  Module Name: Gamgee
# ===========================================================================

@{
  RootModule             = 'Gamgee.psm1'
  ModuleVersion          = '1.0.6'
  GUID                   = '4abc5b62-bf86-4fe0-b34a-68e6cbc697ae'
  Author                 = 'Alcha'
  CompanyName            = 'HassleFree Solutions, LLC'
  Copyright              = '(c) 2018. All rights reserved.'
  Description            = 'Our helper module that contains the various scripts/functions used within HassleFree Solutions.'
  PowerShellVersion      = '2.0'
  DotNetFrameworkVersion = '2.0'
  CLRVersion             = '2.0.50727'
  ProcessorArchitecture  = 'None'

  NestedModules          = @(
    '.\Utils\ConfigTools.ps1',
    '.\Utils\ConversionTools.ps1',
    '.\Utils\FileTools.ps1',
    '.\Utils\Get-InstalledSoftware.ps1',
    '.\Utils\JournalTools.ps1',
    '.\Utils\New-NodeModule.ps1',
    '.\Utils\New-ScheduledScript.ps1',
    '.\Utils\PCHealth.ps1',
    '.\Utils\ProcessTools.ps1',
    '.\Utils\RandomizingTools.ps1',
    '.\Utils\TimerTools.ps1',
    '.\Projects\Kyle.ps1',
    '.\Projects\Tron-Commands.ps1',
    '.\Network\Send-DataToDiscord.ps1',
    '.\Network\Send-DailyReportToDiscord.ps1',
    '.\Misc\Get-MortyPictures.ps1'
  )

  FunctionsToExport      =
  # Gamgee.psm1
  'Get-IsAdmin', 'Restart-PM2App', 'Start-GitKraken', 'Start-PowerShellAsAdmin',
  'Optimize-GitRepository',

  # ConfigTools.ps1
  'Get-UserVariable', 'Get-MachineVariable', 'Set-UserVariable',
  'Set-MachineVariable', 'Remove-UserVariable', 'Remove-MachineVariable',
  'Set-VarValue', 'Set-VarValueAsAdmin', 'Get-VariableExistence',

  # ConversionTools.ps1
  'Convert-HexToDec', 'Convert-DecToHex',

  # FileTools.ps1
  'Get-ScriptDirectory', 'Move-Up', 'Update-FilenameCharacter',
  'Remove-ExcessWhitespace', 'Get-FileEncoding',

  # Get-InstalledSoftware.ps1
  'Get-InstalledSoftware', 'Get-InstalledSoftwareAsHtml',

  # JournalTools.ps1
  'New-JournalEntry',

  # New-NodeModule.ps1
  'New-NodeModule',

  # New-ScheduledScript.ps1
  'New-ScheduledScript',

  # ProcessTools.ps1
  'Get-ActiveProcess',

  # RandomizingTools.ps1
  'Get-RandomNumber', 'Get-RandomString', 'Get-ReversedString',

  # TimerTools.ps1
  'Start-Timer',

  # Kyle.ps1
  'Test-NotesEndpoint',

  # Tron-Commands.ps1
  'Connect-Tron',

  # Send-DataToDiscord.ps1
  'Send-ToDiscord',

  # Send-DailyReportToDiscord.ps1
  'Send-DailyReportToDiscord',

  # Get-MortyPictures.ps1
  'Get-MortyBack', 'Get-MortyFront', 'Get-Sprites',

  # PCHealth.ps1
  'Get-PCHealth'

  PrivateData            = @{
    PSData = @{
      LicenseUri = 'https://opensource.org/licenses/MIT'
      ProjectUri = 'https://github.com/Alcha/Gamgee'
      IconUri    = 'http://www.iconj.com/ico/z/6/z6xbh3kpa6.ico'
    }
  }
}
