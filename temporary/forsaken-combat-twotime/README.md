# New Two Time kit for FCTtest2

Studio Command Bar installer for the current FCT combat build, following the newest supplied UPD configuration and the user's ordered patch notes. No new kit animation IDs are loaded and no kit sounds are played. Existing generic locomotion remains in use. Public ability icons, expressions, FCT life models, dagger, Ritual effects and Oblation UI are retained.

## Latest repair: hitbox revert and held Pray symbol

If you installed the polish repair, stop Play and run **Raw** `Repair-TwoTime-Hitboxes-Pray.command.luau` in Studio’s **Edit-mode Command Bar**. It updates four modules (Config and Server in both snapshots), with backups and repeat-run protection. The first working port’s hitbox setup is restored for standing and crouched stabs: 4 × 6 × 5.5, offset 7, shared prediction/placement, and default line-of-sight origin. The actual-transform backstab test is retained. This deliberately reverts the unsuccessful close-range geometry adjustment; it does not claim verified live-game hitbox geometry.

Pray’s startup floor Spawn glyph now emits continuously for the whole hold alongside the existing looping effects. Release, interruption and other stop paths disable and clear floor glyph particles. The softer miss penalty, messages, VFX, indicator and meter polish stay in place.

## Upgrade the already-working port

Stop Play, copy the entire **Raw** `Repair-TwoTime-Polish.command.luau` file into Studio's **Edit-mode Command Bar**, and save/start a fresh playtest. It updates 10 Two Time modules, imports the exported visual properties, and leaves the installed shared Weakness/Azure/Guest changes alone. A fresh installation can use the full installer below; it also accepts the previously published working port.

The current repair includes the hitbox revert above, makes miss Slowness start beyond 30 studs, restores UPD's one-stud-wide textured indicator and endpoint particles, adds Pray's exported VFX and warning feedback, and restores conditional meter visibility. Animations/audio remain omitted.

## Apply

1. Use your current FCT place with the Guest compatibility fix and the latest Azure optional-animation repair already applied. Save a copy of the place.
2. Stop Play. Open `Apply-TwoTime-FCT.command.luau` in GitHub's **Raw** view, copy the entire file, and paste it into Studio's **Command Bar in Edit mode**.
3. Wait for `[Two Time FCT Port] Applied 29 modules`, save, and start a new playtest. Select the default Two Time.
4. Do not paste the installer into a Script's Source property: the installer contains several modules. Each installed module is below Studio's 200,000-byte Source limit; the largest is 160,512 bytes.

The installer updates both ReplicatedStorage and ServerStorage Two Time snapshots. It also installs the Weakness/Vulnerable migration and damage-path support described below. It checks exact source fingerprints before changing anything, backs up affected modules in ServerStorage, is safe to run twice, and rolls back writes if an assignment fails. If a module was edited separately, it stops with its path instead of overwriting the edits.

`Restore-TwoTime-FCT.command.luau` restores the latest backup, including the shared status/damage changes. It refuses to erase edits made after installation. Apply older Guest/Azure installers before this port, not afterward; their source guards will correctly notice this port's newer shared modules.

## Kit

- **Dagger:** 30s cooldown, 0.3s windup, 10 front damage / 20 back damage, Resistance I for 0.7s. Standing backstabs stun for 2s. Crouched backstabs scale from 2 to 3.5s over the first second crouched, sampled at stab activation. Backstab detection uses actual root transforms, not extrapolated actor pivots. Standing lunge is restored (force 50); crouched force is 110. No lifesteal.
- **Oblation:** 20% per front stab, 40% per backstab, multiplied by 1.25 for crouchstabs. Capped at a full meter; summons and stun-immune/already-stunned targets grant none. The meter can decrease after reaching full. It starts hidden, appears on meter changes or while praying, and retracts/hides five seconds after the last change; reaching full does not pin it permanently.
- **Crouch:** 30s cooldown setting, reduced by elapsed crouch time down to 15s; 1s initial toggle delay; 15s maximum duration. Walk 10, run 23, Invisibility III and Undetectable I, footsteps muted. Running toward a killer within 105 studs builds up to 50% extra speed over 4s. Damage, stopping the approach, and leaving crouch reset the bonus. Nearby survivor teammates can see a fading highlight within 100 studs. UPD’s textured one-stud-wide beam and endpoint particles preview lunge travel, follow the ground, exclude characters from obstruction checks, and hide while Dagger is unavailable. Manual uncrouch within 30 studs of a killer gives Speed II for 1s.
- **Missed crouchstab:** Slowness II starts beyond 30 studs and increases by 1s per additional 10 studs, up to 8s. No killer means no miss penalty. Crouch endlag 0.225s and recovery tween 0.15s; sprint lock 1s.
- **Pray:** hold AltAbility3 or hold the hotbar button within 10 studs of your Ritual. Converts 1.5% Oblation into 1 HP, up to 66.67 HP per full bar, with a 10s full-conversion setting. Movement/jumping are locked while praying. Release, focus loss, leaving range, full health, depleted meter, interruption, or a lost client hold lease stop it. Damage totaling 5 during the channel interrupts it and gives a 6s cooldown. Attempting it outside range reveals the Ritual for 4s. It has no normal cooldown. Actual UPD startup and looping particle/beam/light properties are restored, with VFX shutdown on release or interruption. Missing Ritual, empty Oblation, full health, distance and interruption produce warnings using FCT’s warning template. The out-of-range marker spins, slows and fades.
- **Ritual:** AltAbility4, one placement per character life cycle, 3.5s action, ground/wall/nearby-Ritual placement validation. A full bar and placed Ritual prevent one lethal hit, teleport you back, and switch appearance.
- **Second life:** 50 maximum HP, full healing, +40 stamina, status cleanse, 2s invincibility, Speed II for 6s, Vulnerable V for 12s. Stale crouch, dagger, prayer and Ritual locks are cleared. A full meter without a Ritual does not prevent death.

