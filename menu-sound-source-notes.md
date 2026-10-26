# Menu button sound research
From SidebarHandler node45277 and SidebarHandler/Classes/Button node45283.
MouseEnter plays hover and tweens to the Enter size over250ms Quad Out.
MouseLeave plays hoverEnd and tweens back to Exit size over250ms Quad Out.
Middle sidebar dimensions: Enter(.985,.25), Exit(.95,.22).
Bottom sidebar dimensions: Enter(.645,.18), Exit(.606,.149).
These are group-relative source dimensions; adapt ratios to website controls.
ToggleMenu plays select, with the shared menu transition/debounce. Active buttons
also tween their layered image and text colors over250ms. No continuous sound
for merely moving within the same button.

Decoded Sound properties:
| Cue | Asset | Volume | Playback speed |
|---|---|---|---|
| hover | 6676616742 | .5 | 1 |
| hoverEnd | 6676616742 | .5 | .8 |
| select | 6676615443 | .75 | 1 |
| click | 9125655866 | .5 | 1 |
| GeneralClose | 119104452118165 | .5 | 1 |

Downloads (Roblox access restrictions may apply):
- Hover in/out: https://assetdelivery.roblox.com/v1/asset/?id=6676616742
- Menu selection: https://assetdelivery.roblox.com/v1/asset/?id=6676615443
- Generic click: https://assetdelivery.roblox.com/v1/asset/?id=9125655866
- General close: https://assetdelivery.roblox.com/v1/asset/?id=119104452118165

No new menu sound files embedded in this research update. When supplied, bind
once per enabled UI button: pointer enter/leave and activation, with keyboard
focus equivalents and no synthetic mouse-hover sounds for touch. Apply to game
chooser, difficulty, Menu/back, credits, and other navigation controls, excluding
puzzle interaction targets (which already have their own SFX).
