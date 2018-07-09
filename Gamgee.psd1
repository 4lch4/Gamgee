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
  ModuleVersion          = '1.0.5'
  GUID                   = '4abc5b62-bf86-4fe0-b34a-68e6cbc697ae'
  Author                 = 'Alcha'
  CompanyName            = 'HassleFree Solutions, LLC'
  Copyright              = '(c) 2018. All rights reserved.'
  Description            = 'My helper module that contains all of my scripts/functions I use to make my life easier.'
  PowerShellVersion      = '2.0'
  DotNetFrameworkVersion = '2.0'
  CLRVersion             = '2.0.50727'
  ProcessorArchitecture  = 'None'

  NestedModules          = @(
    '.\Utils\ConfigTools.ps1',
    '.\Utils\ConversionTools.ps1',
    '.\Utils\FileTools.ps1',
    '.\Utils\Get-FileEncoding.ps1',
    '.\Utils\Get-InstalledSoftware.ps1',
    '.\Utils\Get-ReversedString.ps1',
    '.\Utils\JournalTools.ps1',
    '.\Utils\New-NodeModule.ps1',
    '.\Utils\ProcessTools.ps1',
    '.\Utils\RandomizingTools.ps1',
    '.\Utils\Remove-ExcessWhitespace.ps1'
    '.\Projects\Tron-Commands.ps1',
    '.\Network\Test-DownloadSpeed.ps1',
    '.\Misc\Get-MortyPictures.ps1'
  )

  FunctionsToExport      = 'Connect-Tron', 'Export-Gamgee', 'Get-UserVariable',
    'Get-MachineVariable', 'Get-IsUserAdmin', 'Set-UserVariable',
    'Set-MachineVariable', 'Get-FileEncoding', 'Get-ActiveProcess', 
    'Get-InstalledSoftware', 'Get-MortyBack', 'Get-MortyFront', 'Get-Sprites',
    'Get-ReversedString', 'Get-ScriptDirectory', 'New-NodeModule',
    'New-JournalEntry', 'Remove-ExcessWhitespace', 'Test-DownloadSpeed',
    'Convert-DecToHex', 'Convert-HexToDec', 'Update-FilenameCharacter',
    'Get-RandomNumber', 'Get-RandomString'

  PrivateData            = @{
    PSData = @{
      LicenseUri = 'https://opensource.org/licenses/MIT'
      ProjectUri = 'https://github.com/Alcha/Gamgee'
      IconUri    = 'http://www.iconj.com/ico/z/6/z6xbh3kpa6.ico'
    }        
  }
}
