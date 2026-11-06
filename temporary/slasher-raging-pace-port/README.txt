FCF Slasher: FCTtest Raging Pace port

In Studio, stop Play and save a backup.
Under ReplicatedStorage > Assets > Killers > Slasher:
1. Open the active Behavior ModuleScript and replace its SOURCE TEXT with Behavior.lua.
2. Open Config and replace its SOURCE TEXT with Config.lua.
Keep both ModuleScript instances and all their children. Do not replace the Slasher folder, rig, OldBehavior, or NewBehavior.

Based on the uploaded FCF place and FCTtest. Other edits made to Slasher since those uploads are not included.

Ported: FOV zoom, red screen effects respecting EpilepsyMode, speed transition, non-looping start sound, stamina cap until rage ends, normal duration 14 seconds, FCT rage-start/locomotion animation IDs and start sound ID.
Preserved FCF other abilities, executions, intros, config values outside these six edits, and Gouged aura reveal.
Corrected aura cleanup to use Meta.TargetedPlayer.

No shared module replacements are required by this patch.
Static checks only; not executed in Roblox Studio.
Test activation, rage timeout, attack ending rage, movement/sprinting/stamina restoration, death during rage, No Cooldowns reuse, EpilepsyMode, and sound/animation permissions. Test the default skin first; skin overrides may change the result.
