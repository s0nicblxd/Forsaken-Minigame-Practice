# Shop menu groundwork for 1.2.0

Implemented in `index.html` on `test/menu-sidebar-concept`. No Featured tab.

## UPD reference

Reference place: `Forsaken_18687417158_1293889121374179328_2b1fdb82.rbxl`.
Reference module: `ReplicatedStorage/Systems/Player/UI/Menus/Shop`.

Roblox Luau and Instances cannot run in a web page. The following source behavior and template properties were translated to DOM, CSS, and the existing `animateUI` helper:

- `transitionHighlightToState`: white textured highlight / black text, 0.5-second Quart-out transition.
- `transitionToFrame`: directional incoming/outgoing slides, 0.5-second Quint-out transition. Interrupted transitions are cancelled and outgoing pages removed.
- `OpenOverlay`: item details enter with a 0.25-second Quad-out transition.
- Shop `Holder`: compact, roughly 54% desktop viewport width and 1.3 aspect ratio, matching the supplied shop screenshot. Subcategory toggles sit on the left of the search row. The left selection list filters the four-column item grid. Landscape screens retain this layout; portrait mode is unsupported.
- `Tabs/Skins` and `Tabs/Emotes`: search, unowned toggle, reusable item card layouts and labels, empty-results state.
- Close icon, panel outline, secondary outlines and texture reuse the update-log assets previously supplied.

Browser accessibility adds labelled tabs, roving keyboard focus, arrow/Home/End navigation, reduced-motion support, and Escape handling for previews.

## FMP organization

- Practice: Puzzles / Challenges
- Cosmetics: Minigames / Profile
- Audio: Music / Sounds

Category selection and each category's sub-selection are retained during the current visit. The search and unowned filter work across the selected group and left-hand selection. Selections are remembered per category/group during the current visit.

## Catalogue boundary

`shopCatalog` is deliberately empty: products, prices, earnings, and purchases have not been agreed yet. The menu shows real empty states. The card renderer and preview support `id`, `name`, `category`, `group`, `description`, `image`, `price`, `owned`, and `isNew` for the next stage. Purchase buttons are explicitly unavailable until the economy is implemented. There are no test products, fake balances, new paid restrictions on existing practice, or saved purchase records.

## Assets

All used local images are embedded in `index.html` so downloading that file alone preserves the UI. The source images remain in the repository. Run `python tools/embed-local-assets.py` after adding any new static asset paths. Existing externally hosted audio is unchanged.

`assets/shop/manifest.json` maps the nine extensionless uploaded images to the shop UI IDs by appearance and their UPD roles. These supplied image files are converted losslessly to PNG. Currency, loading, clock, sale, and badge textures are retained for the later catalogue stage. Main UI assets continue using the existing shared files.

## Validation

Run `node tests/shop-menu.cjs` with Playwright and Chromium installed. The test serves local assets through Playwright route interception and does not need a live web server. Test-only catalogue fixtures are injected into the test response, never the shipped HTML. Covers tab transitions, category groups, search, ownership filtering, item previews, unavailable purchases, keyboard navigation, rapid switching, settings handoff, close controls, landscape bounds, the portrait input guard, JavaScript errors, and missing assets. A separate single-HTML origin with no asset directory checks every lobby menu for broken images. Direct file:// navigation is blocked by the managed browser policy, so the isolated origin verifies there are no sidecar image requests.

## Orientation support

Portrait view shows a full-screen rotation prompt. Other page roots become inert and game inputs are blocked; their previous inert states are restored on rotation to landscape. This does not reset saved settings or records. No portrait shop layout is maintained.

## Visual audit against UPD and the supplied comparison

Button layers now include the source's texture opacity (0.23), black grunge (0.44), background shading, and slice geometry. Roblox's outline SliceCenter `(60,50,541,544)` on a 586px image becomes CSS `50 45 42 60`; the main frame uses source SliceCenter `(286,34,552,552)` and its larger left inset. Main tab text uses the source's semibold weight. FMP selection labels shrink to fit one line, matching the purpose of TextScaled.

The Shop close control has no category selection brush. Its icon occupies 55% of the control at 0.81 opacity; the outline/texture use a muted red tint based on the reference. Hover changes the control from 7.1% × 9.2% to 10.5% × 10.5% over 0.25 seconds, as in `Shop.Close` source. It is aligned with the tab row to match the supplied screenshot.

Left selection buttons retain image/grunge backgrounds and a small hover scale rather than the category brush. The unowned filter matches `CreateUnownedButton`: the icon fades to 50% while active, with no brush or inversion.
