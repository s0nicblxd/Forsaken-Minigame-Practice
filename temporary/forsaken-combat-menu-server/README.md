# Combat menu server support

Adds the backends deferred from the refreshed-menu port. Apply this **after** the Combat Menus port, to the same FCT build. No asset model import is needed.

## Install

1. Stop Play in Roblox Studio and save a copy of your place.
2. Open `Apply-Menu-Server.command.luau`, copy its entire contents, and run it in Studio's Command Bar in Edit mode.
3. Save the place, then start a fresh playtest.

The installer checks the seven affected module Sources before changing anything. It creates a `ServerStorage/CombatMenuServer_Backup_*` folder and rolls back if a live write fails. If a source-check assertion fails, send the named current module; the installer deliberately preserves local edits.

## Changes

- Restores the UPD character/skin favorite stars and favorite-first sorting. Permanent owned items can be favorited; temporary grants cannot.
- Saves favorites in the existing PlayerData store. Creates the Favorites template folders and fixes the native loader's conversion of previously unknown nested tables into strings, allowing new per-character skin favorite folders to load properly.
- Adds `FavoriteCharacter`, `FavoriteSkin`, and `RequestPreviewRig` handlers. Requests validate catalog references and ownership where required, with per-player rate limits.
- Adds server-backed skin previews for models in ServerStorage. Preview clones contain no scripts, sounds, or interaction prompts; they are delivered through the requesting player's PlayerGui, replaced on the next request, and expire after 30 seconds. Missing rigs fall back to the base actor preview. Existing custom GetRig hooks, expressions, clothing, idle animations, and life appearances remain in the preview pipeline.
- Implements the inventory's Randomized character button. Spawning selects among permanent owned characters that still exist in the catalog. The UI resolves a stable representative without rerolling while browsing. Randomized character and skin settings are retained when saving.
- Prevents duplicate favorite click listeners when a card is initialized again.

Excluded menus, paid content, new settings options, combat statistics, and cutscenes remain outside this change. Existing menu settings, purchases/equips, AFK mode, and update-log acknowledgement continue using their native handlers.

## Verify in Studio

- Favorite and unfavorite owned characters and skins; confirm sorting and check them after leaving and rejoining a published test server. Studio data persistence requires Studio API access.
- Preview a skin whose rig is stored in ServerStorage and switch between several skins.
- Equip Randomized for each role, use the spawn pads, and confirm that only permanent owned characters appear. Check that the setting survives rejoining.
- Check ordinary purchases, equipping, sidebar menus, and the existing HUD.

Luau compilation and five standalone runtime suites passed: installer rollback/restore, handler validation and preview cleanup, native persistence round-trip, actual randomized EquipState/Actors selection, and favorite-star toggling/listener cleanup. These use Roblox API mocks; an actual Studio rendering and published-server persistence test is still required.

## Restore

Stop Play, select the appropriate `CombatMenuServer_Backup_*` folder in ServerStorage, and run `Restore-Menu-Server.command.luau`. It restores the previous seven Sources and template, and removes the added backend. It refuses to overwrite Sources edited after installation. Save and restart Play.
