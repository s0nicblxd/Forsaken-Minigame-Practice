# Stats and sidebar test build

Open `index.html` using the same assets folder as the existing game. This is the playable update; `menu-concept.html` is the earlier design prototype.

- Sidebar: Shop, Inventory, Achievements, Stats. First three are Coming soon.
- Utilities: Settings (Coming soon), Update Logs with the working music control, Credits using the Rules icon.
- Mobile: sidebar row sits immediately above the bottom utilities. Desktop: vertical left sidebar.
- Stats: all nine minigames, successful rounds, practice duration, best/average successful times, total website time, and game-specific accuracy/failure/perfect-round counters.
- Flow and Legacy timings are separated by dimensions. Bloodhook difficulties share records.
- A complete graffiti board, complete three-gear set, or five-popup Entanglement batch is one completion.
- Fake generator skips and accidental completions have separate counters.
- Leaving/restarting does not count as failure. Hidden-tab time is excluded.
- Progress is local to this browser (`fmp.stats.v1`), not account synced. Existing completion count is preserved as historical progress; old records/times cannot be reconstructed. No sample data is used.

## Verification performed

Chromium checks at 390, 640, and 1440 pixel widths: sidebar/Stats dialogs, close controls, Update Logs music control, no horizontal overflow, no page errors. Exercised completion handlers for all nine minigames, persistence after reload, grid separation, duplicate-finish protection, abandonment, failure counters, full-board graffiti counting, and hidden-time exclusion. Timing and outcomes were controlled by test-only instrumentation; the instrumentation is not in the delivered HTML.

Recommended hands-on checks: play each minigame, inspect timings and sound, rotate a phone, scroll to Practice beneath the dock, reopen Stats after refresh, and confirm music changes from Update Logs.

## UPD-based visual correction

Inspected the binary UI properties as well as SidebarHandler and Classes/Button source. Sidebar icons occupy 87% of the face, with transparency stops at 0%, 19.46%, 64.69%, 83.89%, and 100%. Labels are positioned at roughly 103% Y on independent grunge. Background, outline, texture, shadow, grunge and icon are separate layers. Active buttons invert to the source's light background/dark icon treatment. Hover and menu transitions use the source's 0.25-second timing.

Stats now uses a 1.2-aspect panel at 65vw (height constrained), 36px-equivalent section strips and 32px-equivalent text rows. Grid records are separate text subsections, not accordions/dropdowns. Mobile sizing and a subtle panel backing are web readability adaptations; the X remains an added accessible close control since the recovered Stats template does not include one.

Rechecked 390px, 640px and 1920px layouts, image loading, panel transitions and all nine gameplay completion handlers.
