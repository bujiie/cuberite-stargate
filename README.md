# cuberite-stargate

## Install
Clone this project into the Cuberite Plugin directory
```bash
git clone https://github.com/bujiie/cuberite-stargate.git
```
Start up the Cuberite Minecraft Server and the plugin should install automatically.

## Commands
`/test` -> stargate.test
Runs basic unit tests.

`/ld go` -> stargate.lastdeath
Transport player to his/her last place of death. (Note, this includes pits of lava)

`/ld info` -> stargate.lastdeath
Shows the player's last place of death coordinates, but does not transport them.

`/dhd` or `/home`-> stargate.gdo
Transport player to his/her Stargate labeled 'home'. Same result as `/sg home`

`/work` -> stargate.gdo
Transport player to his/her Stargate labeled 'work' if available.

`/last` -> stargate.gdo
Transport plaer to his/her last location before traveling.

`/sg <player_name|stargate_name>` -> stargate.gdo
Transport player to designated player or Stargate.

`/sgc spawn` -> stargate.gdo.spawn
Transport plaer to the spawn point.

`/sgc spawninfo` or `/sgc si` -> stargate.gdo.spawn
Shows the coordinates to the spawn point, but does not transport player.

`/sgc set <name>` -> stargate.gdo.set
Save the current coordinates by referenced name.

`/sgc rename <old_name> <new_name>` -> stargate.gdo.rename
Rename a Stargate reference that is enabled and registered to you.

`/sgc update <name>` or `/sgc up <name>` -> stargate.gdo.update
Update the Stargate referenced by name with the current cooridnates.

`/sgc remove <name>` or `/sgc rm <name>` -> stargate.gdo.remove
Remove a Stargate referenced by name if it is enabled and registered to you.

`/sgc list` or `/sgc ls` -> stargate.gdo.list
List the currently accessible Stargates for player and indicate which world the Stargate is in.
