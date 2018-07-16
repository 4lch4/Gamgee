# Gamgee 1.0.5

A PowerShell module containing various functions that make my life easier.
I created the module using [PowerShell Studio][0] by SAPIEN Technologies, Inc. and now maintain it using [Visual Studio Code][1] with a [number][2] of [helpful extensions][3] and [snippets][4].

_NOTE: The following sections do not cover every single function within the module, instead it covers ones I felt should be highlighted for whatever reason. I try to explain the reasoning (to an extent) within the section itself._

## Configuration/Environment Variable Functions

There are a few functions that are for handling environment variables for easier manipulation of the machine/user level path variables. Instead of having to open the GUI or executing one hell of a "one-liner", you can use these functions to help out:

- `Set-UserVariable`
  - Lets you set an environment variable at the User level.
- `Set-MachineVariable`
  - Lets you set an environment variable at the Machine level.
- `Get-UserVariable`
  - Lets you get a user environment variable.
  - This one isn't really needed, as you can just use $env:VAR_NAME_HERE, I'm not too sure why I added it.
- `Get-MachineVariable`
  - Same goes as the `Get-UserVariable` function.
- `Get-IsUserAdmin`
  - Returns true or false, does the current process have Administrator rights?
  - Originally started as an easy way for me to avoid errors within the `Set-MachineVariable` function, but I realized it had broader uses so I've exposed it 😳

## Morty Pictures

The Get-MortyPictures.ps1 contains functions for retrieving the latest images available on the PocketMortys [website][23].
These are primarily used as my avatars, since there's so many I'm able to change frequently while maintaining a universal identity.
The functions are used to:

- Get the front images available for each Morty in the game.
- Get the back images available for each Morty in the game.
- Get the sprites of each Morty in the game.
- Perform all of the above actions in sequence.

## Notes

In order to use the NodeJS functions, they all use the standard ssh.exe available when you install [git](https://git-scm.com/downloads) in *C:\Program Files\Git\usr\bin*.
If you haven't installed [git](https://git-scm.com/downloads) then at least ensure ssh.exe is added to your system or user PATH.

[0]: https://www.sapien.com/software/powershell_studio
[1]: https://code.visualstudio.com
[2]: https://marketplace.visualstudio.com/items?itemName=ms-vscode.PowerShell
[3]: https://marketplace.visualstudio.com/items?itemName=alefragnani.project-manager
[4]: https://github.com/Alcha/PowerShell/tree/master/Visual_Studio_Code_Files/Snippets
[23]: https://pocketmortys.net