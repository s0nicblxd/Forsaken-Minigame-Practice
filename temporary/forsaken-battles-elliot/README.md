# Forsaken: Battles — Elliot rework

Ports the latest supplied Elliot values and UPD presentation onto the existing FCT actor framework. Original server callbacks are missing from the UPD client export; this package reconstructs the gameplay using the native actor, healing, status, cooldown, reward, and objective APIs.

## Install

1. Stop Play and save a copy of your place.
2. Download `ElliotUPD.rbxm` and insert it into **ServerStorage**. Keep its name **ElliotUPD**. It contains the donor scooter, pizza timer GUI, and particles. Original donor executable Sources are stripped.
3. Copy all of `Apply-Elliot-Rework.command.luau` into Studio's Command Bar and run it in Edit mode.
4. Save, then start a fresh playtest and select Elliot normally.

No replacement character rig is necessary. The current Elliot folder is cloned so existing rig references/other children remain, then Config and Behavior are replaced. The current rig stored in ServerStorage stays intact. The installer adds Exhausted and updates Sprinting and PlayerInfoDisplay. The earlier optional ServerList HUD guard is preserved. Other characters, menus, Haste cooldown repairs and combat server features remain untouched.

If a Source fingerprint check refuses installation, send that current module. Nothing is changed before all checks pass. A unique `ServerStorage/ElliotPort_Backup_*` folder stores the original Elliot and shared module Sources. Live-write failures roll back.

## Scooter visibility repair for existing installs

If the scooter model appears under Elliot during Rush Hour but is invisible, stop Play and run `Repair-Elliot-Scooter.command.luau` in the Command Bar. Save and start a fresh playtest. No asset reimport or full reinstall is necessary.

The donor scooter mesh and handle are both saved with Transparency 1. The repaired Server module makes the scooter mesh visible when spawning it, while retaining the invisible handle, authored joint offsets, and non-colliding massless setup. Visibility does not require riding animations. The full installer includes the same fix for new installs. The repair checks the existing Server Source and creates a separate `ElliotScooter_Backup_*` folder.

## Riding alignment and expression repair

For the current installed port, stop Play and run `Repair-Elliot-Riding.command.luau`, save, then start a fresh playtest. No model import is required. This also includes the earlier visibility correction, so either pre-repair Server version is supported.

The donor joint's lateral/backward offset is replaced with a centered attachment. The internal scooter weld and C1 are retained. A skin can override `RushHourScooterOffset` with a CFrame if its rig needs a different fit. The native Happy expression is requested for the full Rush Hour speed duration (4s); native hurt/death expression handling remains in charge of interruptions. Final riding pose still depends on the riding animations.

## Scooter floor-clearance repair

For an existing installation, stop Play, run `Repair-Elliot-Scooter-Ground.command.luau` in the Command Bar, save, and restart Play. No asset import is needed. It supports all three earlier Server versions and includes the previous visibility and Happy-expression fixes.

The scooter now mounts to HumanoidRootPart instead of the animated torso. Its visible part bounds are measured relative to the handle. During Rush Hour, a downward raycast against `Workspace.Map` computes a small upward clearance correction; the value is recomputed from the base mount each frame, so it does not accumulate. With no floor hit it follows the root without retaining a stale lift. The correction affects only the cosmetic scooter. Rush-end/death cleanup disconnects the mount updater. The ground fitting is a reconstruction; the donor client export does not contain the original scooter binding/vibration implementation.

Runtime checks cover ground clearance, raised floor, repeated-update stability, airborne reset, root attachment, visibility and cleanup. Final wheel placement and riding pose still require Studio testing with the actual mesh and animations.

## Mechanics

