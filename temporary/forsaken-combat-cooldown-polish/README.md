# Cooldown and idle warning polish

## Apply

Stop Play in Studio. Copy the entire `Apply-Cooldown-Polish.command.luau` into the Command Bar and run it in Edit mode. Save and start a fresh playtest. No asset imports are required.

The installer checks all three current Sources first and stores their originals under `ServerStorage/CooldownPolish_Backup_*`. Both the latest no-cutscene ActorNetwork and the uploaded saved-build variant are supported. Unknown local changes are preserved by refusing installation. Source-write failures roll back.

## Changes

- Haste/Fatigue recovery corrections keep the client cooldown's original duration and adjust elapsed progress. They no longer reset its gray-to-white icon fill on each server update.
- Server recovery remains authoritative. Existing 10%-per-level recovery, half-strength Support Haste, exclusions such as Helperbot's Inspiration, ordinary cooldown starts, and legacy negative-delta messages are preserved.
- Active eligible Haste cooldown numbers turn green (`0,255,0`), matching the newer UPD presentation. The original text color returns when Haste ends or the cooldown finishes. Excluded abilities remain their normal color.
- The existing idle/tabbed-out scare warning text is red (`255,0,0`). Its words, timing, and other effects stay intact.

This changes only `Modules/StatusEffects/Haste/CooldownStatus`, `Systems/Player/Networks/ActorNetwork`, and `Systems/Player/Miscellaneous/TabbedOutScare`. Menu server support, gameplay settings, and other character ports are untouched.

## Checks

Luau compilation and three standalone suites passed:

- Actual server/client cooldown handlers simulated together: continuous progress, Haste recovery, Support scaling, Fatigue, excluded abilities, completion, and native cooldown reset/delta compatibility.
- Presentation code: green countdown eligibility, color restoration, and red idle warning.
- Installer: both supported ActorNetwork variants, repeated install, exact restore, each live Source-write failure, and local-edit protection.

These are mock-based checks. In Studio, use Helperbot's Inspiration during a cooldown, watch the icon fill/countdown, leave the aura until Haste expires, and check the idle/tabbed warning.

## Restore

Stop Play. Select the relevant `CooldownPolish_Backup_*` folder in ServerStorage, then run `Restore-Cooldown-Polish.command.luau`. Save and restart Play. Restore refuses to overwrite modules edited after installation.
