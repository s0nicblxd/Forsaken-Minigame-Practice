# John Doe — UPD rig, phase 1

This is the first geometry stage, not the complete John Doe kit update. It targets fct4 after the existing Guest/Helperbot/Azure fixes without rewriting those systems.

## Install

1. Stop Play and save a copy of the place.
2. Download and drag `JohnDoeUPD.rbxm` into Workspace. Keep its root folder named `JohnDoeUPD`.
3. Run the entire `Apply-JohnDoe-Rig.command.luau` in the Studio Command Bar in Edit mode. Save and start a fresh playtest.
4. Select default John Doe and compare him beside a survivor. The imported Workspace folder can be removed after installation.

`SCALE=1.25` at the top of the installer is an **initial visual calibration**, not a recovered official starting multiplier. UPD contains the newer MainRig and collision template, but the saved model is scale 1.0 and its exported client script does not establish the official runtime starting scale. Change SCALE and rerun the same installer with the imported model present to recalibrate without repeatedly multiplying the previous scale.

## Changes

- Uses the actual UPD MainRig meshes, textures, welds, and Motor6D joints. Sets PrimaryPart to HumanoidRootPart. Both replicated and stored default rig copies are replaced; backups retain their previous models.
- Model:ScaleTo handles body, mesh, joint and attachment proportions together. HipHeight stays 0 for this R6 rig: its scaled legs and root already provide scaled ground clearance. No added arbitrary HipHeight lift.
- Adds the UPD collision profile and a scaled FCT query profile for the default model. Existing skins keep their old models and existing collider selection; this stage does not resize all skins.
- Keeps Slash at 4.5 × 6 × 7.5 studs and the original forward offset. Vertical alignment compensates for the taller root, keeping the grounded attack center at the same height rather than extending attack reach with the model.
- Positions the corruption trail from a collision-respecting ground raycast; a size-aware R6 fallback replaces the old fixed offsets. Old skin trail placement is retained.
- Adds UPD's +0.25 camera offset for the local default John and removes it when the actor is destroyed.
- Preserves the existing animation IDs, health, damage, cooldowns, spike/trap balance, and special-day settings. Updated media, Retract, spike balance, Footprint changes and expanded Unstoppable are later stages.

## Test and restore

Check standing/walking on flat ground, ramps and stairs; camera height; collision against doors/walls; trail placement; Slash against a nearby survivor; one existing skin; and death/respawn. Local tests cannot verify Roblox rendering, media permissions or exact screenshot scale. New mesh/texture references still depend on Roblox asset availability.

The installer checks fct4 sources and Studio Source limits, prepares templates before writing, supports repeated application/recalibration and keeps `ServerStorage.JohnDoeRig_Backup_…`. Run `Restore-JohnDoe-Rig.command.luau` in Edit mode to undo the latest installation. No purchases, XP or player data are changed.

Local verification: all delivered Luau compiles; alignment tests cover scales 1.0/1.25/1.6, Slash height/reach, ground-ray fallback and skin preservation. Installer tests cover paired asset stores, absolute recalibration, idempotence, repeated restores, injected write failure and edited-source refusal. The exported model has valid references, all 10 Motor6D joints and 24 cosmetic welds linked, and no executable Script/LocalScript objects. Tests are standalone Luau CLI files in `tests/`.
