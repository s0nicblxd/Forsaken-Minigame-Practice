# Credits menu research (implementation pending assets)
The requested entry belongs in the main menu's bottom-right corner.
SidebarHandler (node45277) uses TweenInfo.new(0.25), default Quad/Out.
On first open Menu.Size starts0,0, expands to screen size minus20px margins.
Closing collapses height to0 while keeping full width; hides after250ms.
Subsequent opening grows from that collapsed-height state. Menu input debounce
is300ms; switching away from an existing menu adds125ms.
Inventory and Credits both use CreateSidebarMenu. Credits module46083 has no
custom OnTransitionState, so uses the shared transition directly.

Original CreditsScreen requires:
- CreditsContainer image123911976725450:
  https://assetdelivery.roblox.com/v1/asset/?id=123911976725450
- Exit image81726400449787:
  https://assetdelivery.roblox.com/v1/asset/?id=81726400449787
No credits UI coded, per user's instruction to wait for needed assets.
Actual credit entries/names remain to be provided by the user.

Audio changes in this update:
- Restore playOldGenComplete for legacy solves.
- Embed supplied lockMiss.mp3 only for Pop the Lock misses.
- Embed supplied titleStatic.ogg for the existing title continue static ramp.
  Starts on input, ramps over1.2s, stops at the title transition.
