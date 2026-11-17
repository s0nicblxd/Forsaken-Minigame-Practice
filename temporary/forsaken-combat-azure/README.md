# Azure — FCF fixes ported to FCTtest2

Apply this to the uploaded **FCTtest2.rbxl after the Reworked Guest patch**. It ports Azure's fixed FCF behavior, construct modules, client modules, Config, and uploaded animation IDs while adapting the missing FCT APIs. It does not replace the place file.

## Apply

1. Stop the Studio playtest.
2. Open `Apply-Azure-FCT.command.luau` on this test branch, click **Raw**, and copy the entire file.
3. Run it in Studio's **Command Bar**.
4. Look for `[Azure FCT Port] Applied 14 scripts`, save the place, and start a fresh playtest.

The script checks all targets before writing anything. A source mismatch stops the whole patch and names the module; send that current script rather than removing the check. Reapplying an already installed patch changes nothing.

The installer also checks Studio's 200,000-byte Source limit before writing. Azure's Behavior uses compact indentation (165,307 bytes); its compiled bytecode is identical to the uncompressed version. If the earlier installer reported a Source-length rollback, use this updated installer directly with playtesting stopped.

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

- All 14 resulting scripts and both command scripts compile with Luau.
- Executed the actual Config: previous balance values and uploaded grab animation IDs match.
- Executed Atropa callbacks: cap, expiry awards for 1–6 stacks, and no expiry bonus on consumption/manual removal/death.
- Executed sprint helpers: independent stamina-freeze owners and held-key recovery.
- Executed grab cleanup with a victim disappearing inside a callback: no remaining grab flag, ability lock, root anchor, or PlatformStand.
- Executed golem-return cleanup: 1.5× playback, bounded release, and idempotent cleanup.
- Executed the installer against mock Instances: all 14 outputs match, the missing Atropa module is created, reapplication is safe, and source mismatches reject all writes.

These checks do not replace Roblox Studio tests of physics, networking, animations, and the playtest cases above.
