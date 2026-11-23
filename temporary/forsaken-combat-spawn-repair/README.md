# FCT imported Combat map — role pad/spawn repair

For the supplied **FCTnewmap!.rbxl**. Stop Play, run **Apply-Combat-Spawns.command.luau** in Studio Command Bar, save, then start a new playtest. Use the imported lobby Killer/Survivor pads by touching them or pressing F on their original Interact prompt. Your currently equipped character and skin are selected through the native Actors:CreateActor(player, role) path.

## Found in the upload

- Arena/lobby/markers remained nested under Workspace.Map.Ingame.MapImport.Ingame.
- Both role pads had CanTouch=false and empty BecomeKiller/BecomeSurvivor server scripts.
- Both original Forsaken lobby and imported combat lobby SpawnLocations were enabled.
- Six role markers exist (three per role). Their current world positions are retained.

## Repair

Moves the imported Map and Lobby into Workspace.Map.Ingame and puts the imported SpawnPoints under Workspace.Map.Ingame.Map.SpawnPoints, matching the native Maps module's arena layout. The original Workspace.Map.Lobby and all geometry/world positions are retained. Empty MapImport wrappers are retained. No map objects are deleted.

Enables touch on the role pads, disables their empty placeholder scripts, and connects the original Forsaken styled F Interact prompts plus server-driven touch handling. Markers are anchored, non-colliding, non-touchable and non-queryable. Their names, positions and orientations are preserved. Makes the imported lobby SpawnLocation the sole enabled Workspace SpawnLocation and neutral; players' runtime RespawnLocation points to it. Native death/respawn stays with PlayerManager. No custom automatic respawn or arena-return teleport is added.

The controller requires loaded/live lobby players close to the pad, debounces across both pads, and rejects already active actors. It does not let an active fighter reset health/switch roles by touching a pad. Reset/die and respawn in the lobby to choose again. It does not bypass equipped-character selection or edit access rules.

Before character creation, a role marker must have a walkable, collidable arena floor beneath it. Failed raycasts try another marker; if all fail, spawning is refused with a clear Output warning. Native actor:PivotTo handles replication, ground clearance uses the spawned rig's size/hip height, and motion is cleared. The controller uses the actual arena geometry for raycasts, excluding markers and characters.

Only a new ServerScriptService.CombatSpawnPads script and its Controller child are added. Existing Actors/Hitboxes/character balance/endless-combat modules are not changed. Other imported empty scripts (generators/teleports) remain outside this repair. Existing spawn coordinates and the maker's map design are not replaced.

## Restore

Stop Play, select the CombatSpawns_Backup folder in ServerStorage, run **Restore-Combat-Spawns.command.luau**, save and start a fresh playtest. Changed properties/parents and created script Sources are checked before restore. The installer backs up all moved-parent references and modified properties, and rolls back on failure. Repeat installation of the same script is a no-op. A preflight rejects conflicting hierarchy or locally edited role-pad scripts.

Studio testing is required for actual touch contacts, physics/rig clearance, chosen character asset permissions, multiplayer replication and death/respawn. The new script does not repair errors inside an equipped character's own Config or Behavior.

## Forsaken prompt correction

If the earlier spawn repair is already installed, stop Play, run **Repair-Forsaken-Spawn-Prompts.command.luau**, save and start a fresh playtest. It wires the existing ProximityPrompt on each pad to the spawn controller, uses Custom style and the existing Styled theme with F / Interact, and archives the extra Roblox CombatRolePrompt outside Workspace. Touch spawning stays connected. It does not replace any shared prompt renderer or asset. A CombatPrompts_Backup folder stores the previous controller, prompt properties and archived popup instances. To undo this correction select that folder and run Restore-Forsaken-Spawn-Prompts.command.luau before restoring the original spawn repair. Fresh installations with the updated main installer reuse the original prompts directly.

Local validation: main install/restore and runtime spawn tests pass with original prompt reuse. Prompt correction tests cover custom Styled/F/Interact settings, removal of the duplicate default popup, no new replacement prompt, repeat application, restore and source-write rollback/edit refusal. All delivered scripts compile. Actual rendering and input still require a fresh Studio playtest.
