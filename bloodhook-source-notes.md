# Bloodhook practice: recovered source and local bot

Source: `ReplicatedStorage/Assets/Killers/Nosferatu/Behavior`, function `cl_bloodhookQTEBegin`, and `Nosferatu/Config`.

Recovered client behavior: W/A/S/D prompts with the next key visible; adjacent prompts differ; incorrect allowed keys fail, unrelated keys are ignored. Mobile uses a randomly placed tap target that grows over 0.22 seconds, starts shrinking after 0.55 seconds, and expires after 1.35 seconds. The progress display reads server attributes NosPullFavor/NosPullFavorMax. The saved client source does not include their authoritative scoring handler.

## Practice bot tuning

The user plays the escaping survivor against a Nosferatu bot. This local contest balance is custom, not a claim of exact server behavior. Starts at 50/100 escape progress; correct player input +8, wrong input -10; correct bot input -6, bot error +4. Reaching 100 wins, reaching zero loses. Only wins increment the shared counter. Results restart after 0.65 seconds. Repeated keydown events and inputs within 100 ms are ignored.

| Difficulty | Average reaction interval | Accuracy |
| --- | --- | --- |
| Easy (initial default) | 1.20 seconds | 65% |
| Medium | 0.80 seconds | 82% |
| Hard | 0.48 seconds | 96% |

Bot intervals vary by ±15%. Changing difficulty starts a fresh contest. Background tab time does not replay missed bot actions.

## Original SFX downloads

| Cue | Asset |
| --- | --- |
| Success variant 1 | [91417050997662](https://assetdelivery.roblox.com/v1/asset/?id=91417050997662) |
| Success variant 2 | [92272415010778](https://assetdelivery.roblox.com/v1/asset/?id=92272415010778) |
| Success variant 3 | [107032865404056](https://assetdelivery.roblox.com/v1/asset/?id=107032865404056) |
| Failure | [77699647248581](https://assetdelivery.roblox.com/v1/asset/?id=77699647248581) |

These IDs are from Config.Sounds.QTESucceed/QTEFail. Audio is not embedded yet; Roblox may deny downloads even when logged in. User-supplied audio files can be embedded later.

## UI image references

The PC keycap is changed at runtime to the built-in `rbxasset://textures/ui/Controls/key_single@3x.png`. Controller D-pad images also use built-in Roblox textures. The saved PC template lists 13045815791; the mobile template lists 180084495. The practice version draws keycaps and tap targets with CSS, with no external image dependency. It does not yet implement the source controller D-pad variant.
