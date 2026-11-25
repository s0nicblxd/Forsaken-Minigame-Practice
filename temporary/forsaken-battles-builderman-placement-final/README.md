# Builderman placement repair

Targets the exact Server and Client Sources in FCTbuildrermanbuggy.rbxl.

1. Stop Play mode and save a copy of the place.
2. Paste Repair-Builderman.command.luau into Studio's Command Bar and run it.
3. Save, then start a fresh Play test.

The repair keeps the original resting height after Carry, restores machine parts immediately, and holds that pose during the existing one-second placement lock. Construction follows Builderman's current facing until its 1.25-second reveal, then stays fixed. A direction that becomes invalid at reveal cancels construction with the existing warning.

Only Builderman's Server and Client Sources change; one Grounding helper is added. Config, assets, and PlacementPreview stay intact. Original Sources are backed up in ServerStorage. Restore-Builderman.command.luau restores the latest backup.

Validation: Luau compilation; server gameplay regression including Carry grounding, windup direction and fixed position after reveal; client grounding timing and cleanup; installer idempotence, source mismatch rejection, and rollback on write failure. Roblox Studio runtime and visual verification remain necessary.
