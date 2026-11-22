# Martial Artist — FCF compatibility port

Use either the ready **MartialArtist-FCF.rbxm** model (replaces the uploaded model) or the source installer. The model retains the original rig, accessories, Config attachments, animation instances, name, and other properties. Only Config and Behavior Sources change. Do not run both old and new character copies under the same name.

For the existing character: stop Play, select its root (#MArtist or #MArtist2) in Explorer, run **Apply-MartialArtist-FCF.command.luau** in Command Bar, save, then start a fresh playtest. It patches the selected character and same-name survivor counterparts in ReplicatedStorage/ServerStorage. Differently named copies are not silently replaced. The installer does not grant access, alter Exclusive, replace shared modules, or change existing equip data. If importing the ready model, retain the name your equip/command system expects and place it in the same Survivors locations as the existing character.

## Gameplay

- FCF's flat Sounds/Util/Hitboxes/Statuses/Actors module paths. No Rendering/Utilities/Gameplay/Data/new Network folders required.
- New upload's 900 HP, 12 walk speed, 5s Combo cooldown, 5s Quick Attack cooldown, 15s extra-combo cooldown, icons and ability keys retained.
- Combo uses the earlier supplied server timings: 10 / 15 / 10 damage at .383 / 1.083 / 1.717 seconds, 8×4×8 hitbox, -2.25 offset. Single-target grab, release and finisher impulse. Reward once per cast against a Killer; supplied two-second on-hit invincibility retained.
- Quick Attack uses the supplied .667s windup, 25 damage, 4×6×20 hitbox with -15.25 offset, 120 lunge, 20 knockback, Resistance I 2s. The new Config omits SlashStunTime and Sounds.Slash: this port explicitly defaults stun to **2 seconds** and reuses GashingWoundHit1 for Slash. These fallbacks are tunable, not verified original values.
- **SuperDeathKillCombo is reconstructed, with user approval.** The export has no server implementation. It reuses the supplied Combo damage/timings with the newer ComboStart/Comboing animation IDs and KEN/Explosion attachment bursts. This is a functional reconstruction, not an exact recovered move; unknown original extra damage, timings, statuses and bespoke VFX are not claimed.
- Config animation instances drive optional scarf/waist/headband loops. Missing/inaccessible attack animations do not stop damage or cleanup; animation failures warn. Assets still require experience permission where applicable.
- Server owns combat/animations. Named locks preserve other ability locks. Cleanup cancels attack hitboxes, releases owned locks, restores anchoring, removes lunge/effects, stops tracks, and handles death, stun, destruction or targets disappearing. FCF Ignore + guarded damage restrict follow-up hitboxes to the grabbed target, without modifying shared Hitboxes.

## Backups and checks

Installer makes MArtistFCF_Backup folders in ServerStorage. To restore select that backup folder, run Restore-MartialArtist-FCF.command.luau, save and restart Play. Keep the backup. Source writes are preflighted and roll back on failure. Ready model was rebuilt from original chunks with only two Source values replaced.

Studio testing is required for replication, ragdoll physics, asset permissions and the specific FCF build used by your friend. No complete original third-move server implementation was supplied.

## Validation performed

All delivered source/installer scripts compile. Standalone Luau tests cover Config execution, server-only dispatch, all combo stages and single-target follow-ups, rewards once per cast, Quick Attack hitbox lifetime, unavailable animations, misses, interruption/death/removal cleanup, paired-store install, repeat application, restore, preflight refusal and injected Source failure rollback. Binary verification checks that all original model chunks/properties remain identical except the two replaced Source string values. No Studio or multiplayer session was available for runtime verification.
