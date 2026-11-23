# Endless combat — round policy and HUD

Stop Play. Run **Apply-Endless-Combat.command.luau** in Studio Command Bar, save, and start a fresh playtest. Supports the current FCT combat build's original RoundManager/HUD and the supplied FCF build's matching pair. It does not depend on, undo, or reinstall character ports. Unknown or mixed sources are rejected before any write.

## Behavior

- HUD title: **Battle Till' Death!**. Timer text: **Fight**.
- Endless mode takes the standard round heartbeat path before DoHeartbeat/RoundsDisabled, timer expiry, elimination-win checks, LMS and low-time music. It also guards explicit InitRound, EndRound, LMS and AddTime calls while enabled. No round-win rewards or standard win cutscenes are generated.
- Existing actors, kill/assist rewards, stats persistence, actor death cleanup, replicated character health and survivor/killer side UI retain their existing implementations. No shared Actors/Hitboxes/Stats/UI roster modules are changed. New death connections are not implemented here; existing character death events remain responsible for them. Standard RoundManager session/loss accounting normally created by InitRound is not newly created in endless mode.
- RoundManager.EndlessCombatElapsed advances as an in-memory server elapsed clock. If a session already exists, its ActualTimePast advances while it is not initializing/ending. Its countdown TimePast stays frozen. This is not the deferred saved In-Game Time stat and not a per-player survival-time system.
- On the current FCT build, RoundTimer.TimeLeft stays finite at 5999, with the custom HUD overriding numeric rendering. The round timer title is set on the server as well.
- The supplied FCF build already disables rounds and has independent MapRotation. That module retains its timer values, map cycling and voting. The combat HUD hides its numeric countdown. This patch does not create/import a map rotation system in FCT or stop FCF's independent map changes.
- BloodHunt's timer text and timer warning-color requests do not override the combat HUD. Character effects, music outside the standard round timeout branch, and map logic are unchanged.
- Existing map/character spawning is retained. Standard round initialization/intermission/map creation is disabled while endless mode is enabled; use the current combat arena/spawning workflow. This patch does not add a respawn menu or arena loader. Do not apply it expecting normal round-based map selection to continue.
- No stats redesign, data migration, monetization, character balance or currency amounts are included.

## Restore

Select the **EndlessCombat_Backup_...** folder in ServerStorage, run **Restore-Endless-Combat.command.luau**, save, and restart Play. Edited installed Sources are rejected to avoid overwriting later changes. Installer preflights both modules and the new child, checks integrity/Source limits, backs up, and rolls back on write failures. Repeat install is a no-op.

The new RoundManager/EndlessCombat child is enabled by default; its Enabled attribute can be explicitly false to let the original round code run. FCF's original RoundsDisabled/early-return behavior remains part of its original code. Restoring is the preferred way to undo this patch.

Local Luau tests cannot validate actual Studio rendering, multiplayer replication, or the player's current arena setup. Test normal death, respawn, kills, side portraits, a lone remaining player and long-running combat in Studio before publishing.

## Local verification

Both complete RoundManager and HUD source variants compile and execute in the Luau harness. Tests cover startup, late-join display, expiry far beyond the former limit, empty teams, explicit InitRound/EndRound/LMS/AddTime calls, paused countdown with advancing elapsed time, existing map-clock ownership, timer warning requests, BloodHunt text precedence, and disabled-policy HUD fallback. Installer tests cover both variants, mixed-build/edited-source refusal, repeat installation, exact restore and injected write-failure rollback. Actors, Hitboxes, PlayerInfoDisplay, Stats, Configuration and MapRotation Sources are outside the mutation plan.
