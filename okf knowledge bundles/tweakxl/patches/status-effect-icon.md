---
type: Patch
title: Status Effect Icon Fix
description: WrapMethod patch fixing status effect icon rendering in the stealth mappin controller.
resource: sources/TweakXL/scripts/StatusEffect.reds
tags: [tweakxl, redscript, patch, status-effect, icon, ui, mappin]
timestamp: 2026-07-08T12:46:00Z
---

# Overview

This patch wraps `StealthMappinController.UpdateStatusEffectIcon()` to fix status effect icon rendering. When a status effect is showing, it resolves the icon from TweakDB's `UIIcon` records and applies the correct atlas texture part and resource. If the icon record is not found, it falls back to a default buff info atlas.

# Member Types

| Type | Kind | Source File | Key Members |
|------|------|------------|-------------|
| StealthMappinController (wrapped) | `@wrapMethod` patch | scripts/StatusEffect.reds | `UpdateStatusEffectIcon()` |

# Patched Method

### StealthMappinController.UpdateStatusEffectIcon

```reds
@wrapMethod(StealthMappinController)
private final func UpdateStatusEffectIcon() {
    wrappedMethod();
    if this.m_statusEffectShowing {
        let iconRecord = TweakDBInterface.GetUIIconRecord(
            TDBID.Create("UIIcon." + this.m_mappin.GetStatusEffectIconPath())
        );
        if IsDefined(iconRecord) {
            inkImageRef.SetTexturePart(this.m_statusEffectIcon, iconRecord.AtlasPartName());
            inkImageRef.SetAtlasResource(this.m_statusEffectIcon, iconRecord.AtlasResourcePath());
        } else {
            inkImageRef.SetAtlasResource(
                this.m_statusEffectIcon,
                r"base/gameplay/gui/widgets/healthbar/atlas_buffinfo.inkatlas"
            );
        }
    }
}
```

# Behavior

1. Calls the original `wrappedMethod()` first
2. Checks if a status effect is currently showing (`m_statusEffectShowing`)
3. Constructs a TweakDBID for the UIIcon record from the status effect's icon path
4. Resolves the icon record via `TweakDBInterface.GetUIIconRecord`
5. If found: sets the texture part and atlas resource from the record
6. If not found: falls back to `base/gameplay/gui/widgets/healthbar/atlas_buffinfo.inkatlas`

# Dependencies

- Uses [TweakDBInterface](/apis/tweakdb-api.md) extensions to resolve UIIcon records
- `inkImageRef` — ink UI framework for image manipulation

# Citations

- [StatusEffect.reds](https://github.com/psiberx/cp2077-tweak-xl/blob/main/scripts/StatusEffect.reds)
