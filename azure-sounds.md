# Azure plant-disarming QTE sounds

Found in `ReplicatedStorage/Assets/Killers/Azure/Config/cl_WorkaroundModules/cl_QTEUI` in the supplied place file.

| Cue | Original asset download | Source volume |
| --- | --- | --- |
| Successful target hit | [71465325684164](https://assetdelivery.roblox.com/v1/asset/?id=71465325684164) | 0.65 |
| Marker reverses direction at an end | [80333007156131](https://assetdelivery.roblox.com/v1/asset/?id=80333007156131) | 0.40 |
| First miss warning | [96573322554989](https://assetdelivery.roblox.com/v1/asset/?id=96573322554989) | 0.70 |

The methods are `PlayHitSound`, `PlayCornerSound`, and `WarnFailedAttempt`. The QTE controller invokes the warning on the first miss; the second miss ends the attempt directly. No separate win sound is called in the inspected QTE modules.

The IDs above come from the inspected game source. The user supplied the audio files listed below after Roblox denied the asset downloads.

## Embedded audio update

The supplied cornerHit.mp3, click.mp3, miss.mp3, and Azure_plantvanish.ogg are now embedded in the HTML. click plays on a successful target hit; miss on the first miss; plantvanish on the second miss/reset; cornerHit once each time marker direction reverses. No extra win cue. Volume: 0.40 / 0.65 / 0.70 / 0.70 respectively. Leaving the mode stops its active audio.
