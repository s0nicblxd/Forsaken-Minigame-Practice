# Menu refresh

The downloadable HTML now uses a unified game selector, generator tabs, artwork preview and Practice button. It reuses the title logo with the Minigame Practice subtitle. Background remains plain pending the user's artwork plan. No preview/category descriptions, room labels, concept badge, footer divider or footer slogan are included. Title-screen code is unchanged.

Flow grid size uses an options dropdown in the menu and during gameplay. Legacy has typed width/height inputs in both locations, clamped to whole numbers from 2 to 8; empty/invalid values restore the previous setting. Existing score eligibility rules remain intact. Menu size choices apply on Practice; in-game Legacy dimensions apply on New Puzzle. Bloodhook difficulty can be selected before launching.

Source reference: ReplicatedStorage/Systems/Player/UI/Menus/Settings/Templates/String, CreateSettingUI and OnUpdate. The Roblox dropdown toggles its options, rotates its arrow 180 degrees, updates the chosen value and closes after selection. This HTML uses native details/summary plus buttons for equivalent behaviour, keyboard access, outside-click dismissal and Escape dismissal without exiting the game. Unavailable menu SFX are not fabricated.

The new user-supplied requiem.ogg is embedded byte-for-byte and replaces assets/audio/menu-theme.ogg. Native looping and the established title/puzzle pause/resume transitions remain; a menu volume slider controls the music. Duration: 189.629637 seconds. Preview illustrations are decorative; graffiti, gear and entanglement previews reuse supplied artwork.

Validation: Chromium checks cover menu selection versus launch, Flow grid selection and Escape dismissal, Legacy input bounds and applied dimensions, Bloodhook difficulty, Credits, mobile horizontal fit, and no JavaScript errors. Desktop/mobile screenshots inspected. Audio bytes compared against upload; title code compared against previous commit. Title music regression checks cover loading gesture playback, post-static blackout pause, retained position and resume.
