# Chance and Shedletsky update

Targets the eight base-character Config/Behavior Sources in ReplicatedStorage and ServerStorage from FCTbuildrermanbuggy.rbxl. Updates gameplay within the existing compatible server/client behavior rather than replacing it with the incomplete donor behavior. Preserves models, skins, sounds, animations, and existing Vulnerable compatibility.

Stop Play mode, save a copy of the place, run Apply-Chance-Shedletsky.command.luau in Studio's Command Bar, save, and start a fresh Play session. The installer patches only the relevant numerical fields and old description text in Configs, preserving custom expression IDs and unrelated edits. It checks Behavior Sources before editing and backs up the actual edited originals under ServerStorage. Restore-Chance-Shedletsky.command.luau restores the latest backup.

## Final values

- Shedletsky Slash: 0.55 second windup and Resistance II; fixed 1.4 second 75% self-slow.
- Fried Chicken: 5 instant plus 25 over 10 seconds. A single health drop of at least 5 cancels the remaining overtime healing. Smaller hits do not cancel it. The final tick is clamped to the remaining duration, and its health listener is disconnected on completion, interruption, or rig removal. Existing achievement-specific damage detection is preserved.
- Chance reroll: base range 70–110; no subtractive penalty; independent 120 maximum after charge bonus. Existing 70–90 spawn health, proportional current-health preservation, charge bonuses, and charge consumption remain intact.
- Ability descriptions reflect the changed numbers.

## Donor comparison

The current source predates these balance values. UPD confirms Chance HealthMin=70, HealthMax=110, HealthClamp=120 and RerollBasePenalty=0, plus Shedletsky SlashWindupTime=0.55 and overtime chicken healing=25. Other shared numerical balance fields match. The donor contains newer asset IDs, LMS metadata, and newer module paths; its Chance reroll callback is empty and Shedletsky's server logic is absent, so those cannot be used as complete replacements. The donor client computes self-slow as windup+0.875 (1.425 seconds at latest windup), whereas the supplied update log explicitly says 1.4 seconds; this repair follows the user's requested fixed 1.4 seconds.

## Validation

Luau compilation of production modules and installers. Gameplay regression checks cover every base Chance roll for one through three charges, the independent 120 cap, full chicken overtime healing with an uneven final tick, damage thresholds, rig removal, and listener cleanup. Installer checks cover all eight targets, repeat runs, mismatched-source rejection, and rollback after a simulated Source write failure. Actual Studio play and visual verification remain necessary.

Config-preservation regression checks additionally cover custom uploaded image IDs in both copies, repeat runs, backups of edited Sources, and rollback preserving those IDs.