FFA adaptation: dagger hits can affect either team and gain Oblation from eligible survivor or killer actors. Crouch approach bonuses and miss distance still use the nearest killer, matching the supplied kit's targeting rules.

## Weakness and Vulnerable

Both use the supplied UPD status implementations:

- **Vulnerable:** +20% damage taken per level. V doubles incoming damage. This is the old Weakness behavior under its new name.
- **Weakness:** -10% outgoing attack damage per level. Applied once before victim resistance; level X reduces outgoing attack damage to zero.

Shared Hitboxes applies Weakness to its attacker. Util.ApplyDamage gains an optional fourth `damageSource` argument, preserving the existing third minimum-health argument. Direct offensive calls in Two Time, Azure's grab, c00lkidd's delivery minions, Noli's clone and 1x's zombies now supply their owning rig. Source-less periodic damage, environmental damage and self-damage keep their existing behavior rather than incorrectly reading Weakness from the victim.

Chance's existing penalty and Slateskin's old status removal now target Vulnerable. Chance's achievement ID and internal stat/config identifiers are preserved. The other global changes in the supplied notes—Sentinel stacking, Exhausted, terror radius, new stun-immunity visuals and global particle hiding—are deferred.

## Continuous combat and reconstruction limits

`Config.TwoTimeRoundHooks = false` is the default. Simply being alone in Studio therefore does not consume the second life. Resurrection works independently of survivor count and the round timer. Optional round hooks preserve proportional LMS bonuses and an adapter for the 15s/25s split; they are not part of the verified continuous-combat path and must be checked against your eventual round manager before enabling them.

The exported UPD does not contain full authoritative ability callbacks. Several gameplay details therefore had to be rebuilt:

- Hitbox size, offset and shared placement/prediction are restored to the first working port after the polish geometry failed Studio testing. Exact live-game geometry cannot be verified from these exports.
- The 30-stud grace distance is a deliberate fairness adjustment after playtest feedback; the export does not reveal the authoritative miss formula. Beyond it, the exported interval/multiplier/cap settings are used.
- Prayer damage interruption uses cumulative damage during a channel. The exported setting supplies the threshold but not the complete implementation.
- Visuals.luau reconstructs the actual UPD Beam, endpoint emitters and Pray hierarchy from typed instance properties, including attachment transforms and references. Public textures are used directly; no external model download or restricted media is required. Warning wording and VFX activation timing are reconstructed because the export lacks those server callbacks.
- Multiple-Two-Time Oblation requirement scaling is not inferred from the unused config field.
- Skin-specific custom behavior and future private animations/audio are outside this default-kit port.

## Validation

All 29 installed modules plus the installer/restore compile with Luau. Mocked regressions execute actual port callbacks and cover:

- Windup, front/back detection, charged stuns, meter gains, immunity/summon exclusions, missed attacks, and interruption cleanup.
- Heartbeat-driven speed buildup/reset, held Pray leases, healing ratios, partial spending, full-health stops, stale-client release, one-use lethal revival and explicit proportional LMS math.
- Client meter updates after full, initial hiding, inactivity hiding, Pray reveal, late input release, focus loss, mouse release outside the hotbar, sprint-lock recovery, cooldown-gated indicator visibility and ground placement.
- Visual factory creation and writable property checks against Roblox’s API schema, exact beam widths/textures, attachment references, startup particle emission and prayer effect cleanup.
- Weakness/Vulnerable application/removal and actual Util/Hitboxes arithmetic, including their combined effects and legacy migration.
- Installer atomic preflight, simulated write-failure rollback, repeat application and restoration, including upgrading and restoring the previously published working port.

Run `luau regression.luau`, `luau client-regression.luau`, `luau damage-regression.luau`, and `luau visual-regression.luau` with the Luau CLI. The installer regression harness was also run locally. These are mocked tests, not a claim of a Roblox Studio playtest.

Studio checks: place Ritual; land standing and charged crouchstabs on the Slasher bot; spend a full meter through Pray; release the key and click outside the button; take damage while praying; test a missed crouchstab; refill Oblation and take lethal damage. Verify the second lethal hit kills, no automatic solo LMS activation occurs, and Guest/Azure still function. Also verify camera/footstep behavior and physical lunge/teleport clearance in your map.
