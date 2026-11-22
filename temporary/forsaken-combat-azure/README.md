# Azure — FCF fixes ported to FCTtest2

Apply this to the uploaded **FCTtest2.rbxl after the Reworked Guest patch**. It ports Azure's fixed FCF behavior, construct modules, client modules, Config, and uploaded animation IDs while adapting the missing FCT APIs. It does not replace the place file.

## Apply

1. Stop the Studio playtest.
2. Open `Apply-Azure-FCT.command.luau` on this test branch, click **Raw**, and copy the entire file.
3. Run it in Studio's **Command Bar**.
4. Look for `[Azure FCT Port] Applied 14 scripts`, save the place, and start a fresh playtest.

The script checks all targets before writing anything. A source mismatch stops the whole patch and names the module; send that current script rather than removing the check. Reapplying an already installed patch changes nothing.

The installer also checks Studio's 200,000-byte Source limit before writing. Azure's Behavior uses compact indentation (165,307 bytes); its compiled bytecode is identical to the uncompressed version. If the earlier installer reported a Source-length rollback, use this updated installer directly with playtesting stopped.

If you already applied the port and startup reports `Maid is not a valid member of Folder "ReplicatedStorage.Modules"`, stop the playtest and run `Repair-Azure-Module-Paths.command.luau`. It repairs four Azure client/QTE modules (five require references), mapping Maid and Signal to FCT's `Modules.Misc` folder, and makes backups. Start a fresh playtest afterward to clear failed module-load caches. The full installer now includes the correction and also supports upgrading that earlier port.

Backups are placed in `ServerStorage/AzureFCTPort_Backup_<timestamp>`. To undo, stop playtesting and run `Restore-Azure-FCT.command.luau`. It restores the newest Azure backup, including removing the newly added Atropa module, while retaining the earlier Guest fix.

## Port contents

- Enstrangle's three-dimensional aim and projectile, fixed-duration pull, success animation, hold, throw, impact, and cancellation flow.
- Cleanup when either character dies, resets, despawns, or is removed. Added a validity check after the initial melee callback so interrupted setup cannot reapply locks after cleanup.
- Fixed pull direction while Azure turns, plus movement/animation state restoration and server physics ownership handling from the FCF version.
- Sprint restriction while aiming/pulling and recovery while holding; 75% stamina regeneration reduction ends when the survivor is thrown or released.
- Press Perforating to throw while holding; press Enstrangle to release without throwing. Release cancellation applies two seconds of Helpless.
- Impact display, nearby-plant triggering, and the close-throw penalties from the fixed FCF build.
- Golem transition cleanup, five seconds of Inflorescence invincibility, 1.5 seconds on Burrowing, and 1.5× exit-animation playback with bounded root-lock cleanup.
- Stigmatize's fixed server callbacks and updated client/QTE modules.
- Seeker Bulb and Stigmatize spawn exclusion, including the existing rejection message.
- The earlier Azure balance settings: 20-second Enstrangle cooldown, 2.5-damage/slower-firing bulbs, 10-damage taller Vine hitbox, 1.5-second release Speed, 30-damage Blooming, and 10-damage/50%-slowing Unearthing.
- Adds the Atropa module missing from FCT. Stacks cap at six; natural expiry grants at least one Oblation and one per two stacks. Consumption, manual removal, death, and reset do not also award an expiry bonus. Plant stacking retains the original timer through the construct code.
- Adds the missing melee-hitbox helper and small utility/sprint compatibility functions without replacing FCT's movement controller or removing the Guest hitbox fixes.

The extra FCF aiming-particle object is not present in FCT's asset tree. That optional reference is guarded; the existing beam and target indicator remain in use. No additional models or animation uploads are included.

## Studio playtest

1. **M1s:** Azure's Perforating and golem main attack should still be blockable by Guest. Specials/projectiles should still break Block.
2. **Grab:** Hit at close and long range, including targets above/below you. Check pull timing, success-animation freeze, then sprint while holding. Turn using shiftlock while pulling.
3. **Release:** Throw with Perforating, cancel with Enstrangle, and allow an automatic throw. Check stamina recovery immediately after release, Helpless, impact behavior, and nearby plants.
4. **Interrupted grab:** Despawn/reset the victim during pull, success, hold, and flight; also reset Azure. Neither character should retain grab movement locks or animations.
5. **Golem:** Enter, use all three attacks, Burrow, and repeat. Azure should regain movement after the exit animation or its cleanup failsafe.
6. **Plants/Atropa:** Place each plant away from spawn, disarm it, test blooming Vine with walking versus sprinting, build six Atropa stacks, consume them with Perforating, and allow a separate stack to expire naturally.

For cross-killer grabbing such as Sixer, use the build's existing FriendlyFire setting. This patch does not enable free-for-all globally or implement combat spawning/round flow. Asset permissions still apply to the saved animation IDs.

## Verification completed here

