# Gameplay notifications

The website puzzle messages use `ReplicatedStorage/Systems/Player/Miscellaneous/NotificationDisplay`, rather than the separate purchase/achievement-card system in `Modules/Utilities/Notifications`.

Source behavior: newest message slides down in 0.2 seconds (default Quad Out tween), moves older messages down over 0.2 seconds, keeps at most three, waits seven seconds from creation, then fades text and stroke over three seconds with Quad In easing. Objective overrides use white text, Bodoni, 80% viewport width, and a 32-pixel-high text region. Each older objective is offset by its height plus 20 pixels.

Browser adaptation: same entry/stack/hold/fade timings and maximum count. Notification position stays below the practice timer to avoid covering it; multi-line text expands and subsequent messages shift by the measured height. Bodoni MT uses the installed font where available, falling back to the site's embedded Accanthis serif; typography is therefore not pixel-identical on every device. Existing website message wording and inline color spans are retained.
