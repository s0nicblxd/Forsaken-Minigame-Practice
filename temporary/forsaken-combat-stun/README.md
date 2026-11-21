# UPD stun protection for the FCT combat build

Ports the Sentinel-stacking rework and orbiting stun-immunity indicator to the existing FCT + Guest/Azure/Two Time fixes. Five modules and one visual template are installed. No website or production-branch files are changed.

## Current material repair (revision 1.0.5)

Run **Raw** `Repair-Stun-Material-Static.command.luau` in the **Edit-mode Command Bar**, with Play stopped, then save/start a new playtest. This authors a fresh ordinary SurfaceAppearance, with `ColorMapContent` and `EmissiveMaskContent` set to the verified image URIs. It also corrects the MeshPart’s legacy TextureID to the colour image ID. No texture re-upload, model re-import, gameplay change, runtime image object, or dynamic material factory is required.

The attempted CreateSurfaceAppearanceAsync route was unsuitable here: the user’s Studio build requires EditableImage Content for its EmissiveMask input. A live EditableImage-backed material is also the wrong fit for a static place asset intended to save and replicate. The replacement uses the supported Studio/plugin-authoring properties instead. [ColorMapContent supports asset URIs](https://create.roblox.com/docs/reference/engine/classes/SurfaceAppearance#ColorMapContent); both map properties have PluginSecurity setters and are saved by the place format. This operation must run in Edit mode, not inside a gameplay Script.

The earlier property-based repair still used the incorrect colour decal ID; it did not test this fresh material with both verified images. The current repair retains typed image preloading and aborts safely if authoring fails. Backups and `Restore-Stun-Material.command.luau` are available. Version 1.0.5 supersedes the previous material repair attempts.

## Verified image IDs (revision 1.0.4)

The user’s Studio Decal Properties screenshots provide the actual image references:

- Colour image: `83958058671232` (from the uploaded colour decal/container `128651191436151`).
- Uploaded emissive-mask image: `106819888283523` (from `Texture_88194642418565`).

These underlying image IDs are now used in the image probes, material factory and XML template. The asset-type mismatch for the old colour reference is resolved at the input level. No texture re-upload or template re-import is needed for an existing installation: run the updated `Rebuild-Stun-Material.command.luau`. Gameplay modules are unchanged.

## Material correction for an existing installation

If the symbols are grayscale, stop Play and run **Raw** `Rebuild-Stun-Material.command.luau` in the **Edit-mode Command Bar**. Save and start a fresh playtest. This replaces only the visual template, preserving all gameplay modules, orbit logic, sounds, mesh and uploaded colour map. No model re-import is needed.

The first template extraction missed `SurfaceAppearance.EmissiveMaskContent`, stored in the newer binary Content format (property type 0x22). Decoding the actual UPD property identifies **rbxassetid://88194642418565**. Blue EmissiveTint and strength alone do not identify which pixels emit light; the missing mask is now explicitly assigned. The verified uploaded copy of the UPD mask is assigned during Edit-mode material authoring with the original blue tint and strength. Fresh installations and the XML template include it too.

Revision **1.0.2** constructs a fresh SurfaceAppearance through `AssetService:CreateSurfaceAppearanceAsync({ColorMap=..., EmissiveMask=...})`. The first mask repair only assigned map properties and did not resolve the rendered result. Roblox’s [material creation API](https://create.roblox.com/docs/reference/engine/classes/AssetService#CreateSurfaceAppearanceAsync) documents supplying the maps at creation and not swapping them afterward. Both image URIs are preloaded and checked. Loading or creation errors leave the current template untouched. No whole-mesh tint or forced Lighting changes are used.

Revision **1.0.3** preloads temporary `ImageLabel` instances rather than raw URI strings, following Roblox’s [image-bearing instance preload interface](https://create.roblox.com/docs/reference/engine/classes/ContentProvider#PreloadAsync). Raw-string fetch failures do not establish that an image ID or its permissions are wrong. The instance path still stops on reported failures, and both success and exception paths destroy the temporary image probes. The colour/emissive references in revision 1.0.3 were unchanged; revision 1.0.4 uses the verified underlying image IDs listed above. If this instance check still fails in Studio, the error identifies the affected image for asset-ID/permission investigation; no broken replacement is installed.

The repair creates its own `ServerStorage.StunProtectionMaterial_Backup_*` folder. `Restore-Stun-Material.command.luau` restores only the previous material while keeping the stun-protection gameplay installed.

## Install in Studio

1. Stop Play and save your place. Download `StunProtectionVFX.rbxmx` using GitHub's Raw/download button, keeping the `.rbxmx` extension. In Explorer select **ReplicatedStorage > Assets > Instances**, then **Insert from File** and choose the file. The imported MeshPart should be named `StunProtectionVFX` directly inside `Instances`.
2. Open **Raw** `Apply-Stun-Protection-FCT.command.luau`, copy the entire file and paste into Studio's **Command Bar in Edit mode**.
3. Wait for the success message, save, and start a new playtest. Stun the Slasher training bot with Guest or Two Time. You should see three orbiting symbols and hear the uploaded sounds.

The XML supplies the original mesh and archived material references. If no imported template exists, the installer can construct the public mesh automatically. In both cases it authors a fresh static material from the verified colour/emissive image URIs in Studio Edit mode. Mesh or material failures stop before changing gameplay modules.

The installer checks all expected source fingerprints before writing. It preserves the current Azure optional-animation loader and Guest/NPC status compatibility. Re-running it is safe. Modified or older source is rejected instead of overwritten. Backups are kept under `ServerStorage.StunProtectionPort_Backup_*`; `Restore-Stun-Protection-FCT.command.luau` restores the newest backup. The imported asset and shared-module changes are included in the backup. Apply this after the existing combat patches; older installers may correctly reject the newer shared sources afterward.

## Mechanics

- Sentinel stacking no longer reduces stun duration, and the former 0.5s stacking cutoff is removed. Explicit character-specific `Config.StunDuration` overrides are retained.
- Immunity after a stun ends is **6 + 3 × living Sentinel count + ResonanceDuration / 2 seconds**. This follows the supplied UPD code, which counts the first Sentinel too.
- With no Resonance: 0 Sentinels = 6s; 1 = 9s; 2 = 12s; 3 = 15s.
- Count is captured when the stun ends. Dead rigs, spectators and duplicate registrations of the same rig are excluded; living Sentinels on either FFA team count.
- Protection uses the existing stackable attribute helper under the source `StunPort`. Replacing a lease cancels its old timer, and its expiry preserves other immunity sources managed by the same helper.
- Ability locks are released independently of immunity; an immune killer can attack after the stun ends. Dead rigs are not given new immunity leases.
- This patch does not add unrelated UPD damage reduction, damage invincibility, Weakness, Exhausted, terror-radius or global particle changes. Existing damage behavior is preserved.

## Refreshed indicator

The controller follows UPD's three-symbol layout: 4-stud orbit radius, 1.15 studs above the root, one orbit every 4s, and one symbol spin every 10s. Symbols appear at 0s / 0.35s / 0.7s. Each arrival creates a 1.5× expanding echo that fades over 0.75s; removal fades over 0.25s.

It appears while `StunnedDisabled` is set, including during the active stun. Any non-nil `StunnedImmunityHidden` value suppresses it, matching UPD's condition. The old particle indicator is no longer created. Rendering tracks both player rigs and late-spawned training bots in `workspace.Players.Killers` / `Survivors`, cleans up on death/removal, and cancels delayed symbols when protection ends early.

| Asset | Reference |
|---|---|
| Original symbol mesh | `76640378318129` |
| Original packed material | `74597329653279` |
| Verified colour/alpha image | `83958058671232` |
| Verified uploaded emissive-mask image | `106819888283523` |
| Uploaded appearance sound | `107766213132983` |
| Uploaded looping sound | `112344506440657` |
| Uploaded ending sound | `117830806605625` |

Mesh size is 3.20400953 × 3.20400953 × 0.604846478. The SurfaceAppearance uses transparency alpha, blue emission (0, 79, 255), and emissive strength 6.28. Start/loop/end volumes follow UPD: 0.45 / 0.3 / 0.4. Sounds are spatial, with a local 80-stud falloff limit.

Roblox protects `SurfaceAppearance.TexturePack` from normal script assignment. The XML archives the original reference, while the installer and repair author a new static material from URI-backed colour/emissive maps. `OriginalTexturePack` is provenance metadata; `MaterialAuthoredInStudio` identifies the current path. `MaterialCompiledFromMaps` is false because the dynamic material factory is not used. The protected cached pack is not forced onto the newly requested maps.

## Validation

All five installed modules and both command files compile with Luau. Mocked regression suites execute the real patched Statuses/Stunned modules and real stackable helper functions, checking full/short stun durations, correct immunity timing, NPC resolution, living-Sentinel counting, timer replacement, other-source immunity, cancelled overrides, dead-rig cleanup, and animation-less movement locking.

The indicator regression checks staggered creation, orbit radius/height, uploaded audio IDs, hide flags, interrupted spawns, death/removal cleanup, and late-created NPCs without ActorCreated messages. The installer regression checks edited-source rejection, mid-write rollback, repeat application, template import/cloning and restoration, including an existing imported asset. The XML’s mesh, colour-map, emissive-mask and packed-material references are parsed and checked. A separate material regression rejects any invocation of the EditableImage material factory and checks ordinary URI map assignment instead. It verifies both image references, the legacy mesh fallback texture, blue tint, emission strength, unchanged gameplay, safe loading/authoring failure, repeated application and restoration. These checks cannot prove Studio rendering.

Run `luau status-regression.luau`, `luau indicator-regression.luau`, and `luau material-regression.luau`. Installer regression was also run locally. These checks are not a Roblox Studio playtest. Confirm actual asset permissions, material appearance, audio, and bot/player timing in Studio; test Guest, Azure and Two Time afterward.
