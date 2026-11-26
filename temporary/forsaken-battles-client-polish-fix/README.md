# ClientPolish startup repair

Stop Play, run Repair-ClientPolish.command.luau in Studio's Command Bar, save and restart Play. No HUD import or full update rerun is necessary. The previous Source is backed up as a StringValue under ServerStorage.

The shared initializer calls module.Start on the server. ClientPolish now checks RunService:IsClient before accessing client services or LocalPlayer. Client startup is idempotent across the shared initializer and NotificationDisplay hook, concurrent starts are suppressed, and Destroy/cleanup allows a clean restart.

The actual helper is tested for server startup without LocalPlayer, a missing client player, reentrant startup while waiting for PlayerGui, duplicate startup, cleanup, restart and stale cleanup callbacks. Production and repair scripts compile.
