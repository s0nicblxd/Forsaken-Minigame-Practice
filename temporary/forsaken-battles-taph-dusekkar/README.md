# Taph, Dusekkar and Corrupt Nature update

Apply-Taph-Dusekkar.command.luau patches existing Sources from FCTbuildrermanbuggy.rbxl. Stop Play, save a copy, run the script in Studio's Command Bar, save, and start a fresh Play session. No model import is required. The fifth Taph update is excluded as requested.

The installer edits only supported fragments, preserving unrelated custom asset IDs and Config changes. It prepares all changes before writing, backs up actual original Sources to ServerStorage, and rolls back writes on failure. Unsupported edited fragments are rejected before changes. Restore-Taph-Dusekkar.command.luau restores the latest backup.

## Taph

- Throw collision uses a swept sphere from the character to the initial mine position and during flight, excluding actors and respecting collidable map geometry.
- Killer detection uses line of sight, checking all nearby candidates rather than letting a hidden nearest killer hide a visible one. Explosion targeting intentionally retains wall penetration.
- Detection/blast radius 19 studs, detonation delay 0.5s, stacking penalty 2s per additional living Taph.
- Normal explosion: Subspaced III 6s, Helpless I 3s, Weakness V 6s. Killer-struck mines apply only Subspaced I to the striking killer; self-hits retain full effects. Durations clamp at zero; zero-duration mine statuses are skipped.
- Tripwires arm 1.5s after placement, with a 1.5s stacking penalty. Stacking now counts living Taph actors rather than applying Lua's length operator to an actor table.
- Owner death immediately triggers pending/active mines, including unarmed mines, and removes tripwires. Removed actors also clean up their traps. Detonation callbacks cannot run twice.

## Dusekkar

- Plasma Beam: Slowness I for 4s, Speed I for 3s, base Overheal 25, cooldown 28s. Existing additional-Dusekkar reductions remain.
- Spawn Protection: cooldown 35s; protect-again restriction 30s. AzureGrabbed survivors can be targeted while anchored; other target restrictions remain.
- Zapping a Survivor adds 0.5 Malice. Fully preventing death adds 1 Malice in the shared damage utility. Existing money and XP rewards remain; Malice stays hidden in the combat UI.

## c00lkidd

Only Corrupt Nature's hardcoded ability cooldown changes, from 16s to 13s. Other donor differences, such as health and price, are outside this request.

## Validation and limits

Luau compilation; mocked runtime tests covering final Config values, living-player stacking, multiple detection candidates and walls, initial throw sweep, delayed/death/unarmed mine detonation, duplicate suppression, wire/flight cleanup, and anchored/vine/hook target restrictions. The actual production explosion status branch is exercised for normal, weakened, self-hit, stacked and zero-duration cases. Installer tests use all eleven actual uploaded Source targets and cover repeat runs, rollback, custom Config preservation and preflight rejection.

The donor lacks the relevant server callbacks, so confirmed server behavior is adapted within the existing working code. No unverified fifth-update changes or donor asset/animation replacements are included. Roblox Studio physics, visuals and multiplayer gameplay still require live verification.
