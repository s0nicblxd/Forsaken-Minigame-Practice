# Menu loading and Kills display repair

Based on the menu, PlayerList, and LeaderStats Sources in FCTbuildrermanbuggy.rbxl.

Stop Play mode, save a copy, paste Repair-Menus.command.luau into Studio's Command Bar, and run. Save and start a fresh Play session.

- The Shop's first page is explicitly made visible, so Skins appears without switching to Emotes first.
- Update Log uses its configured latest entry when valid, otherwise the newest successfully loaded entry by the menu's date ordering. It renders the entry automatically and records the selected title after rendering succeeds.
- The player list displays Kills instead of Malice. The server mirrors Stats.General.TotalKills into leaderstats.Kills, including live updates. Saved Malice data remains intact.
- The player-list money formatter checks the stat object's name rather than indexing the formatted value.

Original Sources are saved in a MenuLoadingBackup folder under ServerStorage. The installer rejects unexpected Sources before making changes, supports repeated runs, and restores Sources if a write fails.

Validation: all production scripts compile; regression checks for initial Shop visibility, configured/missing latest log selection, live saved Kills and Money updates, listener cleanup, installer idempotence, source rejection, and rollback. Studio visual testing remains necessary.
