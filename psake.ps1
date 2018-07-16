# PSake makes variables declared here available in other script blocks
# Init some things
Properties {
  # Find the build folder based on build system
  $ProjectRoot = $env:BHProjectPath
  if (-not $ProjectRoot) { $ProjectRoot = $PSScriptRoot }

  $Timestamp = Get-Date -UFormat "%Y%m%d-%H%M%S"
  $PSVersion = $PSVersionTable.PSVersion.Major
  $TestFile = "TestResults_PS$PSVersion`_$Timestamp.xml"
  $Lines = '----------------------------------------------------------------------'
  $Verbose = @{}

  if ($env:BHProjectPath -match '!verbose') { $Verbose = @{Verbose = $true} 
  }
}

Task Default -Depends Deploy

Task Init {
  $Lines

  Set-Location $ProjectRoot

  "Build System Details:"

  Get-Item ENV:BH*
  
  "`n"
}

Task Test -Depends init {
  $Lines

  "`n`tSTATUS: Testing with PowerShell $PSVersion"

  # Gather test results. Store them in a variable and file
  $TestResults = Invoke-Pester -Path $ProjectRoot\Tests -PassThru -OutputFormat NUnitXml -OutputFile "$ProjectRoot\$TestFile"

  # In Appveyor? Upload our tests!
  if ($env:BHBuildSystem -eq 'AppVeyor') {
    (New-Object 'System.Net.WebClient').UploadFile(
      "https://ci.appveyor.com/api/testresults/nunit/$($env:APPVEYOR_JOB_ID)",
      "$ProjectRoot\$TestFile" )
  }

  Remove-Item "$ProjectRoot\$TestFile" -Force -ErrorAction SilentlyContinue

  # Failed tests?
  # Need to tell psake or it will proceed to deployment. DANGER!
  if ($TestResults.FailedCount -gt 0) { 
    Write-Error "Failed '$($TestResults.FailedCount)' tests, build failed"
  }

  "`n"

}

Task Build -Depends Test {
  $Lines

  Set-ModuleFunctions

  Update-Metadata -Path $env:BHPSModuleManifest
}

Task Deploy -Depends Build {
  $Lines

  $Params = @{
    Path    = $ProjectRoot
    Force   = $true
    Recurse = $false
  }

  Invoke-PSDeploy @Verbose @Params
}
