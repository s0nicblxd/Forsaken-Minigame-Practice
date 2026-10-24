# Title screen recreation

Sources: user-supplied TitleScreen.lua and the TitleUI descendants in the supplied Forsaken place.

Implemented: title screen after clicking the loading prompt; 0.5-second initial black hold, veil fade beginning 0.12 seconds after the source flash starts, title and prompt fade at 2 seconds over 2 seconds with Cubic Out, input enabled at 3 seconds, 1.5-second Quad Out title rise, randomized sine/cosine drift periods 2.8–6.6 seconds, normalized cursor smoothing `1 - 0.1^dt`, two moving noise layers, 1.2-second Quad In noise buildup on input, 2-second black hold, and 0.35-second Sine Out top/bottom shutter reveal. Reduced motion suppresses the flash/parallax, updates noise at 0.5-second intervals, and uses the source 0.75-second plain reveal instead. Keyboard and pointer/touch input are supported, with a once-only continuation guard.

The loading percentage now switches directly to the clickable start prompt; it does not crossfade. Artwork stays until that prompt is activated.

## External assets found

| Role | Roblox asset ID | Source behavior |
| --- | --- | --- |
| Rising static | 8028069841 | Looped, volume ramps from 0 to 0.2 over 1.2 seconds (0.1 with reduced effects), then stops |
| Reveal sound | 87154692307900 | Plays once at volume 1 when the black hold ends; omitted with reduced effects |
| Title logo | 89700559948630 | White image, aspect ratio 2.28, center approximately (0.5, 0.2268) |
| Noise texture | 15344951630 | Repeated at 512 × 512, red (#7e0000) and black layers, initial opacity 0.07 |

These assets are referenced by ID in the place, not embedded media. Uploaded audio/image copies are still needed. No guessed sound is substituted: TITLE_ASSETS sound slots are null until supplied. The current visual fallbacks are the site's existing loading artwork, a FORSAKEN text title, and procedurally generated noise. The original background is a live 3D lobby camera at Map/Lobby/POIs/TitleScreenCamPos; the browser uses a moving image approximation. This is a recreation of the source sequence, not a pixel-identical rendering of the original lobby.

## Video-reference corrections

Compared against the supplied 20.52-second recording. Loading percentage is above the italic status line at the lower-right edge. The title prompt uses the source 3.8764%-of-height sizing and approximately 40% white opacity; automatic focus glow is removed. Both noise layers start at zero opacity at the user's request and ramp only after continuation. “Minigame Practice” is a separate subtitle that follows the title's drift and fade. No warning screen is added.

The inline logo preview was visible in chat but was not supplied to the execution workspace as downloadable image bytes. A PNG/WebP upload is needed to replace the temporary text logo with that exact asset.
