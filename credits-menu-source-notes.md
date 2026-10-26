# Credits menu and menu theme
Implemented bottom-right Credits button on the main menu. Uses supplied
CreditsContainer123911976725450 and Exit81726400449787 textures. The X is text,
as confirmed in CreditsScreen/Exit/Text. Credits content acknowledges only the
Forsaken Dev Team, as requested. Overflow scrolls by wheel/touch; dialog traps
focus and closes with X or Escape, returning focus to its opener.

SidebarHandler node45277 uses TweenInfo.new(0.25), default Quad Out. First opening
grows from zero on both axes; closing collapses height; subsequent openings grow
height. Credits uses the shared SidebarHandler, not a custom transition.

AzureLobby.mp3.mpeg was converted to embedded Vorbis for offline playback. Trimmed
0.88s leading silence and blended the last/first120ms into a wraparound seam.
Browser audio loops without scheduling another player. Menu volume .35; entering
any puzzle fades volume to0 across the existing350ms black transition and pauses
without resetting currentTime. Returning to either menu fades in/resumes; submenu
and credits navigation keep playback continuous. Playback starts only after the
title flow; browser autoplay rejection retries on a real menu gesture.

Chromium checks: real audio playback and loop wrap, fade and pause timing,
preserved resume position, credits X/Escape/focus, mobile containment and wheel
scrolling. Audio source and textures included under assets/ and embedded in HTML.
