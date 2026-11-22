# Helperbot → FCT port (1.0.0)

Uses FCF's pre-release rig and the current UPD's actual effect/charge UI templates. Server gameplay is reconstructed against the user-supplied corrected moveset; this is not recovered official server code.

## Install

1. Save a copy of your place and **stop Play**.
2. Download `HelperbotDonor.rbxm` and `HelperbotUPD.rbxm`. In Explorer, right-click **Workspace → Insert from File** (or drag both files into Studio). Keep the imported folders named `HelperbotDonor` and `HelperbotUPD` directly under Workspace.
3. Open `Apply-Helperbot-FCT.command.luau`, use **Raw**, copy the entire text, and run it in Studio's Command Bar in Edit mode.
4. Save and start a **fresh** playtest. The normal character selector should discover Helperbot; the installer does not alter purchases or unlock data. Use `Test-As-Helperbot.command.luau` in the **Server** Command Bar during Play to test without purchasing.
5. The imported Workspace folders can be deleted after installation. An existing Helperbot folder is retained in `ServerStorage.HelperbotPort_Backup_…`. Use the Restore command in Edit mode to undo this port.

Requires the existing FCT combat compatibility setup (Guest/Azure/Two Time/stun fixes). Adds only Helperbot and two new statuses; does not rewrite those characters, shared Hitboxes, Statuses, Actors, or ActorHandler. Refuses to overwrite an existing Haste/Fatigue implementation.

## Gameplay

- Health 80; walk 12; sprint 26; stamina 100, drain 10/s, regeneration 20/s.
- Radar: every 12s, reveal unfinished generators/items within 100 studs for 3s to survivors. Helperbot sees health-colored auras for other survivors' non-primary ability counter changes. FCT does not emit the declared AbilityUsed signal; observing the server-owned AbilitiesUsed attribute avoids polling cooldowns or confusing Haste with ability use.
- Pulse: 44s cooldown, 2s windup, 10% slowdown; actual health loss interrupts without consuming charges. Release consumes all charges and sends a one-second expanding wave at 30/33/36/39 studs. Regeneration I and Resistance I last 4/5/6/7s before stacking.
- Every additional living Helperbot subtracts 1.5s, with a 3s floor **before** halving for receiving Helperbots other than the caster. Veeronica receives Resistance but no Regeneration.
- Inspiration: 46s cooldown, 0.75s stationary windup, moving 16-stud aura for a fixed 10s. Haste V, minus one level per additional living Helperbot, minimum I. Refresh lasts 2s; self included; Inspiration excluded. Supports receive half cooldown acceleration.
- Starts at one Pulse charge, cap three. Each other survivor contributes once after 5s in an aura; unfinished seconds decay at 0.7/s outside. Actual level increases award $2, 13 EXP, 0.25 Malice through the normal actor reward API (subject to its normal data/VIP restrictions).
- Generic Fatigue slows cooldown recovery by 10% per level. **Pulse does not apply it:** the UPD export specifies Duration=0 and the authoritative supplied moveset specifies no lasting killer debuff. No FCF Burning.
- Survivor support still targets the existing Survivors folder. No new FFA alliances or friendly-fire rules are introduced.

## Antenna and Pulse indicator repair

If Helperbot is already installed, stop Play and run `Repair-Helperbot-Presentation.command.luau`, save, then restart Play. No model reimport is required. The repair adds the Presentation module and updates only Helperbot's Client, leaving server gameplay unchanged. It attaches caster effects to Hat (or Head fallback), preserving UPD's authored 1.25-stud antenna offset. A custom skin can provide a `HelperbotVFXOrigin` Attachment. The level indicator binds to `PlayerGui.MainUI.AbilityContainer.Pulse`, without relying on an UPD-only UIElement field, and rebinds after hotbar recreation. Backups are saved in ServerStorage; unknown Client edits stop preflight. Fresh installs include these fixes.

## Verification

Standalone Luau regression scripts are in `tests/` (run with the Luau CLI, not the Studio Command Bar). They cover server mechanics, cooldown effects, client lifecycle without animations, installer idempotence, preservation, rollback, and restoration. Both exported model graphs were also checked for dense valid references and intact Motor6D connections. All shipped Luau files compile; no individual module approaches Studio's 200,000-byte Source limit.

## Media and testing limits

Actual UPD mesh, particle properties/attributes, charge BillboardGui, controller, highlights, icons, and animation/audio references are retained. Missing animation tracks are guarded; sound failures do not control server cast completion. Roblox still enforces asset permissions, so inaccessible media may need uploads. Studio visual/multiplayer validation must happen in the user's place; local Luau regression tests cannot validate Roblox rendering or ownership permissions.

Test with two Studio clients: interrupted Pulse retains charges; repeated aura entries preserve partial progress; each survivor contributes once per cast; charge cap does not pay extra rewards; additional Helperbots reduce both effects correctly; death cleans zones, sounds, locks and meters. Inspect health, cooldown recovery, and wave range. Existing regeneration/resistance behavior remains FCT's shared implementation.