- **Pizza Throw:** 34s cooldown, 0.5s release, 2s ability lock, 60 throw force, 15s lifetime. The existing pizza part is cloned and thrown with server-owned physics.
- **Healing:** 5 immediate HP and 15 HP across 4 seconds, plus Order Up's overtime bonus. Taking **5 or more damage in one health change** interrupts the remaining overtime healing. The final healing step is capped to prevent frame-time over-healing.
- **Order Up:** +2 healing per native objective-progress callback, capped at +10, with the donor animated bonus display. Maps without working objectives will not naturally build this bonus.
- **Stacking:** each additional living Elliot imposes a 40% initial penalty, then +18 percentage points per further Elliot, capped at 90%. It affects instant healing, base overtime healing and Order Up's bonus. Receiving pizza as another Elliot halves the resulting healing again.
- **Pickups:** only living survivor actors registered in the server actor system can eat pizza. The caster, killers, unregistered 007n7 clone rigs, full-health survivors, and actors with the native Clanker flag cannot consume it. A pickup can be consumed once. Actual healing grants at most one Rush Hour charge; healing another Elliot grants none. The native Support healing reward remains in use.
- **Rush Hour:** 30s cooldown; starts with one charge, stores three. With a living killer within 85 studs, consumes all charges and grants matching Speed I–III for 4s. Afterward, matching Exhausted I–III lasts 4s. Outside that range it grants Speed I for 4s, preserves charges and applies no Exhausted. The old handler's automatic one-charge deduction is bypassed; the reconstructed callback owns consumption.
- **Exhausted:** +5% stamina drain and -5% regeneration per level, and a red stamina bar. Refreshing the effect updates a level attribute rather than compounding or restoring stale base stamina stats.
- **Presentation:** donor scooter mesh/texture/joints attached during Rush Hour, optional startup/loop/end animations, reddish Rush Hour range tint, health-colored injured-survivor auras, floating pizza lifetime counter, green plus particles and pizza auras. Missing/unavailable animation tracks do not prevent the ability callbacks from finishing. Media IDs still require permissions in your experience.
- Projectiles, scooter models and owned connections are cleaned up on death/despawn. Pickup is checked server-side without trusting a client-reported target.

## Rush Hour rewards

The user-selected FB payouts are **$2 / 10 XP** for activation and **$5 / 18 XP** for escaping with Rush Hour, with no additional malice. These use the existing server reward API and its normal server restrictions.

The original escape condition is absent from the UPD export, so this port uses a documented reconstruction: Rush Hour must start empowered; at the end of its 4s Speed duration Elliot must still be alive and no living killer may be within 85 studs. The original nearby killer must still be a living killer actor, so its death or removal cannot award an escape. The escape payout can occur only once per activation. An unempowered activation receives only the activation payout. Values are configured in `Config.RushHourRewards`.

The scooter is attached using the donor joint offsets and animated with the supplied IDs. Its alignment, animation permissions and final appearance need a Studio playtest; they cannot be visually validated by standalone Luau tests.

## Validation

All installed Sources and command scripts compile with Luau. Five runtime suites pass:

- Server callbacks: empowerment/charge use, duration/Exhausted, activation/escape payouts and duplicate/dead-killer rejection, Order Up, stacking calculations, actual projectile/pickup/overtime path, 5-damage cancellation, clone filtering, projectile lifetime and cleanup.
- Transactional installer: source checks, asset preservation, idempotence, exact restore, all preparation/live Source-write failure points.
- Exhausted: repeated refresh, level changes, removal and stamina multipliers.
- Client animations: throw/start/loop/end, unavailable tracks and interrupted delayed callbacks.
- Scooter creation: invisible donor mesh becomes visible without animations, handle remains hidden, original offsets and attachment are retained, and the template is unchanged.

A binary model round-trip also confirms all 14 donor instances, original scooter mesh/texture, timer/particles and valid local joint/object references. Tests use Roblox API mocks; the game still needs Studio testing.

Suggested playtest: throw pizza to another survivor, take exactly 5 damage during healing, test a second Elliot, build three charges, Rush with a killer near/far, check the scooter, then die/respawn and confirm the stamina bar returns to normal.

## Restore

Stop Play, select the appropriate `ElliotPort_Backup_*` folder in ServerStorage, and run `Restore-Elliot-Rework.command.luau`. It restores the original character folder and shared module Sources and removes the new Exhausted status. Save and start a fresh playtest. Restore refuses shared modules edited after installation.
