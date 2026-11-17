# Reworked Guest — FCTtest2 fix

For the uploaded **FCTtest2.rbxl**, compared against **FCFlastonewithstupidedits.rbxl**. This is a Studio source patch, not a modified place file.

## Apply

1. Open FCTtest2 in Roblox Studio and stop any playtest.
2. Open `Apply-Guest-FCT.command.luau` on this test branch. Use **Raw**, then copy all its text.
3. Paste it into Studio's **Command Bar** and run it.
4. Check Output for `[Guest Combat Fix] Applied 12 scripts`. Save the place, then start a fresh playtest.

The installer checks every target before changing any source, saves backups in `ServerStorage/GuestCombatFix_Backup_<timestamp>`, and can be run again safely. If a script has changed since the uploaded build, it stops without modifying anything and names that script. Send the current script in that case rather than bypassing the check.

To undo, stop the playtest and run `Restore-Guest-FCT.command.luau`. This restores source from the newest backup created by this patch.

## Changes

- Arms the server's parry window immediately after a successful block, before secondary effects or attacker movement changes.
- Moves attacker slowness out of the synchronous block-response path and resolves player/model/proxy attackers safely.
- Restores the normal query-hitbox size when Guest is destroyed.
- Uses the current local actor directly when refreshing the Punch/Parry UI.
- Recognizes registered NPC actors in shared hitboxes and utility lookups.
- Supports NPC model status targets, avoids sending client events to NPCs, and handles repeated or synchronous status removal without indexing a removed status table.
- Tags the existing melee M1 hitboxes in c00lkidd, John Doe, Jason, Noli, Sixer, Azure, Nosferatu, and 1x1x1x1. Includes both Sixer M1 hitboxes and both Azure main-attack hitboxes. Slasher already has its M1 metadata.
- Leaves special-attack and projectile block breaks in place. Merely having a hitbox does not make an attack blockable.

Guest's Config, balance values, VIP/access rules, and FCT's working `Sprinting:Resync()` method are unchanged. This does not add the free-for-all spawning/round system; that comes after character fixes.

## Check in Studio

### Spawn an attacker with one player

After applying the patch, start **Play** with one player. Switch Studio to the **Server** view, open `Spawn-Slasher-Test-Bot.command.luau` on this branch, choose **Raw**, copy the whole script, and run it in the server Command Bar.

It clones the build's base Slasher rig, spawns nine studs in front of your character, follows you, and independently rolls **50% Slash / 50% Behead** each time it attacks. It uses the existing shared hitboxes, Slasher's configured attack windups/linger/damage, and the correct M1/special metadata. The bot has 1,000 HP, respects stun and Helpless, and pauses 2.5 seconds between attacks. Resetting your character makes it follow your new character.

This is a training attacker, not the complete Slasher actor: damage is capped to leave at least one HP, Slash does not apply Bleeding, and it does not award rewards or execute players. Behead applies the current FCT build's eight-second Helpless effect on an unblocked hit. Animations still require permission to play their asset IDs. It uses simple MoveTo chasing rather than obstacle pathfinding; test on a clear, flat area.

Rerunning the spawner replaces the old bot. Stop the playtest to remove it, or delete `ServerScriptService.GuestSlasherTestBot` in the server view. No second client is required.

### Block tests

- Block a normal killer M1: no hit damage, block rewards apply, and Punch changes to Parry immediately.
- Repeat with both Sixer main attacks and a bot killer that uses the same ability/hitbox code.
- Use a special attack or projectile against Block: the guard breaks and does not grant Parry.
- Punch/Parry a bot: status effects should apply without a nil-player error.
- Let a block expire: its extra two-second ability lock ends without clearing another ability's lock.
- Reset during a block, then respawn: the query-hitbox size and Punch/Parry UI should reset.

A custom bot attack that constructs its own hitbox must pass `AbilityType = "MainAbility"` and `IsProjectile = false` for a melee M1. An unregistered decorative dummy has no Guest behavior to invoke.

## Verification completed here

- Compiled all 12 patched scripts and both installers with the Luau compiler.
- Exercised the patched Guest code in a mock runtime: M1 success, special/projectile break, overheal cap, and independent failed-block lockout.
- Exercised the patched status code: NPC targets, repeated removal, removal during application, and nil-target handling.
- Verified all patch inputs against the uploaded FCTtest2 file.
- Exercised the installer: all 12 resulting sources match the intended output; repeat application changes nothing; an edited source rejects the whole patch without partial writes.

Roblox Studio multiplayer, physics, replication, animation playback, and asset permissions still need the playtest above; they cannot be validated by the standalone Luau runtime.
