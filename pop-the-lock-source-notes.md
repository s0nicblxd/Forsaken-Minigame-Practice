# Pop the Lock

Sources: supplied LockBoard, LockInput, LockRenderer and LockClientMinigame modules; uploaded Gamefinite 1080p recording (484.62 seconds, 30 fps). Pop the Lock gameplay is around 425–475 seconds. Frame samples at 430.0–430.37 show the marker moving roughly 57 degrees, suggesting approximately 160 degrees/second. The white target covers approximately 40 degrees. These two configuration values are estimates, not recovered server constants. Seven required hits is visible in the recording.

Implemented source rules: hit tolerance is target half-width plus 3 degrees, each hit decrements remaining and reverses direction except the last, the next target is 90–270 degrees from the hit, and a miss resets remaining without changing the target/direction/motion anchor. Passing the target without pressing is not penalized. Browser target randomness uses Math.random rather than Roblox's server-seeded random stream.

Mouse/touch and Space controls, green/red ring feedback, hit bump, miss shake, shackle opening, source 0.9-second completion window, automatic next rounds, zoom transitions, one-time tutorial, scoring and generator entry audio are integrated. Supplied lock PNGs are embedded. Existing website audio substitutes remain. Controller input is not yet implemented in this browser port.

Verified via Chromium: hit decrement, direction reversal, miss reset retaining direction, duplicate-completion protection, next-round reset and exit cleanup. Desktop screenshot inspected.

### Visual refinement
Compared against the earlier Gamefinite footage: enlarged the counter and red
marker and tinted the lock sprites light gray. Speed and target width remain
video estimates, not verified server configuration. Completion now invokes the
same sound as Flow once per solve.

The two supplied `Recording 2026-10-25 203142.mp4` uploads are byte-identical and
show Connect the Wires only. Used this clearer recording plus ConnectRenderer
for its exact palette, 12% terminal / 6% wire sizing, and reversed Sine Out
mate pulse. Connect also now plays Flow's completion cue once per solve.
Validated both games in Chromium: linking/disconnecting, persistent pulses,
lock hits/misses/direction reversal, single scoring and completion cue,
automatic next round, and cleanup on exit.

### New Pop the Lock reference: Recording 2026-10-25 203147.mp4
This 41-second recording supersedes the earlier fixed speed/arc estimates.
Measured target spans across its five puzzles are approximately 45, 40, 35, 30,
and 25 degrees. Tracked the red marker over uninterrupted motion segments;
approximate speeds used are 145, 165, 185, 205, and 225 degrees/second. These
remain video estimates, not recovered server constants. Endless practice repeats
this five-round progression and reentry starts from the first stage; misses
reset the seven hits without changing the current difficulty or direction.

Matched the lock-to-ring proportions (230px sprite box in a 500px SVG), gray
sprite tint, counter baseline/font size, and rounded red marker to the clip.
Completion sound follows the 900ms unlock sequence, consistent with the client
Finish method; leaving cancels pending sound and round transition.

Chromium verification passed all five stages and cycling, hits/misses,
single score/sound per solve, restart, and exit during the unlock sequence.
