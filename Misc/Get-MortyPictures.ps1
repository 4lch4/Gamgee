# =============================================================================
#  Created On:   2016/11/19 @ 10:07
#  Created By:   Alcha
#  Organization: HassleFree Solutions, LLC
#  Filename:     Get-MortyPictures.ps1
#  Description:  A script for retrieving the collection of Morty pictures
#               available on https://pocketmortys.net. Currently only retrieves
#               the files that are named by the number of the Morty. I believe
#               the max is 200 or some shit. After that, the site changed the
#               system for filenames and they're named after the Morty instead.
# =============================================================================

function Get-MortyFront {
  [CmdletBinding()]
  param (
    [Parameter(Position = 0)]
    [String]$StorageDir = "D:\Media\Pictures\Morty\"
  )

  for ($x = 2; $x -le 168; $x++) {
    $MortyCounter = "{0:D3}" -f $x
    $Url = "https://pocketmortys.net/images/large/$MortyCounter-Front.png"

    $FileName = "$StorageDir\Morty-$MortyCounter-Front.png"

    if ($null -eq (Get-ChildItem $FileName)) {
      $WebClient = New-Object -TypeName System.Net.WebClient
      $WebClient.DownloadFile($Url, $FileName)
      Write-Output "Downloaded " + $FileName
    }
  }
}

function Get-MortyBack {
  [CmdletBinding()]
  param (
    [Parameter(Position = 0)]
    [String]$StorageDir = "D:\Media\Pictures\Morty\"
  )

  for ($x = 2; $x -le 158; $x++) {
    $MortyCounter = "{0:D3}" -f $x
    $Url = "https://pocketmortys.net/images/large/$MortyCounter-Back.png"

    $FileName = "$StorageDir\Morty-$MortyCounter-Back.png"

    $WebClient = New-Object -TypeName System.Net.WebClient
    $WebClient.DownloadFile($Url, $FileName)
  }
}

function Get-Sprites {
  [CmdletBinding()]
  param (
    [Parameter(Position = 0)]
    [String]$StorageDir = "D:\Media\Pictures\Morty\"
  )

  for ($x = 2; $x -le 158; $x++) {
    $MortyCounter = "{0:D3}" -f $x
    $WebClient = New-Object -TypeName System.Net.WebClient

    for ($y = 1; $y -le 3; $y++) {
      [System.String]$Url = "https://pocketmortys.net/images/sprites/sprites_" + "$MortyCounter" + "_" + $y + ".png"
      [System.String]$FileName = "$StorageDir\Sprite_" + "$MortyCounter" + "_" + $y + ".png"

      $WebClient.DownloadFile($Url, $FileName)
    }
  }
}
