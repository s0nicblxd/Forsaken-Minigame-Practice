# n7, Vee, HUD and global/client update

## Install

1. Stop Play mode and save a copy of the place.
2. Insert GameplayHUDUPD.rbxm into Workspace. Keep its root name GameplayHUDUPD. This contains UPD GUI templates, with donor executable Source removed.
3. Paste Apply-N7-Vee-Global.command.luau into Studio's Command Bar and run it.
4. Save, start a fresh Play session, and respawn. The imported pack can be removed after successful installation.

The installer prepares and validates all Source edits before writing. Actual original Sources and HUD templates are backed up in ServerStorage. Helpers and the new setting are tracked for rollback. Restore.command.luau restores the latest backup. Existing custom asset IDs, Chance repairs, combat stats, Malice removal and skipped cutscenes are preserved. Unrecognized edited fragments are rejected before changes.

## 007n7

Cursor-mode clones last 5 seconds; other modes retain the normal 10 seconds. A duration tracker appears above Clone's ability icon and ends when the clone dies, is removed, or expires. A later clone's tracker cannot be cleared by an older clone.

A successful completed c00lgui teleport awards $3 and 30 base XP once. A living killer within 30 studs of the departure position at completion changes the action to Escaped from a Killer with c00lgui; the amount is the same. Failed/cancelled casts and missing destinations do not reach the award hook. Survivor XP doubling makes this 60 XP before additional boosts.

## Veeronica

Shared numeric Config comparison found only bump power changing from 11.9 to 12. This update applies it and adds the two extra regular graffiti images from UPD. It ports the newer SprayVisual implementation with compatible module paths and Config.Instances aliases, preserving existing server mechanics, animations, skins, and the other balance values. The donor's incomplete ability callbacks are not substituted for working code.

## Globals and HUD

- Installs UPD's PlayerInfo, SurvivorFrame, CenterStaminaCounter and Drain templates while retaining the compatible existing HUD controller, combat stats, and privacy controls.
- Adds the dynamic stamina-recovery delay indicator to the stamina bar and center counter, driven by the actual timeUntilStaminaRecovers value.
- Killers receive damage invincibility during a stun and for one second afterward. It is separate from stun immunity. Serial checks prevent an older timer removing a newer stun's protection.
- Existing Vulnerable, 10%-per-level damage-output Weakness, and refreshed stun-immunity visuals remain intact.
- Exhausted remains 5% per level with the existing red stamina bar, per the user's final correction.
- Invisibility fully hides and clears active ParticleEmitters, watches newly added emitters, prevents re-enabling while cloaked, and restores their prior/latest intended state when it ends.
- Survivor character XP gains through the shared award path double. Killer XP and money are unchanged. Existing multipliers and friend boosts still apply.

## Helperbot Pulse hit reward

One award per finished released wave, counting distinct other living survivor actors reached. Other Helperbots count; the caster does not. Zero other targets and interrupted casts give no hit reward.

| Other survivors hit | Money | Base XP | With survivor XP x2, before other boosts |
|---|---:|---:|---:|
| 0 | 0 | 0 | 0 |
| 1 | 2 | 13 | 26 |
| 2 | 4 | 26 | 52 |
| 3 or more | 6 | 39 | 78 |

Existing Inspire/Pulse charge-level rewards are separate and preserved. The reward table does not add Malice.

## Client polish

- c00lkidd mobile Corrupt Nature no longer requests automatic survivor targeting; mobile manual aiming uses the cursor ray.
- Projectile aiming defaults to cursor-based behavior instead of the shiftlock branch. A new Use Shiftlock for Projectile Aiming setting restores the prior branch. Console reticle aiming and explicit auto-aim callers remain supported.
- Mobile objective notifications are smaller.
- Support requests use deliberate taps/clicks; touch drag, camera rotation, and focused GUI activation cannot accidentally trigger them. Request choices support Activated input.
- The emote hotkey stops an active emote. D-pad wheel selection and idle-thumbstick handling improve controller responsiveness.
- Shiftlock cleanup restores mouse behavior and character rotation, and repeated enable calls cannot accumulate rotation loops. The existing original mobile button layout is retained.
- Skin/item preview dragging freezes the world camera until release, focus loss, character removal, or preview destruction.
- D-pad menu selection can initialize native GUI focus; focused entries in scrolling frames are brought into view.
- PC and console keybind settings are filtered correctly instead of showing both copies. Each console binding remains separately editable. Escape or controller Start cancels capture; cross-device bindings do not conflict. No saved keybind values are deleted.

## Deliberate exclusions

Bloodhook fairness, Disarm timing, Azure grab timing and golem positioning were not changed: these require their server-side minigame/ability behavior, excluded by the user's constraint. A standalone compatible speech/quick-chat wheel implementation was not found, so no separate new speech-wheel system is invented; the existing support-request and emote interfaces receive the client improvements above. The generator cursor option is omitted for the combat game's generator-free scope. New center-health-counter/held-item features are not enabled; this ports the compatible HUD layout and requested recovery indicators.

## Validation

All production Luau compiles. Regression checks execute the shared XP function, actual stun callbacks, n7 lifetime/tracker/reward helper, actual Helperbot wave lifecycle, actual support-input and Settings device filters, particle hiding/restoration, and the HUD recovery/clone-timer helper. Installer tests cover all 24 current Source targets, GUI templates, repeat runs, missing import rejection, unsupported Source rejection, and Source/UI/helper/setting rollback after a simulated write failure.

Roblox Studio visual, touch, controller, asset-access and multiplayer testing remain necessary. The UI model is a template extraction, not a modified place file.

ClientPolish lifecycle correction: shared-module startup exits on the server before accessing LocalPlayer, tolerates an absent client player, and reuses a single active client session. A dedicated Repair-ClientPolish.command.luau is available in ../forsaken-battles-client-polish-fix for previously installed copies; no HUD reimport is required.
