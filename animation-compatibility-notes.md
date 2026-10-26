# Animation compatibility
Reduced-motion settings intentionally suppress shakes and some decorative effects;
those settings alone should not stop gameplay. Without the affected user's browser
information, the exact device-specific cause cannot be confirmed.

All Web Animations UI calls now use animateUI. It tries the native API; missing or
throwing APIs apply the final visual state and complete asynchronously. A bounded
timeout completes finite transitions if the browser never emits finish. Explicit
cancellation clears the fallback and prevents stale completion handlers. Filled
fallback styles restore on cancel, matching native cancellation behavior. Animation
tracking works without Element.getAnimations. Older browsers lacking individual
scale/rotate properties receive equivalent transform keyframes.

Verified in Chromium with native animations removed + reduced motion, and with
stubbed animations that never finish: title visibility/exit, Bloodhook readiness,
Connect and Lock readiness, Entanglement completion, and Credits close. Normal
native-animation credits/music regression checks also pass. Background-tab rAF
throttling and disabled JavaScript are not overridden by this compatibility layer.
