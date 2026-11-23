# Combat menus — UPD presentation port

## Install

1. Stop Play and save the place.
2. Download **CombatMenusPort.rbxm**. In Explorer right-click ServerStorage → Insert from File, and select it. The imported Folder must be named **CombatMenusPort**. If Studio inserts it into Workspace, move it into ServerStorage.
3. Run **Apply-Combat-Menus.command.luau** in Studio Command Bar.
4. Save and start a fresh playtest. Keep the ServerStorage backup and imported bundle until tested.

The bundle is the UPD's actual UI frames, textures, fonts and templates, with adapted client Source. No asset uploads or remote asset loaders are used. The model stays in ServerStorage; copies replace the menu templates. Source preflight targets FCTnewmap's menus and Spectating, which are unchanged by the prior lighting/character/prompt/no-cutscene patches.

## Included

- UPD SidebarHandler and button/currency classes: Shop, Inventory, Achievements, Spectate, Stats at the side; Settings, Rules, Update Log, AFK at the bottom. UPD spacing, sizing, textures and hover/selection states are preserved. Spectating's two legacy sidebar paths are adapted; its existing functionality/data remain.
- UPD Shop presentation and Skins/Emotes catalog/preview/search flow, wired to existing PurchaseContent. Skins is the opening tab. Robux and the paid Featured offers are omitted; currency-plus links cannot open a paid store. Shop tab widths are adjusted for the two remaining tabs. Prices remain native config prices through a client-only no-sale adapter; server pricing is unchanged.
- UPD Inventory presentation, cards, search, sorting, skin selection and level display using existing equip/purchase endpoints. Existing preview builder remains; no RequestPreviewRig backend is introduced. Favorite controls are hidden and no FavoriteSkin/FavoriteCharacter remotes are sent. Favorites storage/saving is deferred, not simulated. Randomizer-specific templates are present but no new game mode/server behavior is added.
- Searchable UPD Settings presentation and templates, with the **current SettingConnections cloned unchanged**. It only renders the existing saved Settings values. No new setting options, defaults, migrations or server handlers are added. UI-scoped Device helpers provide only the newer keybind validation methods; existing device detection/network registration remain.
- UPD Update Log menu: selectable log list, title art, component layouts and DiscordMarkdown support. Existing Assets.Changelogs entries are retained and old Header/Body Notes are rendered through the legacy adapter. No new release text is invented. Existing UpdateLogToLatest endpoint remains. The old Misc/UpdateLog module is archived to avoid duplicate popups.
- UPD Achievements, Stats and Rules presentation uses existing data. Stats redesign remains deferred.
- Forsakenween, ServerList and Boombox menus/buttons are excluded/archived. No new seasonal event content or paid offers are imported. Existing unrelated server systems are not rewritten.

## Scope/compatibility

Only UI templates/controllers, UpdatelogPresets, a private CombatMenuCompat client-helper folder and two Spectating sidebar references change. Character behavior, spawn pads, lighting, endless rounds, player data, purchases/equips on the server and saved stats remain unchanged. The old in-game server module might still implement monetization; this client port does not expose it or recode it. No new server-sided features are claimed.

Exact Source checks reject existing local menu/Spectating edits. The full previous menu trees are archived, preserving custom assets, and moved back on restore. Installer source writes roll back on failure. Applying the same version again is a no-op. The old Settings connections remain in their archived original tree and are cloned into the new tree.

To restore: stop Play, select ServerStorage/CombatMenus_Backup_..., run **Restore-Combat-Menus.command.luau**, save and start a fresh playtest. Restoring discards edits made to the installed replacement UI trees; preserve any later edits before restoring. Script cache/callbacks require a fresh playtest after installation or restore.

Studio verification is required for actual rendering across resolutions, public asset availability, input focus, character-specific preview rigs and live server purchase/equip/setting responses. Local checks do not replace a playtest.

## Local validation

- Binary readback verifies one root, 1,667 imported instances, 29 exact adapted Sources, all included menu/preset trees and no excluded UI subtrees. Serialized UI layouts, fonts, textures and shared-string data are retained by the binary exporter; external instance references are cleared.
- Every adapted donor module, private adapter and Command Bar script compiles with the Luau CLI.
- Integration harness executes the actual SidebarHandler, Button, CurrencyDisplay, Settings + Bool template, UpdateLog and AFK client modules using the imported asset hierarchy. It covers registration before sidebar startup, menu switching/hiding, settings search/toggle/reset on existing values, AFK's existing endpoint, old changelog rendering and page selection, and hidden paid currency links.
- Dependency/contract checks resolve native modules and verify that only existing EquipState, PurchaseContent, UpdateLogToLatest and UpdateSettings endpoints are requested. Favorites and server preview requests are absent. Existing preview builder Source is retained and Spectating changes exactly two sidebar references. Device helpers and base-price passthrough are exercised.
- Installer harness uses the actual imported tree to verify current Settings connections are cloned unchanged, excluded UI is archived, private helpers are isolated from framework initialization, original trees restore by identity, repeat install is a no-op, and write failures/local edits are handled.

Full Shop/Inventory startup with every real character, viewport/media loading, resolution/console/mobile rendering and live server responses are not simulated by these local tests. These require a fresh Studio playtest. Do not treat the harness as a pixel-rendering or multiplayer test.
