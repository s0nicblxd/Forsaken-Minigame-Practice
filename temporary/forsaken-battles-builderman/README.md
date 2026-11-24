# Forsaken: Battles — Builderman rework

Reconstructs the UPD's missing server-side construction/Carry logic on the existing FCT actor framework, retaining the donor client UI and visuals where compatible. Carry placement takes **1 second**, as requested.

## Latest: grounded placement and immediate input (v1.2)

For a Builderman port already on v1.1, stop Play and run `Repair-Builderman-Placement.command.luau` in the Command Bar, save, and start a fresh playtest. **No model reimport is required.** Config and asset models are untouched. The repair checks and backs up Builderman's Server/Client plus the shared ActorNetwork/ActorHandler Sources. Known Haste and no-cutscene ActorNetwork variants are supported; their existing behavior is preserved.

- Placement caches the building's resting ground lift before construction/Carry animations, then reuses it on drop and activation. It no longer measures the animated Carry pose to decide how high the building should sit.
- Builderman construction now predicts its movement lock locally when the ability request is made, clearing horizontal velocity and stopping movement without waiting for the server round trip.
- The request includes the click-time CFrame. Only Builderman Sentry/Dispenser callbacks receive it. The server requires finite CFrame components, a position within six studs of its current character position, and a usable horizontal facing; otherwise it falls back to the server pose. Normal ground/wall/spacing checks still apply.
- An accepted construction keeps the local lock until completion. Rejection, character cleanup, or an ignored-request timeout releases it.
- Other characters and the Carry slot continue through the ordinary request path. Existing Haste cooldown visuals and no-cutscene changes are retained.

The backup is named `BuildermanPlacement_Backup_*`. To undo this repair, select it in ServerStorage and run `Restore-Builderman-Placement.command.luau`. Restore this revision before older polish/full-port backups, since each checks the Sources it installed. The full installer also includes the latest input-routing changes for new installs and backs up/restores those shared modules.

## Existing installation: polish repair (v1.1)

Stop Play and run the entire `Repair-Builderman-Polish.command.luau` in the Command Bar. Save and start a fresh playtest. **No model reimport or full reinstall is needed.** The repair updates the existing Server/Client Sources, adds the CarryVisuals helper, and changes the placement timing in Config while preserving unrelated Config edits such as animation IDs. A `BuildermanPolish_Backup_*` folder supports rollback with `Restore-Builderman-Polish.command.luau`.

This revision fixes:

- Replacement building circles get their initial coordinates immediately; they no longer wait for pickup/movement. Destroyed circles are cleaned up promptly.
- Normal construction has the original **1.25s visual windup**, within its unchanged six-second total duration.
- Carry uses a **rigid weld to the character root**, instead of teleporting the model ten times per second. Carried parts are non-colliding and massless; the building's movement state machine is disabled so it cannot fight the carrier's physics.
- Pickup temporarily locks movement for the existing **0.75s Sentry / 0.5s Dispenser** pickup windows, independently of animation playback. Normal 10% Carry slowdown follows afterward.
- Placement locks movement, sprinting and abilities for **1 second**. The building reactivates and the locks clear at that deadline. Destruction/death also clears the locks.
- A yellow outline appears for **every survivor, including the owner**, only while carrying. Killers do not receive it. A dedicated local Highlight prevents an asynchronous or absent ordinary aura from hiding the effect; the prior normal aura state is restored on drop.

The full installer below includes these fixes for new installations. If restoring an older full-port backup after applying this repair, restore the polish repair first so its Source checks match.

## Install

1. Stop Play and save a copy of your place.
2. Insert `BuildermanUPD.rbxm` into **ServerStorage**, keeping the name **BuildermanUPD**.
3. Copy the entire `Apply-Builderman-Rework.command.luau` into Studio's Command Bar and run it in Edit mode.
4. Save, then start a fresh playtest and select Builderman normally.

The current Builderman Config and Behavior Sources are checked before installation. Unknown local changes cause a refusal without modifying the character. The installer clones the current character folder, retaining its rig/other children, and replaces Config/Behavior with the new modules and assets. The shared ActorNetwork and ActorHandler receive a Builderman-only construction request hook; their other logic is retained. A `ServerStorage/BuildermanPort_Backup_*` folder holds the original character; preparation failures leave the original untouched.

**Sentry asset fallback:** the latest UPD export contains an empty Sentry model. The installer deliberately preserves the complete Sentry from the current Builderman Config. The UPD Dispenser, warnings, highlight and mini-turret emote assets are present. The downloaded model contains 72 donor instances, with original executable Sources stripped.

## Behavior

### Construction and replacement

- Normal construction remains **6 seconds** for Sentry and Dispenser, including the **1.25s visual startup delay**.
- Casting construction does not start a cooldown. Replacing your previous building destroys it without a destruction cooldown or payout.
- The Sentry ability is locked for **10 seconds after a successful shot**; Dispenser is locked for **10 seconds after actual healing**. Activity is represented in the donor icon lock/recharge UI.
- A Sentry destroyed by a killer starts **35 seconds** of cooldown; a Dispenser starts **30 seconds**. The native hitbox's `RecentAttacker` and timestamp, recorded before health deduction, identify the attacker. Untagged/environmental removal, replacement and owner cleanup do not count as killer destruction. Fresh tagged killer damage that destroys a carried building also starts the appropriate cooldown.
- Damage to Builderman during normal construction cancels it and removes the unfinished building. Direct damage to an unfinished building also cancels it; killer-tagged building damage starts the destruction cooldown.
- Ground, wall, obstacle and building-spacing checks run on the server. Replacing a building ignores that same building during placement validation. Invalid construction sends a warning through a port-specific event because the native ActorHandler does not forward Cancelled results to its normal client callback.

