\## Getting the controller without OnInitialize



There's no CET API to directly query an existing controller instance — `Observe` only catches \*\*future\*\* method calls. So after a CET reload, you can't retroactively grab something that already initialized.



But you can observe \*\*other methods that fire during gameplay\*\* as a fallback. From `CrosshairGameController\_NoWeapon`'s method list:



| Method | When it fires |

|--------|-------------|

| `OnPSMSceneTierChanged` | Player scene tier changes (combat/alert/calm) |

| `OnZoomLevel` | Aiming down sights / zoom changes |

| `OnState\_HipFire` / `OnState\_Aim` / `OnState\_Sprint` / `OnState\_Scanning` / `OnState\_Safe` | Crosshair state transitions |

| `OnPlayerAttach` / `OnPlayerDetach` | Player puppet attaches/detaches |



\### Minimal fix: add a fallback observe



Keep your existing `OnInitialize` observe, and add one fallback on a frequently-firing method:



```lua

function GrappleRender.CallFrom\_onInit()

&#x20;   Observe("CrosshairGameController\_NoWeapon", "OnInitialize", function(obj)

&#x20;       controller = obj

&#x20;   end)



&#x20;   -- Fallback: grabs controller after CET reload, on next state change

&#x20;   Observe("CrosshairGameController\_NoWeapon", "OnPSMSceneTierChanged", function(obj)

&#x20;       if not controller then

&#x20;           controller = obj

&#x20;       end

&#x20;   end)

end

```



`OnPSMSceneTierChanged` is a good pick — it fires fairly often during gameplay. The `if not controller` guard means once `OnInitialize` already populated it, the fallback never overwrites. After a CET reload, the next combat state change grabs the controller within seconds.



You could stack multiple fallbacks for even faster recovery:



```lua

local fallbackMethods = { "OnPSMSceneTierChanged", "OnZoomLevel", "OnState\_HipFire", "OnState\_Aim" }

for \_, method in ipairs(fallbackMethods) do

&#x20;   Observe("CrosshairGameController\_NoWeapon", method, function(obj)

&#x20;       if not controller then

&#x20;           controller = obj

&#x20;       end

&#x20;   end)

end

```



\## Is there a more core controller?



Not really — \*\*any\*\* `worlduiIWidgetGameController` subclass has `ProjectWorldToScreen`. The issue isn't \*which\* controller, it's that \*any\* controller's `OnInitialize` already fired before CET reload.



However, one improvement: observe the \*\*parent class\*\* `gameuiCrosshairBaseGameController` instead of `CrosshairGameController\_NoWeapon` specifically. This catches `OnInitialize` for \*\*any\*\* crosshair type (Basic, Launcher, Smart, Mantis Blade, etc.). After a CET reload, the next time the player \*\*switches weapons\*\*, a different crosshair controller initializes and you catch it:



```lua

Observe("gameuiCrosshairBaseGameController", "OnInitialize", function(obj)

&#x20;   controller = obj

end)

```



All 22 crosshair controller subclasses inherit `ProjectWorldToScreen` from the same `worlduiIWidgetGameController` base, so any of them works for your rendering. This gives you more opportunities to catch a controller without relying on the unarmed crosshair specifically.



\### Summary



| Approach | Catches CET reload? | Minimal change? |

|----------|---------------------|-----------------|

| Current: `NoWeapon:OnInitialize` only | No — already fired | — |

| Add fallback observe on `OnPSMSceneTierChanged` | Yes — next state change | One extra `Observe` call |

| Observe parent `gameuiCrosshairBaseGameController:OnInitialize` | Yes — next weapon switch | Change class name |

| Both combined | Yes — fastest recovery | A few lines |

