# Forsaken Combat sunset lighting port

Stop Play, run **Apply-Combat-Lighting.command.luau** in Studio Command Bar, save, and start a fresh playtest. Targets the Lighting schematic from the supplied FCTnewmap build; prior character, endless timer and role-pad repairs do not alter that module.

The original Combat export contains a sunset Sky and saved Lighting state. Its exported Schematics/Lighting functions are empty. This port keeps the current functional controller and its custom/default/cutscene networking API, replacing only its default Properties table and baseline appearance. It does not import the empty controller.

## Appearance

Copies the original saved scene's Lighting properties, including Ambient ~170/170/170, OutdoorAmbient ~186/153/93, Brightness 0, ClockTime 12, Exposure 0, shadow softness 0 and fog end 100000. Copies the sunset sky's six face IDs, orientation, celestial-body visibility and sun/moon settings into both live Lighting and the default template. The original Lighting/Properties module contains different unused values (4.4 time, brightness 2); the exported no-op controller does not apply that module. This port deliberately uses the saved scene state, not that conflicting module.

Archives old skies/atmospheres outside Lighting and the default preset so haze and the old sky cannot blend with the Combat sky. Removes the baseline ColorCorrection tint/desaturation by neutralizing only the object named ColorCorrection; disables baseline depth of field and the default Blur. Keeps those neutral effect objects for compatibility and leaves separately named health/emote/runtime effects untouched during installation. Runtime child clearing/restoration remains the existing controller behavior. Existing custom lighting may temporarily replace the sky; default reset restores Combat's preset. No new day/night cycle is invented.

Technology/LightingStyle already match between both saved files; no renderer technology switch is attempted. The current renderer quality preference is retained. Sky asset visibility is subject to Roblox asset availability; no texture reuploads are necessary unless a referenced public sky face fails in Studio.

## Backups and restore

Old skies and atmospheres, original controller Source, and all changed properties are kept in CombatLighting_Backup folders in ServerStorage. To undo: stop Play, select that folder, run **Restore-Combat-Lighting.command.luau**, save and restart Play. Restore refuses later controller/property edits; applying the same patch again is a no-op. Source writes and property changes roll back if installation fails. Your map geometry, spawn pads, character scripts, Lighting mode APIs and stats are outside the mutation plan.

Local checks cannot verify actual Roblox rendering, exposure on the user's graphics settings, or remote texture availability. Compare in a fresh Studio playtest after applying; the current client lighting cache is reset only by starting a new playtest.

## Local validation

All delivered scripts compile. Tests execute the complete patched schematic through client startup, custom table/folder overrides, default reset, SetAsCurrentLighting, cutscene protection and server custom/default network paths. Installer tests check the captured profile/sky settings, old haze archival, neutral baseline effects, unchanged named live effects during installation, repeat apply, exact restore, write-failure rollback and local-source edit refusal. Sky imagery and hardware-dependent rendering require Studio verification.
