# ===========================================================================
#  Created on:   5/22/2018 @ 19:30
#  Created by:   Alcha
#  Organization: HassleFree Solutions, LLC.
#  Filename:     New-NodeModule.ps1
# ===========================================================================

# .ExternalHelp .\Help_Files\New-NodeModule-Help.xml
function New-NodeModule {
  [CmdletBinding(SupportsShouldProcess = $true)]
  [Alias('nodemod', 'new-nodemod', 'newmod', 'newmodule', 'newnpm')]
  param (
    [Parameter(Mandatory = $true,
      Position = 0,
      HelpMessage = 'The name of the module to create.')]
    [ValidateScript( {
        if ($_ -match '^(?:@[a-z0-9-~][a-z0-9-._~]*/)?[a-z0-9-~][a-z0-9-._~]*$') {
          return $true
        }
        else {
          throw "Your module name must match the following pattern: ^(?:@[a-z0-9-~][a-z0-9-._~]*/)?[a-z0-9-~][a-z0-9-._~]*`$`nSee https://docs.npmjs.com/files/package.json#name for more info."
        }
      })]
    [Alias('Name', 'Module')]
    [String]$ModuleName,

    [Parameter(Mandatory = $false,
      Position = 1,
      HelpMessage = 'The path where the module is created.')]
    [ValidateScript( { return Test-Path $_ })]
    [Alias('Path')]
    [System.IO.FileInfo]$ModulePath = 'D:\Development\Projects\NodeJS_Packages',

    [Parameter(Mandatory = $false,
      Position = 2,
      HelpMessage = 'Do you wish to open this module in VSCode after creation?')]
    [Alias('Open')]
    [bool]$OpenInVSCode = $true
  )

  if ($PSCmdlet.ShouldProcess("Creates a new Node module in the given path if one is provided, otherwise it is created in D:\Development\Projects\NodeJS_Packages")) {
    $PackageInfo = Get-PackageInfo -ModuleName $ModuleName

    $FullModulePath = Join-Path -Path $ModulePath -ChildPath $ModuleName
    $PackageJson = Join-Path -Path $FullModulePath -ChildPath 'package.json'

    if (Test-Path -Path $FullModulePath) {
      # There is a folder at the provided path with the same name as the $ModuleName
      throw 'A folder with the same name exists at the provided path. Please choose a different module name or path.'
    }
    else {
      # Create directory for the module
      Write-Debug 'Creating module directory...'
      New-Item -Path $FullModulePath -ItemType Directory | Out-Null

      # Create the new package.json file
      Write-Debug 'Creating modules package.json...'
      New-Item -Path $PackageJson -ItemType File | Out-Null

      # Create the main index.js for most code logic
      Write-Debug 'Creating modules index.js...'
      New-Item -Path $FullModulePath\index.js -ItemType File | Out-Null

      # Create the LICENSE file that will contain the MIT License
      Write-Debug 'Creating modules empty LICENSE file...'
      New-Item -Path $FullModulePath\LICENSE -ItemType File | Out-Null

      # Convert the $PackageInfo to JSON
      Write-Debug 'Converting package info to JSON...'
      $JsonData = ConvertTo-Json -InputObject $PackageInfo

      # Store all package info to the module's package.json
      Write-Debug 'Adding package info to package.json...'
      Out-File -FilePath $PackageJson -InputObject $JsonData -Encoding utf8

      # Add the MIT License text to the LICENSE file
      Write-Debug 'Adding MIT license content to LICENSE file...'
      Out-File -FilePath $FullModulePath\LICENSE -InputObject $MITLicense -Encoding utf8

      Write-Verbose "The $ModuleName module has been successfuly created."

      # Open the folder containing the module as long as $OpenInVSCode is true and
      # the code command is available
      if ($OpenInVSCode -and (Get-Command code -ErrorAction SilentlyContinue)) {
        Write-Debug 'Opening the module directory in Visual Studio Code...'
        code $FullModulePath
      }
    }
  }
}

function Get-AuthorInfo() {
  return @{
    name  = 'Alcha'
    email = 'admin@alcha.org'
    url   = 'https://hasslefree.solutions'
  }
}

function Get-ScriptsInfo() {
  return @{
    start = 'node ./index.js'
    test  = 'jest'
  }
}

function Get-DevDependencyInfo() {
  return @{
    jest     = ''
    standard = ''
  }
}

function Get-PackageInfo() {
  param (
    [parameter(Mandatory = $true)]
    [String]$ModuleName
  )

  return @{
    name            = $ModuleName.ToLower()
    displayName     = $ModuleName.Substring(0, 1).ToUpper() + $ModuleName.Substring(1).toLower()
    version         = '0.0.1'
    description     = 'This is a placeholder description to be updated at a later date.'
    main            = 'index.js'
    license         = 'MIT'
    scripts         = Get-ScriptsInfo
    author          = Get-AuthorInfo
    devDependencies = Get-DevDependencyInfo
    standard        = @{
      ignore = @('*.test.js')
    }
  }
}

$MITLicense = @"
Copyright $(Get-Date -UFormat "%Y") HassleFree Solutions, LLC.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
"@