### Building effects

- Sentry: **30 HP**, **3 damage/second**, Slowness II for 1s, reduced to Slowness I when more than one living Builderman is active. Targets living killer actors with line of sight.
- Dispenser: **15 HP**, **1 HP/second** to injured living survivor actors, excluding the native Clanker flag. Full-health targets do not refresh the activity lock.
- The donor treats these Config range fields as **diameters**: SentryDamageRadius 65 gives a **32.5-stud** targeting radius; DispenserHealingRadius 16 gives an **8-stud** healing radius. Placement fields 125/60 similarly give 62.5/30-stud spacing radii. This preserves the donor client calculations and circles rather than accidentally doubling reach.
- Sentry range falls by 16 percentage points of its base per additional active Sentry, with a minimum radius of 8 studs. Carried/unfinished/destroyed buildings do not apply effects.
- Existing building-destruction/contribution rewards use the native reward API when a killer destroys the building. Replacement and owner cleanup do not issue those rewards.

### Carry

- Uses the third ability slot, with the donor **Carry / Place** icons and names.
- The server selects **your own completed building within 7 studs**; client-provided targets/positions are not accepted.
- Pickup has the donor debounce: 0.75s for Sentry and 0.5s for Dispenser.
- Movement is reduced by **10%**, sprinting is disabled, and the donor carrying FOV/animation presentation is used.
- The building remains in the world, becomes non-colliding, massless and inactive, and follows the configured pickup offset using a rigid weld. Existing health and contribution totals remain intact.
- Pressing Carry again validates placement and puts the same building down. It becomes active **1s later**, independently of animation availability. Timing is checked every frame rather than being delayed by the slower effects loop.
- A single health change of **10 or more damage** while carrying destroys that building and releases Carry/sprint/FOV state.
- Carry/Place stays available while holding a building; it is not locked just because there is no separate nearby pickup candidate. Placement failure retains the carried building.
- Owner death/despawn cleans up buildings, loops, movement multipliers, ability locks and connections.

## Presentation and limits

The UPD client provides building ranges, nearby-building selection, placement warnings, activity locks, placed labels, Sentry aiming, carrying FOV, and model visibility changes. Character and building animation IDs are retained. Missing tracks do not hold movement locks or prevent construction/placement completion.

The retained older Sentry rig may need animation-ID adjustment if the donor's newer animations do not match it. Model alignment, build/carry visuals, media permissions and live multiplayer replication still require a Studio playtest. The server portion is a reconstruction; the client export does not contain the original server implementation. Older skin-specific flat SentryTemplate/DispenserTemplate overrides are honored, but skins have not been individually ported or visually tested.

## Validation

All command scripts and installed Sources compile with Luau. Ten standalone mock-based suites pass:

1. Actual server callbacks: normal construction, free replacement, activity locks, damage/slowness stacking, Carry ownership/inactivity, 1s placement, killer-only cooldowns, carried damage destruction, interruption, placement rejection and cleanup.
2. Full installer: old Sentry/rig preservation, donor asset integration, idempotence, exact restore, Source preparation rollback, local-edit protection.
3. Shared ability wrapper: independent callback routing and third-slot Carry/Place with no native charge consumption.
4. Actual donor Carry callbacks: missing animations, icon/name/FOV/sprint restoration, state cleanup and warnings.
5. Carry highlight: owner/other survivors, killer exclusion, ordinary-aura independence, deduplication and restoration.
6. Targeted polish installer: preservation of Config media edits, version/Source guards, idempotence, exact restore and each Source-write failure rollback.
7. Actual range setup: initial circle coordinates before any position-change event, with later position synchronization.
8. Click-time input: immediate zero multiplier/horizontal stop, captured pose, repeat/cooldown guards, unrelated-slot pass-through, ignored-request timeout and completion cleanup.
9. Placement repair installer: shared Source variants, Config preservation, idempotence, exact restore, all live-write failures and shared-edit refusal.
10. Actual UI request closure: Builderman-only snapshot forwarding, blocked prediction abort and ordinary character/Carry requests unchanged.

The server suite also distorts the carried model pose before placement and checks that the original resting lift is retained. It verifies a nearby click-time pose is used and a distant pose falls back to the server position.

A binary model round-trip verifies all 72 instances and local joint references, confirms the empty donor Sentry, and confirms executable donor Sources are stripped.

In Studio, test both buildings with a killer nearby; wait 10s after activity; replace a building; have the killer destroy it; carry/place both kinds; take 10 damage while carrying; attempt an invalid placement; die and respawn. Confirm the retained turret's animation compatibility.

## Restore

Stop Play, select the appropriate `BuildermanPort_Backup_*` folder in ServerStorage and run `Restore-Builderman-Rework.command.luau`. It restores the original Builderman folder. Save and restart Play. Restore checks all installed Sources and refuses to discard later edits.
