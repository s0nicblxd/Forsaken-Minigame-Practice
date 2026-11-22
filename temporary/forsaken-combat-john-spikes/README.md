# John Doe phase 2 — Corrupt Energy + Retract

Stop Play and run **Apply-JohnDoe-Corrupt-Energy.command.luau** in Studio's Command Bar. Requires fct4 plus John Doe's phase-one alignment patch. No model imports. Save and start a fresh playtest. Existing Guest/Helperbot/Azure changes are retained.

Normal-day Corrupt Energy: **31 spikes, 11 base damage, two registered impacts per target per cast, 0.045s between spikes**, 18s cooldown, 14s lifetime per spike. The existing two-second windup and 3.5-second cast recovery are retained. Existing special-day values are preserved. This stage does not change health, Slash, Digital Footprint, trail balance or expanded Unstoppable rules.

After casting, the same ability becomes **Retract** with UPD's retract icon. Clicking or using its normal key lowers all remaining spikes. It can be used during the original cooldown but preserves other ability locks and does not restart that timer. The local hotbar displays Retract while its original cooldown continues counting behind it. No client-provided target, timer or damage is trusted.

Server colliders rise and lower with existing spike visuals/sounds. IDs include a cast serial to avoid old expiry packets affecting a later cast. The server cancels remaining summons on interruption; already raised spikes can remain until expiry or Retract. Death/despawn destroys colliders, cancels active hitboxes, disconnects observers and restores the actor's original CanUseAbility method. Natural expiry and early retraction remove blockers and legacy CurrentSpikes entries.

A small optional **HitFilter** parameter is added to the existing shared Hitboxes implementation. John uses it to atomically reserve at most two registered spike impacts per target per cast, before damage, block reactions, knockback and hit callbacks. Invincible targets are already excluded by the normal pipeline. Blocked/ignored impacts can consume a reserved slot; they never grant global immunity. Other attacks, including the existing Corrupted effects, are not capped by this spike-impact counter. Other hitboxes without a filter retain their existing behavior, including Guest fixes and Weakness/Vulnerable damage handling.

The installer checks exact supported Sources, Source size and integrity, makes `ServerStorage.JohnCorruptEnergy_Backup_…`, rolls back failed writes and supports repeated application. Use **Restore-JohnDoe-Corrupt-Energy.command.luau** in Edit mode to restore the previous stage. Keep rig-stage backups until all stages are tested.

Studio checks: cast on flat ground; verify 31 colliders; overlap one target with several spikes and confirm no more than two base impacts; test a fresh cast resets its counter; press Retract during cooldown and verify the remaining cooldown is preserved; stun during windup/summoning; kill/reset John during a cast; check another character's normal damage and Reworked Guest's block. Local tests cannot verify Studio rendering, audio permissions or real network timing.

The original windup camera-shake timings and CorruptEnergyStart cosmetic hook are retained. Exceptional skins that define their own CorruptEnergy callback (for example #BoomerFormulaJohnDoe) keep that custom implementation and need a separate compatibility pass.

Local verification includes the actual shared Hitboxes module: a third filtered spike causes no health loss, TimesHit increment, block reaction or hit callback; an ordinary unfiltered hit still works. Server, native-hotbar, installer/restore and rollback regressions are shipped in tests/ for the Luau CLI. Real Studio/network/visual testing is still required.
