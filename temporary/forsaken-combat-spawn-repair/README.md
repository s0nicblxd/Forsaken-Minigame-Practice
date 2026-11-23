# FCT imported Combat map — role pad/spawn repair

For the supplied **FCTnewmap!.rbxl**. Stop Play, run **Apply-Combat-Spawns.command.luau** in Studio Command Bar, save, then start a new playtest. Use the imported lobby Killer/Survivor pads by touching them or using their proximity prompt. Your currently equipped character and skin are selected through the native Actors:CreateActor(player, role) path.

## Found in the upload

- Arena/lobby/markers remained nested under Workspace.Map.Ingame.MapImport.Ingame.
- Both role pads had CanTouch=false and empty BecomeKiller/BecomeSurvivor server scripts.
- Both original Forsaken lobby and imported combat lobby SpawnLocations were enabled.
- Six role markers exist (three per role). Their current world positions are retained.

## Repair

Moves the imported Map and Lobby into Workspace.Map.Ingame and puts the imported SpawnPoints under Workspace.Map.Ingame.Map.SpawnPoints, matching the native Maps module's arena layout. The original Workspace.Map.Lobby and all geometry/world positions are retained. Empty MapImport wrappers are retained. No map objects are deleted.

Enables touch on the role pads, disables their empty placeholder scripts, and adds server-driven touch + proximity prompt handling. Markers are anchored, non-colliding, non-touchable and non-queryable. Their names, positions and orientations are preserved. Makes the imported lobby SpawnLocation the sole enabled Workspace SpawnLocation and neutral; players' runtime RespawnLocation points to it. Native death/respawn stays with PlayerManager. No custom automatic respawn or arena-return teleport is added.

The controller requires loaded/live lobby players close to the pad, debounces across both pads, and rejects already active actors. It does not let an active fighter reset health/switch roles by touching a pad. Reset/die and respawn in the lobby to choose again. It does not bypass equipped-character selection or edit access rules.

Before character creation, a role marker must have a walkable, collidable arena floor beneath it. Failed raycasts try another marker; if all fail, spawning is refused with a clear Output warning. Native actor:PivotTo handles replication, ground clearance uses the spawned rig's size/hip height, and motion is cleared. The controller uses the actual arena geometry for raycasts, excluding markers and characters.

Only a new ServerScriptService.CombatSpawnPads script and its Controller child are added. Existing Actors/Hitboxes/character balance/endless-combat modules are not changed. Other imported empty scripts (generators/teleports) remain outside this repair. Existing spawn coordinates and the maker's map design are not replaced.

## Restore

Stop Play, select the CombatSpawns_Backup folder in ServerStorage, run **Restore-Combat-Spawns.command.luau**, save and start a fresh playtest. Changed properties/parents and created script Sources are checked before restore. The installer backs up all moved-parent references and modified properties, and rolls back on failure. Repeat installation of the same script is a no-op. A preflight rejects conflicting hierarchy or locally edited role-pad scripts.

Studio testing is required for actual touch contacts, physics/rig clearance, chosen character asset permissions, multiplayer replication and death/respawn. The new script does not repair errors inside an equipped character's own Config or Behavior.

## Local validation

Delivered runtime and Command Bar scripts compile with Luau. Runtime harness checks native equipped-character calls, touch/proximity input, loaded/live/distance validation, cross-pad busy locks, cooldowns, active-actor rejection, no-floor refusal before creation, error recovery, player cleanup, scaled/normal R6 ground clearance and actor replication pivots. Installer harness checks duplicate Spawn Model/SpawnLocation names, world-position preservation, canonical layout, exact property/parent restore, idempotence, conflicting hierarchy/local edit refusal and rollback after an injected controller Source write failure. Actual physics, character media and multiplayer replication require Studio testing.
