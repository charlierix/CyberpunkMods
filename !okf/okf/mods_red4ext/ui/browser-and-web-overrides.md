---
type: Mechanic Pattern
title: Browser and Web Page Overrides
description: Wrapping BrowserGameController and WebPage to modify in-game browser behavior.
tags: [ui browser web internet]
timestamp: 2026-08-03T00:00:00Z
---

# Browser and Web Page Overrides

Wrapping BrowserGameController and WebPage to modify in-game browser behavior.

## Approach

Mods wrap `BrowserGameController` (26 @addMethod) and `WebPage` (15 @addMethod) to modify the in-game internet browser. This includes custom web pages, modified browser behavior, or integration of custom content into the in-game internet.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| 1st Night City Bank 29412 1.6 2026-06-29T12-18Z PYMIYqXtV | `r6/scripts/1stncbank/UI/Site.reds` | Wraps `BrowserGameController.OnInitialize` |
| BrowserExtensionFramework-10038-0-9-7-1758341320 | `r6/scripts/BrowserExtension/browserController.overrides.reds` | Adds `BrowserGameController.LoadPageByAddress` |
| Eviction Notice-23187-1-0-3-for-2-3-1755569719 | `r6/scripts/Eviction Notice/Utils/ENResourceUtils.reds` | Adds `WebPage.ENGetDepositAmountForPage` |
| Much Better Eddies 30532 1.3 2026-07-12T02-46Z LACBAIygB | `r6/scripts/BetterEddies/DeadChannel/DeadChannelSite.reds` | Wraps `BrowserGameController.OnInitialize` |
| NSGNowPlaying 27764 2.6.0 2026-06-28T15-38Z xNHtNXe1G | `r6/scripts/NSGNowPlaying/SetupNewSite.reds` | Wraps `BrowserGameController.OnInitialize` |

## Related Concepts

- [Ink Widget Extensions](/ui/ink-widget-extensions.md) — Using @addMethod on inkGameController and inkWidget to extend UI widget functionality.
- [Device Interaction Extensions](/world/device-interaction-extensions.md) — Extending ScriptableDeviceComponentPS and InteractiveDevice to modify device interaction behavior.
