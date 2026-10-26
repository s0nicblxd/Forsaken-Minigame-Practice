# Entanglement popup assets

Extracted from the supplied Forsaken place file. These are asset references; PNG bytes are not stored in the place file. Open download links in a browser logged into Roblox.

## Base popup set

`ReplicatedStorage/Assets/Killers/1x1x1x1/Config/Popups`

| Name | Original image download |
| --- | --- |
| 11 | [116631150588709](https://assetdelivery.roblox.com/v1/asset/?id=116631150588709) |
| 11Alt | [100062705970397](https://assetdelivery.roblox.com/v1/asset/?id=100062705970397) |
| 7 | [111642617334438](https://assetdelivery.roblox.com/v1/asset/?id=111642617334438) |
| 7Alt | [99826888816291](https://assetdelivery.roblox.com/v1/asset/?id=99826888816291) |
| 98 | [110042635733309](https://assetdelivery.roblox.com/v1/asset/?id=110042635733309) |
| 98Alt | [128469390878313](https://assetdelivery.roblox.com/v1/asset/?id=128469390878313) |
| xp | [103752502487728](https://assetdelivery.roblox.com/v1/asset/?id=103752502487728) |
| xpAlt | [77382093337962](https://assetdelivery.roblox.com/v1/asset/?id=77382093337962) |
| xpAlt2 | [96018108880852](https://assetdelivery.roblox.com/v1/asset/?id=96018108880852) |

## Other skin sets

### Toon1x1x1x1

- 1: [78922256954889](https://assetdelivery.roblox.com/v1/asset/?id=78922256954889)
- 2: [126630260510690](https://assetdelivery.roblox.com/v1/asset/?id=126630260510690)
- 3: [100591320034159](https://assetdelivery.roblox.com/v1/asset/?id=100591320034159)
- 4: [120376252611788](https://assetdelivery.roblox.com/v1/asset/?id=120376252611788)
- 5: [125677387018083](https://assetdelivery.roblox.com/v1/asset/?id=125677387018083)

### OneScoop1x1x1x1

- 1: [139398696917742](https://assetdelivery.roblox.com/v1/asset/?id=139398696917742)

### Martyr1x1x1x1

- 1: [73548270735101](https://assetdelivery.roblox.com/v1/asset/?id=73548270735101)
- 2: [88230450055845](https://assetdelivery.roblox.com/v1/asset/?id=88230450055845)
- 3: [114658385896262](https://assetdelivery.roblox.com/v1/asset/?id=114658385896262)
- 4: [81578972169731](https://assetdelivery.roblox.com/v1/asset/?id=81578972169731)
- 5: [71091352754392](https://assetdelivery.roblox.com/v1/asset/?id=71091352754392)
- 6: [122056933683140](https://assetdelivery.roblox.com/v1/asset/?id=122056933683140)

### Hacklord1x1x1x1

- 1: [122424994522396](https://assetdelivery.roblox.com/v1/asset/?id=122424994522396)
- 2: [72996043556526](https://assetdelivery.roblox.com/v1/asset/?id=72996043556526)
- 3: [123088589881509](https://assetdelivery.roblox.com/v1/asset/?id=123088589881509)
- 4: [116653678103851](https://assetdelivery.roblox.com/v1/asset/?id=116653678103851)

### Doctor1x1x1x1

- 1: [81278893013784](https://assetdelivery.roblox.com/v1/asset/?id=81278893013784)
- 2: [86504799997103](https://assetdelivery.roblox.com/v1/asset/?id=86504799997103)
- 3: [72202459933084](https://assetdelivery.roblox.com/v1/asset/?id=72202459933084)
- 5: [132182461238362](https://assetdelivery.roblox.com/v1/asset/?id=132182461238362)
- 4: [126264204449561](https://assetdelivery.roblox.com/v1/asset/?id=126264204449561)

### Crazyblox1x1x1x1

- 1: [124765175276580](https://assetdelivery.roblox.com/v1/asset/?id=124765175276580)
- 2: [93825674307982](https://assetdelivery.roblox.com/v1/asset/?id=93825674307982)
- 3: [98038380441553](https://assetdelivery.roblox.com/v1/asset/?id=98038380441553)
- 4: [135306906656541](https://assetdelivery.roblox.com/v1/asset/?id=135306906656541)
- 5: [127895091266400](https://assetdelivery.roblox.com/v1/asset/?id=127895091266400)
- 6: [85883317787428](https://assetdelivery.roblox.com/v1/asset/?id=85883317787428)

### #BoomerFormula1x1x1x1

- 11: [116631150588709](https://assetdelivery.roblox.com/v1/asset/?id=116631150588709)
- idk: [110042635733309](https://assetdelivery.roblox.com/v1/asset/?id=110042635733309)
- xp: [103752502487728](https://assetdelivery.roblox.com/v1/asset/?id=103752502487728)
- 7: [111642617334438](https://assetdelivery.roblox.com/v1/asset/?id=111642617334438)

### Abyss1x1x1x1

- 1: [94796587735811](https://assetdelivery.roblox.com/v1/asset/?id=94796587735811)

### AceOfSpades1x1x1x1

- 1: [83903167407210](https://assetdelivery.roblox.com/v1/asset/?id=83903167407210)
- 2: [88487835796584](https://assetdelivery.roblox.com/v1/asset/?id=88487835796584)
- 3: [123334888850944](https://assetdelivery.roblox.com/v1/asset/?id=123334888850944)
- 4: [117214208188730](https://assetdelivery.roblox.com/v1/asset/?id=117214208188730)

## Behavior found in source

- Base Config sets EntanglementPopupCount to 9 and EntanglementPopup sound to 75455886794852.
- Base Behavior.cl_Entangled randomly selects images, varies size from 90% to 130%, scatters them around screen center, generates 18 glitch rectangles per popup during the first 0.15 seconds, then reveals and fades the images. Lifetimes range from 1.2 to 2.6 seconds; positional jitter decays over time. It checks the EpilepsyMode setting for the glitch appearance.
- The base effect uses ImageLabels and is not a clickable minigame.
- The #BoomerFormula skin Behavior retains an older handler which clones each popup ImageButton, places it randomly, destroys it on click, and notifies the server once all popups are dismissed. Its folder has four templates. This is evidence for that skin, not proof of the exact historical base-game rules.
