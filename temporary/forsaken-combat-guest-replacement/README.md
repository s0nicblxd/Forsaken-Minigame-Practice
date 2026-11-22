# Replace classic Guest with Reworked Guest — fct4

The uploaded fct4 already renamed the reworked kit to `ReplicatedStorage.Assets.Survivors.Guest1337`. This patch completes that change; it does not import another Guest or reset the kit's balance.

## Apply

Stop Play and run **Replace-Guest-With-Rework.command.luau** in Studio's Command Bar. Save and start a fresh playtest. No models to import.

- Retains the uploaded reworked Config, abilities, animations, sounds, and Config children.
- Fixes the two remaining `Guest1337Rework` identity comparisons used for Charge knockback and Punch debuff stacking.
- Replaces stale `ServerStorage.Assets.Survivors.Guest1337` with a matching clone of the working reworked character.
- Consolidates the two identical 73-skin categories under `Guest1337` in both storage services. Existing canonical skins win; any alias-only skins are retained. Rework categories are archived outside Assets, so shop/inventory asset scans cannot list them.
- Keeps canonical `Guest1337` rig locations, character ID, skin IDs, purchase/XP keys, achievements and killer execution references. Those existing Guest1337 references already point to the desired replacement and should not be renamed.
- Leaves unrelated characters and shared combat/status systems untouched.

The fct4 audit found 84 identical skin module Sources per service between the canonical and duplicate categories. No active non-skin code references to `Guest1337Rework` remain after the two identity fixes; archived backups intentionally retain their original contents.

Preflight checks the actual uploaded fct4 Sources, verifies Studio Source limits and prepares the stored clone before mutation. Backups are placed in `ServerStorage.GuestReplacement_Backup_…`; write failures roll back. Use **Restore-Guest-Replacement.command.luau** in Edit mode to restore the uploaded pre-replacement state. No DataStore writes or player-data resets are performed.

In Studio, confirm one Guest entry, all owned Guest skins still available, Block/Charge/Punch using the reworked rules, and multiplayer stacking reductions working between characters now named Guest1337. Local regression checks cover replacement, storage synchronization, skin consolidation, rollback, repeated application and restore; a real Studio playtest remains necessary.
