# New Two Time kit for FCTtest2

Studio Command Bar installer for the current FCT combat build, following the newest supplied UPD configuration and the user's ordered patch notes. No new kit animation IDs are loaded and no kit sounds are played. Existing generic locomotion remains in use. Public ability icons, expressions, FCT life models, dagger, Ritual effects and Oblation UI are retained.

## Apply

1. Use your current FCT place with the Guest compatibility fix and the latest Azure optional-animation repair already applied. Save a copy of the place.
2. Stop Play. Open `Apply-TwoTime-FCT.command.luau` in GitHub's **Raw** view, copy the entire file, and paste it into Studio's **Command Bar in Edit mode**.
3. Wait for `[Two Time FCT Port] Applied 27 modules`, save, and start a new playtest. Select the default Two Time.
4. Do not paste the installer into a Script's Source property: the installer contains several modules. Each installed module is below Studio's 200,000-byte Source limit; the largest is 160,512 bytes.

The installer updates both ReplicatedStorage and ServerStorage Two Time snapshots. It also installs the Weakness/Vulnerable migration and damage-path support described below. It checks exact source fingerprints before changing anything, backs up affected modules in ServerStorage, is safe to run twice, and rolls back writes if an assignment fails. If a module was edited separately, it stops with its path instead of overwriting the edits.

`Restore-TwoTime-FCT.command.luau` restores the latest backup, including the shared status/damage changes. It refuses to erase edits made after installation. Apply older Guest/Azure installers before this port, not afterward; their source guards will correctly notice this port's newer shared modules.

## Kit

- **Dagger:** 30s cooldown, 0.3s windup, 10 front damage / 20 back damage, Resistance I for 0.7s. Standing backstabs stun for 2s. Crouched backstabs scale from 2 to 3.5s over the first second crouched, sampled at stab activation. Backstab detection uses actual root transforms, not extrapolated actor pivots. Standing lunge is restored (force 50); crouched force is 110. No lifesteal.
- **Oblation:** 20% per front stab, 40% per backstab, multiplied by 1.25 for crouchstabs. Capped at a full meter; summons and stun-immune/already-stunned targets grant none. The meter can decrease after reaching full.
- **Crouch:** 30s cooldown setting, reduced by elapsed crouch time down to 15s; 1s initial toggle delay; 15s maximum duration. Walk 10, run 23, Invisibility III and Undetectable I, footsteps muted. Running toward a killer within 105 studs builds up to 50% extra speed over 4s. Damage, stopping the approach, and leaving crouch reset the bonus. Nearby survivor teammates can see a fading highlight within 100 studs. A rebuilt beam previews lunge travel. Manual uncrouch within 30 studs of a killer gives Speed II for 1s.
- **Missed crouchstab:** Slowness II scales with killer distance, up to 8s. Crouch endlag 0.225s and recovery tween 0.15s; sprint lock 1s.
- **Pray:** hold AltAbility3 or hold the hotbar button within 10 studs of your Ritual. Converts 1.5% Oblation into 1 HP, up to 66.67 HP per full bar, with a 10s full-conversion setting. Movement/jumping are locked while praying. Release, focus loss, leaving range, full health, depleted meter, interruption, or a lost client hold lease stop it. Damage totaling 5 during the channel interrupts it and gives a 6s cooldown. Attempting it outside range reveals the Ritual for 4s. It has no normal cooldown.
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

- Hitbox size remains FCT's 4 × 6 × 5.5; the latest documented +1.5-stud forward shift produces a 7-stud offset. Exact live-game geometry cannot be verified from these exports.
- Miss duration uses 1s per 10 studs, capped at 8s, inferred from UPD's settings.
- Prayer damage interruption uses cumulative damage during a channel. The exported setting supplies the threshold but not the complete implementation.
- The trajectory beam is rebuilt; the original newer Beam/endpoint instances are not imported.
- Multiple-Two-Time Oblation requirement scaling is not inferred from the unused config field.
- Skin-specific custom behavior and future private animations/audio are outside this default-kit port.

## Validation

All 27 installed modules plus the installer/restore compile with Luau. Mocked regressions execute actual port callbacks and cover:

- Windup, front/back detection, charged stuns, meter gains, immunity/summon exclusions, missed attacks, and interruption cleanup.
- Heartbeat-driven speed buildup/reset, held Pray leases, healing ratios, partial spending, full-health stops, stale-client release, one-use lethal revival and explicit proportional LMS math.
- Client meter updates after full, late input release, focus loss, mouse release outside the hotbar, sprint-lock recovery and cleanup.
- Weakness/Vulnerable application/removal and actual Util/Hitboxes arithmetic, including their combined effects and legacy migration.
- Installer atomic preflight, simulated write-failure rollback, repeat application and restoration.

Run `luau regression.luau`, `luau client-regression.luau`, and `luau damage-regression.luau` with the Luau CLI. The installer regression harness was also run locally. These are mocked tests, not a claim of a Roblox Studio playtest.

Studio checks: place Ritual; land standing and charged crouchstabs on the Slasher bot; spend a full meter through Pray; release the key and click outside the button; take damage while praying; test a missed crouchstab; refill Oblation and take lethal damage. Verify the second lethal hit kills, no automatic solo LMS activation occurs, and Guest/Azure still function. Also verify camera/footstep behavior and physical lunge/teleport clearance in your map.
