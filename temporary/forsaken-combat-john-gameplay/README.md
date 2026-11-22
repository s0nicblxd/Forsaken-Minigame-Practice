# John Doe — remaining confirmed gameplay update

Stop Play and run **Apply-JohnDoe-Gameplay.command.luau** in Studio's Command Bar. Requires the corrected John rig stage, Corrupt Energy phase 2 and the Retract cooldown repair. No imports. Save and start a fresh playtest. Includes **Restore-JohnDoe-Gameplay.command.luau** and ServerStorage backups.

## Confirmed changes

- Normal-day health 1,500 → 2,300. Special-day health values retained.
- Slash windup 0.4 → 0.35s; forward offset -1.75 → -2.25 studs. The existing 4.5 × 6 × 7.5 hitbox dimensions, grounded vertical compensation, 28 damage, 1.75s cooldown and 0.25s linger remain.
- Digital Footprint's two planar dimensions grow by 30%: stomp stages 7.8 / 15.6 / 23.4 studs instead of 6 / 12 / 18. Thickness, cooldown, trap limit and effects remain. Detection and presentation use that same enlarged Part.
- TrailLength 48 → 52, allocating 13 pieces instead of 12. Piece width/thickness unchanged; corrected ground placement retained.
- Corrupt Energy's Unstoppable window lasts until 1.5 seconds after natural cast completion. Cancellation does not open an extra window. Retract does not extend it. 404 Error retains its cast-only trigger window.
- Triggered Unstoppable retains its two-second stun override, triggering-ability half-base-cooldown refund (without extending a shorter remainder), roar and Speed I for 3s + one second per living Sentinel. Dead, spectating and duplicate rigs do not add extra duration.
- While that Unstoppable boost window and a Speed status are active, incoming negative status durations are halved. Positive statuses, status levels, other characters and existing debuffs are not retroactively altered. Newly applied/refreshed debuffs use the requested or original module default duration, avoiding repeated halving of an already reduced duration.
- Confirmed UPD sound references replace the old sound references. Animation IDs and skin files are untouched. Terror-radius distances are retained because the supplied patch logs do not establish a radius change for this stage.
- No kill-growth hook is added.

## Compatibility and verification

The stun handler now captures an override before attribute callbacks cancel the casting ability. John opts into the new policy; other actors retain their existing stun/stacking/immunity behavior. The shared status module has an optional actor duration hook; only John supplies it. Legacy debuffs without IsNegative metadata are classified explicitly; explicit positive metadata wins. The prior Retract confirmation fix remains present.

Existing skin overrides remain existing overrides; no custom skin implementation or model is ported in this stage. Animations remain the user's current media. Real Studio checks must cover the two-second stun override, linger boundary, Speed protection expiry, refreshed Slowness/Weakness, status UI, footprints and restored cooldown behavior.

Preflight checks exact prior Sources, module types, Source size and content integrity before mutation. Failed writes roll back. Repeated application is a no-op. Backups are JohnGameplay_Backup folders in ServerStorage. Local tests cannot verify Roblox rendering, asset permissions or real multiplayer latency.

## Tooltip repair

If the earlier installer was already applied and Config fails with `invalid option %l to format`, stop Play and run `Repair-JohnDoe-Tooltip.command.luau`, save, then start a fresh playtest. It escapes the literal percent in the Digital Footprint tooltip in both stores, with preflight checks and Config backups. The main installer now contains the corrected tooltip. `tests/config-regression.luau` executes both complete Configs on normal and special days, including every formatted tooltip.
