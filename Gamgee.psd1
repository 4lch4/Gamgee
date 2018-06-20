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
  ModuleVersion          = '1.0.2'
  GUID                   = '4abc5b62-bf86-4fe0-b34a-68e6cbc697ae'
  Author                 = 'Alcha'
  CompanyName            = 'HassleFree Solutions, LLC'
  Copyright              = '(c) 2018. All rights reserved.'
  Description            = 'My helper module that contains all of my scripts/functions I use to make my life easier.'
  PowerShellVersion      = '2.0'
  DotNetFrameworkVersion = '2.0'
  CLRVersion             = '2.0.50727'
  ProcessorArchitecture  = 'None'

  <#FunctionsToExport      = 'Connect-Tron', 'Export-Gamgee', 'Get-Config', 
  'Set-Config', 'Get-FileEncoding', 'Get-ForegroundProcess', 
  'Get-InstalledSoftware', 'Get-MortyBack', 'Get-MortyFront',
  'Get-ReversedString', 'Get-ScriptDirectory', 'Get-Sprites', 'New-NodeModule',
  'Remove-TrailingWhitespace', 'Test-DownloadSpeed'#>

  PrivateData            = @{
    PSData = @{
      LicenseUri = 'https://opensource.org/licenses/MIT'
      ProjectUri = 'https://github.com/Alcha/Gamgee'
      IconUri    = 'http://www.iconj.com/ico/z/6/z6xbh3kpa6.ico'
    }        
  }
}
