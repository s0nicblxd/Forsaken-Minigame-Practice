# Azure plant-disarming QTE sounds

Found in `ReplicatedStorage/Assets/Killers/Azure/Config/cl_WorkaroundModules/cl_QTEUI` in the supplied place file.

| Cue | Original asset download | Source volume |
| --- | --- | --- |
| Successful target hit | [71465325684164](https://assetdelivery.roblox.com/v1/asset/?id=71465325684164) | 0.65 |
| Marker reverses direction at an end | [80333007156131](https://assetdelivery.roblox.com/v1/asset/?id=80333007156131) | 0.40 |
| First miss warning | [96573322554989](https://assetdelivery.roblox.com/v1/asset/?id=96573322554989) | 0.70 |

The methods are `PlayHitSound`, `PlayCornerSound`, and `WarnFailedAttempt`. The QTE controller invokes the warning on the first miss; the second miss ends the attempt directly. No separate win sound is called in the inspected QTE modules.

These IDs are verified against the source, but the audio files have not been downloaded or auditioned here. They are not yet embedded in the HTML. Open the links in a browser logged into Roblox; audio access may depend on Roblox's permissions. Keep the downloaded audio format (do not rename it to PNG). Upload the downloaded files together in a ZIP for embedding.
