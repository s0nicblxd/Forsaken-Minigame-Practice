# Forsaken: Battles — combat statistics and miscellaneous fixes

## Install

Apply after the latest Builderman placement repair and Elliot scooter-centering repair. Stop Play, save a copy of your place, run the entire `Apply-Combat-Stats.command.luau` in Studio's Command Bar, save, and start a fresh playtest. **No model import is needed.**

The installer checks all seven existing Sources before changing anything. It adds `ServerScriptService.Server.Systems.Data.CombatStatistics` with its private Schema module, updates the native Stats template, and backs up the original Sources/template/Friendly Fire default under `ServerStorage/FBStats_Backup_*`. Preparation or live Source-write failures leave/restore the previous state. Unknown Source changes are preserved by refusing installation; send the named module for a matching installer.

## Existing stats installation: character placement filter

Run `Repair-Builderman-Character-Filter.command.luau` in Edit mode, save and restart Play. No assets or full stats reinstall are needed. The repair keeps a `BuilderPlacementFilter_Backup_*` folder containing the previous Builderman Server Source.

The previous code already excluded `Workspace.Players`. This repair additionally excludes Builderman's actual rig, every rig in the actor registry, every current Player.Character and the carried/replaced building. Both placement raycasts and the obstacle-overlap query use the same captured list, covering survivor/killer models temporarily outside the normal container. Walls and other genuine map obstructions still block placement. The targeted test verifies those cases; final placement still needs a Studio check.

## Builderman and Elliot fixes

- Dropping a machine stops its building animation tracks immediately, restores its authored joint C0/C1 values and clears animation transforms before grounded placement. The world machine no longer plays the raised PutDown pose during the one-second owner movement lock. Builderman's own placement animation remains. The previous cached resting-height placement, windup, Carry, movement locks and survivor-only outline fixes are retained.
- Building destruction produces a visible explosion and burning/fading debris, including killer destruction, replacement, and owner death/despawn. The effect uses zero blast pressure, zero joint-destruction radius and NoCraters; it does not damage characters or terrain. Only the building's own joints are broken, after its Carry weld is removed. Debris cannot collide, touch or be targeted and expires after two seconds.
- Elliot's pizza timer displays decimal seconds such as **5.7s**, clamped at zero.

## Saved stats concept

The Stats menu uses the existing UPD screen/textures with expandable sections and live value updates:

| Section | Fields |
| --- | --- |
| General | Time Played, In-Game Time, Total Kills, Total Deaths |
| Survivor Stats | Survivor Kills, Survivor Deaths, Best Survivor Time, Best Survivor Killstreak |
| Killer Stats | Killer Kills, Killer Deaths, Best Killer Time, Best Killer Killstreak |
| Currency | Money, Net Worth |

- **Time Played** remains owned by the original player manager, including lobby time.
- **In-Game Time** counts only time in an active, living Survivor/Killer session. It excludes the lobby and ended/dead sessions. Best time is the longest uninterrupted playable session for that role. Role switches/normal actor removal end a session without adding a death.
- **Deaths** count actual playable-character deaths from any cause, including environmental/self-inflicted deaths. Native cleanup, HealthChanged and Died signals are deduplicated.
- **Kills** are credited on actual player death, using server-recorded damage attribution. The attacker's role at damage time selects the role counter. Hitboxes record damage before both ordinary health deduction and executions; Builderman Sentries record their damage too. The existing recent-attacker tag supplies a fallback for legacy paths. Attribution expires after ten seconds. NPCs/unregistered clones do not create player kill/death records.
- **Killstreaks** reset per playable life/session. Posthumous/previous-session damage can credit that role's total kills but cannot increase a newer life's streak.
- Active-time/best-time updates flush on actor removal and before the native player-removal save, including fractional seconds. Native PlayerData serialization persists the new NumberValues using the existing data store.
- **Legacy win/loss/objective/kill/malice/Robux-spend data is preserved.** It is not renamed or guessed into role kills. The new combat counters start at zero and accumulate after installation. Malice, win/loss and Robux-spend fields are excluded from the new menu; their unrelated native mechanics are not removed.
- The selected player's profile card retains its images/style and Time Played, with its two trophy counters now bound to **Survivor Kills** and **Killer Kills**, including corrected tooltips. Existing HideSurvivorWins/HideKillerWins privacy keys continue hiding those card counters; no new setting options are introduced.

## Friendly Fire

The saved place attribute is enabled during installation, and the server enforces `Workspace.FriendlyFire = true` during play. The old toggle command is marked non-executable and always sets true if invoked. Explicit ability target/team rules still apply; this enables the native hitbox system's friendly-fire behavior without changing healing targets or individual ability filters.

## Validation and remaining playtest

All command scripts and installed Sources compile with Luau. Seven standalone mock-based suites pass:

1. Actual stats backend: friendly-fire player kills, all-cause deaths, native cleanup/Died deduplication, role totals, best times/streaks, role switches, fractional leave flush, lobby exclusion, legacy preservation and Friendly Fire enforcement.
2. Full Builderman gameplay fixture against the updated Server: existing construction/Carry/cooldown behavior plus destruction/owner-cleanup explosions configured without character/terrain damage.
3. Immediate placed-machine rest pose/animation reset and decimal countdown formatting.
4. Combined installer: template/native-value preservation, backend/schema setup, idempotence, exact restore, each Source-write failure and edited-Source refusal.
5. Actual native persistence functions: fractional active time and new kills round-trip separately from old wins.
6. Actual Stats menu: four sections/14 selected fields, live values, collapse/expand and legacy/Robux fields excluded.
7. Actual player-card bindings: role kills and corrected tooltips instead of wins.

A Studio playtest is still needed for the final floor alignment and explosion appearance, plus a published test-server rejoin to confirm live saving. Check Survivor-vs-Survivor and Killer-vs-Killer combat, environmental deaths, killstreak reset, time in the lobby versus in a role, player cards, pizza timing, and Builderman placement/destruction.

## Restore

Stop Play, select the appropriate `FBStats_Backup_*` folder in ServerStorage, and run `Restore-Combat-Stats.command.luau`. Save and restart Play. It restores the prior Sources/template/Friendly Fire default and removes the backend; it refuses to overwrite later Source edits. Already saved combat counter values are not erased. Restore this bundle before using the older character/menu repair backups.
