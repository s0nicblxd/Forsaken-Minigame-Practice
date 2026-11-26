# Chance expression fallback

Observed live diagnostic: Chance existed at Workspace.Players.Survivors.Chance but had no ExpressionHolder or expression Decal; the diagnostic's Actors module registry was empty. That registry result does not prove the game's running actor manager is empty. The exact reason native setup was skipped is unresolved.

Repair-Chance-Expressions.command.luau installs a Chance-only fallback called directly from Behavior.Created on the server, after initial health assignment. It uses the actual actor Config, including custom expressions, and creates the native ExpressionHolder from the shared template when missing (or a transparent head-sized part if the template is unavailable). It binds temporary ability expressions, health expressions and cleanup without consulting the diagnostic's registry. Configs and image IDs are never rewritten. Images still need valid IDs and experience access.

Stop Play, save a copy, run the repair in Studio's Command Bar, save and start a fresh session, then respawn as Chance. Supports the uploaded original or updated Chance Behavior, and both stored copies. Original Behavior Sources are backed up in ServerStorage. Unexpected Behavior edits are rejected before changes. Apply the balance update before this fallback.

Validation: Luau compilation; mocked runtime tests for absent/existing holders, custom IDs, timed expressions, damage/injury/death, cleanup and repeated attachment; installer tests for successful/repeated installation, source mismatch rejection and write-failure rollback. Studio rendering and asset loading remain to be verified.
