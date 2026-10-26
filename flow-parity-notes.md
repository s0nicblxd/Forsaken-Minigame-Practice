# Flow gameplay audit

Compared against the user-supplied FlowGame.lua, PathFinder.lua, Generator.lua and Settings.lua. These are the supplied older game sources, not a claim of parity with every subsequent Roblox release.

Verified existing rules: endpoint press resets its wire; press on a wire truncates it; releasing a one-cell path clears it, while releasing a truncated multi-cell path keeps it; completed endpoint press is debounced for 250 ms; four-step BFS searches only empty cells in up/left/down/right order; blocked routes do nothing; arbitrary existing path cells can be backtracked to; release auto-connects only a multi-cell wire adjacent to its opposite target; completion is checked on release and does not require filling the grid. The random snake generator is already a port of Generator.lua, including its direction order and isolation checks; website fallback generation remains for bounded execution.

Corrected: pressed endpoint backgrounds now tint immediately even with a single-cell path. Background tweens use 150 ms Quad Out. Expanding CircleEffect now lasts 450 ms, reaches a full-cell diameter and fades with Quad Out. Both endpoint bump effects use independent unnumbered circles, grow to 80% of a cell over 200 ms with Sine Out then reverse; labels retain their size. Win detection now checks actual first/last path cells in either direction.

Preserved: 7×7 default, size choices, scoring exclusions, infinite practice, fake-generator effects, obstacle-aware assist, once-only completion lock, tutorial centering, zoom transitions, title screen and other minigames. SFX remain the website versions. Canvas rendering is still a browser recreation of Roblox UI assets; this update does not claim pixel-identical rendering.
