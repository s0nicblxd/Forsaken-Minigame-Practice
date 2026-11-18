# Shop menu groundwork for 1.2.0

Implemented in `index.html` on `test/menu-sidebar-concept`. No Featured tab.

## UPD reference

Reference place: `Forsaken_18687417158_1293889121374179328_2b1fdb82.rbxl`.
Reference module: `ReplicatedStorage/Systems/Player/UI/Menus/Shop`.

Roblox Luau and Instances cannot run in a web page. The following source behavior and template properties were translated to DOM, CSS, and the existing `animateUI` helper:

- `transitionHighlightToState`: white textured highlight / black text, 0.5-second Quart-out transition.
- `transitionToFrame`: directional incoming/outgoing slides, 0.5-second Quint-out transition. Interrupted transitions are cancelled and outgoing pages removed.
- `OpenOverlay`: item details enter with a 0.25-second Quad-out transition.
- Shop `Holder`: 60% desktop viewport width; page starts below the header and category buttons. Responsive adaptations keep controls above the mobile dock.
- `Tabs/Skins` and `Tabs/Emotes`: search, unowned toggle, reusable item card layouts and labels, empty-results state.
- Close icon, panel outline, secondary outlines and texture reuse the update-log assets previously supplied.

Browser accessibility adds labelled tabs, roving keyboard focus, arrow/Home/End navigation, reduced-motion support, and Escape handling for previews.

## FMP organization

- Practice: Puzzles / Challenges
- Cosmetics: Minigames / Profile
- Audio: Music / Sounds

Category selection and each category's sub-selection are retained during the current visit. The search and unowned filter work across the selected group.

## Catalogue boundary

`shopCatalog` is deliberately empty: products, prices, earnings, and purchases have not been agreed yet. The menu shows real empty states. The card renderer and preview support `id`, `name`, `category`, `group`, `description`, `image`, `price`, `owned`, and `isNew` for the next stage. Purchase buttons are explicitly unavailable until the economy is implemented. There are no test products, fake balances, new paid restrictions on existing practice, or saved purchase records.

## Assets

`assets/shop/manifest.json` maps the nine extensionless uploaded images to the shop UI IDs by appearance and their UPD roles. These supplied image files are converted losslessly to PNG. Currency, loading, clock, sale, and badge textures are retained for the later catalogue stage. Main UI assets continue using the existing shared files.

## Validation

Run `node tests/shop-menu.cjs` with Playwright and Chromium installed. The test serves local assets through Playwright route interception and does not need a live web server. Test-only catalogue fixtures are injected into the test response, never the shipped HTML. Covers tab transitions, category groups, search, ownership filtering, item previews, unavailable purchases, keyboard navigation, rapid switching, settings handoff, close controls, portrait/landscape bounds, JavaScript errors, and missing assets.
