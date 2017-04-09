# Gamgee
A PowerShell module containing various functions that make my life easier.
I created the module using [PowerShell Studio](https://www.sapien.com/software/powershell_studio) by SAPIEN Technologies, inc.

## NodeJS Projects
There are various functions in the TronCommands.ps1 file that help with managing the public Tron bot and a few privately hosted ones.
The functions help with:
- Uploading the latest version of specific builds.
- Starting the service for a specific user.
- Restarting the service for a specific user.
- Stopping the service for a specific user.
- Connecting to the server that hosts the various bots.
- Connecting to the beta server that I test new versions of the bots.

## Morty Pictures
The Get-MortyPictures.ps1 contains functions for retrieving the latest images available on https://pocketmortys.net.
These are primarily used as my avatars, since there's so many I'm able to change frequently while maintaining a universal identity.
The functions are used to:
- Get the front images available for each Morty in the game.
- Get the back images available for each Morty in the game.
- Get the sprites of each Morty in the game.
- Perform all of the above actions in sequence.

## Notes
In order to use the NodeJS functions, they all use the standard ssh.exe available when you install [git](https://git-scm.com/downloads) in *C:\Program Files\Git\usr\bin*.
If you haven't installed [git](https://git-scm.com/downloads) then at least ensure ssh.exe is added to your system or user PATH.
