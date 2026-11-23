# Combat: skip spawn/round cutscenes and title cards

Stop Play, run **Disable-Cutscenes.command.luau** in Studio Command Bar, save and start a fresh playtest. Targets the three unmodified presentation/Actors modules from FCTnewmap!. Prior spawn, prompt, lighting and endless-round repairs do not change these Sources. Exact-source preflight protects later edits.

- ActorNetwork keeps skin application, asset preload, chase-theme registration, Created/CreatedPost callbacks, local animations, hotbar, stamina and replication. Removes the entire introduction section after lifecycle callbacks: animated killer intro, intro-only sound/voicelines, camera/material/lighting overrides, title cards, SkipIntros fallback title cards, fades and delayed HUD disabling/restoration.
- Actors no longer generates an Intro background when creating a character. Rig setup, health/stats, gameplay behaviors, replication and animations are untouched. The cutscene actor helper remains available for other APIs/previews.
- RoundNetwork still handles map creation, gamemode initialization/destruction and ordinary gameplay events. PreHandleGamemode no longer fades into a transition; PlayWinnerCutscene becomes a no-op, including killer/survivor victory cinematics, result-card UI and timed Return button. Endless mode already blocks ordinary wins; this also blocks accidental/external victory presentation events.
- Combat lighting and its custom/default API stay intact. No global camera lock or blanket lighting suppression is added. Attack animations, executions, ability VFX, shop previews, NPC dialogue and map interactions are outside this change.
- No player setting needs toggling. Fresh playtests are required to discard already scheduled introduction callbacks from the old module.

Installer backs up the three Sources and child assets in ServerStorage/NoCutscenes_Backup_..., rolls back failed writes, and is idempotent. To undo, stop Play, select that backup folder and run Restore-Cutscenes.command.luau, save and restart Play. Restore refuses later Source edits.

Actual camera/UI behavior, character-specific Created hooks and multiplayer sessions require Studio verification.

Local validation: all delivered Sources compile. Tests execute both complete client network modules, dispatch remote killer/survivor creation, verify lifecycle/preload/chase/fix-character callbacks without title/fade/camera paths, exercise no-op winner/transition events and retained map/gamemode handlers. The local movement/hotbar/replication section is byte-identical to the input. Installer tests cover repeat application, exact restore, failed-write rollback and source-edit refusal. Full local-player initialization/camera visuals require Studio verification.
