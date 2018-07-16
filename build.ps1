param ($Task = 'Default')

# Grab nuget bits, install modules, set build variables, start build
Get-PackageProvider -Name NuGet -ForceBootstrap | Out-Null

Install-Module Psake, PSDeploy, BuildHelpers -Force
Install-Module Pester -Force -SkipPublisherCheck
Import-Module Psake, BuildHelpers

Set-BuildEnvironment

Invoke-psake -buildFile .\psake.ps1 -taskList $Task -noLogo
ext( [int]( -not $psake.build_success ))
