# Noli hallucination depletion effect

Source: the supplied Forsaken place file, `ReplicatedStorage/Modules/Schematics/StatusEffects/KillerExclusive/Hallucination`.

`Removed` destroys the active hallucinations. `HallucinationClass/Screamer.Destroy` calls `Screamer()` then `Clean()`.

`HallucinationClass.Screamer` clones `Noli/Config/noliLaugh`, loads its Animation into its Animator, waits for a nonzero track length, and plays the track with the screamer sound. Every RenderStepped it sets the model primary-part CFrame to the current camera CFrame. MagicGuy has two SurfaceGuis with face images.

- Motion animation: `rbxassetid://115073581864188`.
- Face spritesheet: `rbxassetid://114477848403909`, NoliLaugh, 12 FPS, four frames, 2 rows × 2 columns, resolution 1024 × 1024.
- Initial image on both SurfaceGui ImageLabels: `rbxassetid://131253885793217` (replaced by the spritesheet handler).
- Grow MagicGuy from zero to its original size over 0.3 seconds, Quad Out.
- At track length minus 0.5 seconds, set the image TimeScale to 3 and shrink MagicGuy to zero over 0.5 seconds, Quad In.
- At track length, disconnect the camera update and destroy the model.

The flip/translation keyframes are in the referenced animation asset, not the Lua. The supplied place contains the Animation ID but not the animation keyframes. The website's existing footage-traced movement is retained pending an exported animation; it is not an exact source port. To complete the port, export animation 115073581864188 as a KeyframeSequence (.rbxm/.rbxmx), or supply a model containing that KeyframeSequence, plus the spritesheet image 114477848403909 for exact frame playback.
