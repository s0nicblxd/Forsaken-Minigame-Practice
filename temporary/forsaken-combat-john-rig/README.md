# John Doe rig phase 1 — corrected appearance

The initial release chose UPD's MainRig without visually verifying that it matched the intended John. That was the wrong appearance for this port. This revision keeps the fct4 model shown in the user's reference instead.

Stop Play and run **Repair-JohnDoe-Appearance.command.luau** (or the identical Apply command) in the Studio Command Bar. No model import is needed. If the earlier patch replaced John, this recovers his original model from its first ServerStorage backup. Fresh fct4 installations simply use the existing John model. Both asset stores are updated.

SCALE=1.25 remains an adjustable initial height calibration, not a verified official multiplier. Rerunning with another scale is absolute and does not compound scaling. Original meshes, clothing, joints, and animation IDs are retained. Collision/query use scaled FCT profiles. Ground clearance, trail placement, camera and grounded Slash alignment remain in place; damage, cooldowns and other kit balance are unchanged. Existing skins retain their models.

The installer refuses unrecognized code edits or missing original-model backups. It makes another JohnDoeRig_Backup folder and rolls back on write failure. Restore-JohnDoe-Rig.command.luau restores the latest phase-one change; running it again can restore the preceding stage. Keep the backups until the final Studio test passes.

The reported timeout begins in Roblox CorePackages Foundation/InternalDrawer, followed by dependent Roblox UI module-load failures. This patch does not edit those modules. The stack alone does not establish a connection to John. After saving, completely stop Play and restart Studio before a fresh test; if it repeats, capture the first timeout plus any earlier project-script errors. Do not delete or replace Roblox CorePackages.