- All 17 resulting scripts and both command scripts compile with Luau.
- Executed the actual Config: previous balance values and uploaded grab animation IDs match.
- Executed Atropa callbacks: cap, expiry awards for 1–6 stacks, and no expiry bonus on consumption/manual removal/death.
- Executed sprint helpers: independent stamina-freeze owners and held-key recovery.
- Executed grab cleanup with a victim disappearing inside a callback: no remaining grab flag, ability lock, root anchor, or PlatformStand.
- Executed golem-return cleanup: 1.5× playback, bounded release, and idempotent cleanup.
- Executed the installer against mock Instances: all 17 outputs match, the missing Atropa module is created, reapplication is safe, and source mismatches reject all writes.

These checks do not replace Roblox Studio tests of physics, networking, animations, and the playtest cases above.

## Enstrangle nil-configuration repair

If the server reports `number < nil` at the grab windup and the client reports `Vector3 and nil` in the aiming beam, use `Repair-Azure-Grab-Config.command.luau` with the playtest stopped. Those expressions require `Config.Grab.Windup` and `Config.Grab.HookRange`, which the older FCT Config does not define. The full installer already carries these fields, but an older or incomplete runtime Config still needs normalization.

The repair creates `Behavior.GrabConfigDefaults` and routes creation, grab callbacks, aiming, and holding through the resolver. Missing/invalid parameters receive the port's defaults (windup 1s, range 60 studs, hook speed 270, pull time 0.8s, and the remaining grab fields). Valid custom fields, skin settings, and zero windup are preserved. It backs up Behavior, validates the expected source shape and Studio's Source limit before editing, and rolls back on a write failure. Run it once, then start a **fresh playtest**; existing stuck actors and cached requires are not repaired in place.

Verified with Luau: both original nil expressions fail on the actual old FCT Config; the resolver repairs them; complete port Configs and custom tuning remain unchanged; malformed fields and immutable partial tables are handled; the actual Command Bar repair produces the canonical patched Behavior/helper and is safe to repeat. Roblox physics and networking still require a Studio playtest.

## Play without Azure animations

Run `Repair-Azure-Optional-Animations.command.luau` with playtesting stopped, then start a fresh playtest. It supports the existing Azure port and includes the grab-config resolver. It adds `Behavior.OptionalAnimations`, updates Azure's animation loads and plant client modules, and adds an **Azure-only** branch to FCT's shared `ActorNetwork` movement initialization. Other characters keep their original loader. Source versions and size limits are checked before writing; changed modules are backed up and failed writes are rolled back.

Missing IDs, synchronous loading errors, and assets whose tracks stay at zero length receive non-blocking visual stand-ins. They support the track operations used by Azure, stop/completion signals, and cancellation/destruction. Valid tracks remain usable. The old utility's up-to-25-second animation preload waits are bypassed for Azure, and unnecessary Azure preloads are removed. Normal, injured, grabbing, and golem movement states can request absent tracks without indexing nil. Plant wither/idle transitions also advance when their animation files are unavailable.

Fallback grab-success presentation lasts about 0.5 seconds; fallback throw presentation about 0.35 seconds. Reel travel still uses `Grab.PullTime`, and damage, release, stamina, and cooldown behavior remains in the existing gameplay code. Golem exit releases its root in under 0.8 seconds at 1.5x fallback playback, with the existing five-second safety cleanup retained. No assets are reuploaded or granted permissions by this patch.

Azure's cinematic introduction uses the existing short display fallback while this testing mode is active. Set `AzureAnimationsOptional = false` in Azure's Config when its introduction assets are ready to opt back into the cinematic path. Ability animations remain optional either way.

Executed regression checks cover absent IDs, denied loads, zero-length tracks, valid tracks, looping aim, plant transitions, replay/cancellation cleanup, the actual grab success/throw wait function, and the actual golem-exit root cleanup with an empty animation table. All 17 resulting modules and the full/repair installers compile under Luau and fit the per-module Studio Source limit. Studio physics/network testing remains necessary.


## Azure execution repair (reworked Two Time)

After the existing Azure and Two Time ports, stop Play and run `Repair-Azure-Execution.command.luau` in Studio's Command Bar, then save and start a fresh playtest. It repairs the Two Time-specific `OnExecution` nil lookup for a missing `GhostFire.GhostfireBlade`, makes the vignette optional, and guards delayed callbacks against a removed victim. The original 1.333s/2.65s/3.217s Two Time sequence and 2.783s generic explosion timing are retained. Optional ragdoll setup cannot prevent the final kill; an already-dead victim is never restored to 0.01 health.

The repair replaces only the recognized execution callback and adds its `ExecutionCompatibility` child module; it preserves other edits to Azure. It updates both ReplicatedStorage and ServerStorage copies if present, makes `ServerStorage.AzureExecution_Backup_…`, validates source sizes, and rolls back on write failure. Run `Restore-Azure-Execution.command.luau` in Edit mode to restore the latest backup. If the callback itself differs, preflight refuses to change anything and requests that source.

Local regression checks cover missing blade/UI, legacy cosmetic behavior, mid-execution deletion, already-dead victims, generic timing, dual-copy installation, preservation of unrelated source, repeated install, restore, and injected Source write failures. Studio animation/rendering tests remain necessary in the user's place.

The execution repair now compares executable tokens rather than raw callback text. It accepts indentation, blank-line, line-ending, and comment differences while still rejecting changes to executable code or quoted strings. Restoration preserves the exact original source formatting.
