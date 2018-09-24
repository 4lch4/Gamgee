function Test-NotesEndpoint {
  [CmdletBinding()]
  param (
    [System.String]
    $BaseUrl = 'http://localhost:3030',

    [System.String]
    $Category = [System.Web.HttpUtility]::UrlEncode('Wishlist'),

    [System.String]
    $Title = [System.Web.HttpUtility]::UrlEncode('Towns to Visit'),

    [System.String]
    $Content = [System.Web.HttpUtility]::UrlEncode('Toad Suck, Arkansas')
  )

  process {
    Invoke-WebRequest -Uri "$BaseUrl/notes?token=test&category=$Category&title=$Title&content=$Content"
  }
}