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
