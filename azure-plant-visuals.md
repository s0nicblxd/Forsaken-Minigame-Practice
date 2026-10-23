# Azure plant-disarming UI visuals

Located in the supplied place file at:
`ReplicatedStorage/Assets/Killers/Azure/Config/cl_WorkaroundModules/cl_QTEUI/QTE`

This catalog contains visual references only. No Azure gameplay was added to the HTML.

| Visual | Original image download | Instance |
| --- | --- | --- |
| Outer QTE bar artwork | [76906278748627](https://assetdelivery.roblox.com/v1/asset/?id=76906278748627) | `QTE/ImageLabel` |
| Target-zone artwork | [103219386078445](https://assetdelivery.roblox.com/v1/asset/?id=103219386078445) | `QTE/Zone/ImageLabel` |

Open the links in a browser logged into Roblox. The place file stores image references, not the PNG bytes; these downloads have not been previewed here.

## Visual settings from the template

- Container: centered on screen; width 30% of the parent plus 75 px, height 5% plus 15 px. Transparent background.
- Outer artwork: stretched, white tint, fully opaque. Size 110% of container width plus 10 px, 167.026% of container height plus 10 px. Position -5.777% horizontally and -49.180% vertically. These offsets intentionally let the artwork extend outside the logical bar.
- Zone artwork: stretched, white tint, fully opaque. Size 116.581% of its zone width and 110% of its height; position -7.488% horizontally and -7.026% vertically. The template zone is 40% of the bar width; live zone widths vary.
- Moving marker: a solid red Frame (#ff0000), 1% of the bar width and 120% of its height. No image or decal. ZIndex 2 places it over the artwork.
- Both image layers use Stretch, not nine-slice.
- A sibling `OLDQTE` template also exists. It consists of plain Frames and has no image assets.

The two assets above are the images stored under the QTE template, not Azure's unrelated character textures or world-space plant particle effects.
