# Chance face/reroll and Malice repair

Targets the actual Sources and rig in FCTgoodprogress.rbxl. Stop Play, save a copy, run Repair-Chance-Remove-Malice.command.luau in Studio's Command Bar, save and start a new Play session.

## Findings and changes

The saved Chance default ExpressionHolder.WeldConstraint.Part0 references ServerStorage.Assets.Rigs.Survivors.Builderman.Default.Head, while Part1 references Chance's holder. The repair binds it to Chance's own Head and aligns the holder using the native expression offset. The runtime ChanceExpressions helper also removes inherited holder welds and creates an explicit Chance-to-holder binding on every spawn.

The ReplicatedStorage Chance Config still has HealthMin=65, HealthMax=130, RerollBasePenalty=10 and no HealthClamp. The ServerStorage copy has the updated balance. Both are aligned to 70/110/0/120 while preserving the uploaded expression IDs from the live ReplicatedStorage Config. Reroll also defaults its clamp to 120 when the runtime field is missing.

Malice writes through the shared stat function are blocked, including forced writes. Actor rewards no longer credit Malice or include it in messages. Money, NetWorth and XP are retained. The Malice setting is omitted from the Settings menu. SetPlayerMalice is archived into the backup, and the admin money giver no longer offers Malice. Existing Kills leaderboards and combat stats are preserved. Legacy stored Malice values remain as unused compatibility data.

## Backup and verification

The installer validates all nine Source targets before editing, backs up Sources and the original weld/holder properties, and rolls back on failure. Restore.command.luau restores the latest backup including the archived command.

Validation: all Luau production scripts compile; runtime tests cover cross-rig weld replacement, uploaded IDs, temporary and injured/dead expressions, listener cleanup, Malice gain suppression, retained Money/NetWorth/EXP messages, and the missing-clamp case. Installer tests cover current-file installation, the physical weld, command archival, repeat runs, source mismatch rejection and simulated write-failure rollback.

Studio rendering, uploaded-image access and live gameplay still need verification. If an uploaded ID is inaccessible or is a Decal ID rather than its underlying image, a correct weld alone cannot make that asset render.
