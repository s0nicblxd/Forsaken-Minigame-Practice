# Gear Puzzle source research
Sources: minigame-52470.lua (client), 52471 (renderer), 52472 (input).
Full UI properties: gear-properties.json (decoded from supplied RBXL).
All four gear icons reuse rbxassetid://103208952186791, tinted RGB118.
Download: https://assetdelivery.roblox.com/v1/asset/?id=103208952186791
Fetching returned HTTP403; no image bytes obtained.

PC mouse movement alone turns; touch movement turns and release resets angle.
Pointer deadzone12px; wrapped angle steps over90 degrees ignored; clockwise adds,
counterclockwise subtracts, clamped0..Turns*360. Default Turns6 but network can
supply different value. Controller left stick deadzone0.5, X exits.
Tick on crossing an upward45-degree boundary. lineConnect at full progress.
Gear arrives after450ms opening, flies from inventory for600ms QuadOut,
growing to1.5x; input enabled on arrival. Progress shrinks scale1.5->1.
Inventory filled gears spin90deg/s. Completion spins active gear480deg/s and
machine gears -480deg/s; puzzleDone after1.2s from completion. Close500ms.
Tutorial says five gears fix generator. MaxGears is network-supplied; default0.
Source has map gear inventory dependency; website endless practice will need
an explicit local supply adaptation. Actual server Turns/MaxGears overrides
not recovered. Tick sound ID unresolved; completion sounds already in website.
No website implementation changes made in this research turn.

## Website implementation
The user supplied the PNG in 99d3c3d8be821784064572dd19ae87b6.zip;
it is embedded for offline play and also stored as assets/gear/gear.png.
Compared layout/animation against Recording 2026-10-25 204531.mp4.
Unlimited automatic gear supply replaces map pickups. Three completed gears
award exactly one puzzle point; next set starts automatically. Six full turns
per gear use the client default. Progress is clockwise and reversible; >90deg
input jumps and the 12px center deadzone follow source behavior. Mouse motion
needs no held button; touch captures one finger and clears on release.
The entrance takes450ms plus600ms flight; completing spins the gears for1.2s
before the usual board shrink/grow. Completion cue plays on the third gear.
The first three-gear completion dismisses the tutorial with smooth recentering.
The tick uses the existing circle click as a temporary substitute. Controller
input from the Lua source is not yet ported.

Validation: Chromium mouse and touch events, reverse/jump handling, input gated
while entering/completing, zero points for gears1/2, one point for gear3, single
completion cue, automatic supply, exit cleanup, desktop/mobile tutorial layout.

## Requested follow-up adjustments
Four full rotations (1440 degrees) now complete each gear, overriding the Lua
client's six-turn default. Removed the gear inventory/count HUD entirely.
Every completed gear plays puzzleDone after its spin; scoring remains exactly
one point per three gears. Legacy also uses the shared generator completion
cue. Verified four-turn boundary, per-gear sound count, scoring, and cleanup.

Tutorial now dismisses after the first completed gear, independently of the
three-gear scoring threshold. Verified first-gear dismissal and unchanged scoring.
