---
type: "Addon"
title: "Ink Addons"
description: "Field additions to ink types via @addField (71 types)."
resource: "codeware/scripts/"
tags: "[addons, ink]"
timestamp: 2026-07-01T18:09:40Z
---

# Overview

Field additions to ink types via @addField (71 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| inkAnimAnchor | addon | — | startValue, endValue |
| inkAnimColor | addon | — | startValue, endValue |
| inkAnimDef | addon | — | interpolators, events |
| inkAnimEffect | addon | — | startValue, endValue, effectType, effectName, paramName |
| inkAnimEvent | addon | — | startTime |
| inkAnimInterpolator | addon | — | interpolationMode, interpolationType, interpolationDirection, duration, startDelay |
| inkAnimMargin | addon | — | startValue, endValue |
| inkAnimPadding | addon | — | startValue, endValue |
| inkAnimPivot | addon | — | startValue, endValue |
| inkAnimRotation | addon | — | startValue, endValue, goShortPath |
| inkAnimScale | addon | — | startValue, endValue |
| inkAnimSequence | addon | — | name, definitions, targets |
| inkAnimSetVisibilityEvent | addon | — | isVisible |
| inkAnimShear | addon | — | startValue, endValue |
| inkAnimSize | addon | — | startValue, endValue |
| inkAnimTextInterpolator | addon | — | startValue, endValue |
| inkAnimTranslation | addon | — | startValue, endValue |
| inkAnimTransparency | addon | — | startValue, endValue |
| inkBorder | addon | — | thickness |
| inkButtonController | addon | — | ButtonClick, ButtonHoldComplete, ButtonStateChanged, ButtonSelectionChanged, ButtonHoldProgressChanged |
| inkCacheWidget | addon | — | innerScale, mode, externalDynamicTexture |
| inkCharacterCreationPuppetPreviewGameController | addon | — | maleSceneName, femaleSceneName, maleCamera01Ref, femaleCamera01Ref, root |
| inkCircle | addon | — | segmentsNumber |
| inkComboBoxController | addon | — | comboBoxObjectRef, ComboBoxVisibleChanged |
| inkComboBoxObjectController | addon | — | contentWidgetRef, placeholderOffsetWidgetRef, colliderRef, offset |
| inkCompoundWidget | addon | — | childOrder, children, childMargin |
| inkEntityPreviewCameraSettings | addon | — | autoEnable, renderingMode |
| inkEntityPreviewGameController | addon | — | entityToPreview |
| inkGameNotificationData | addon | — | introAnimation |
| inkGenderSelectionPuppetPreviewGameController | addon | — | sceneName, cameraRef |
| inkGenericSystemNotificationLogicController | addon | — | titleTextWidget, descriptionTextWidget, additionalDataTextWidget, introAnimationName, outroAnimationName |
| inkGridController | addon | — | height, width, items, slotSize, itemTemplates |
| inkHoldControllerActionData | addon | — | actionName |
| inkIGameController | addon | — | audioMetadataName |
| inkILogicController | addon | — | audioMetadataName |
| inkISystemRequestsHandler | addon | — | SavesForSaveReady, SavesForLoadReady, SaveMetadataReady, GogLoginStatusChanged, SaveDeleted |
| inkImage | addon | — | useExternalDynamicTexture, externalDynamicTexture, useNineSliceScale, nineSliceScale, mirrorType |
| inkInputDisplayController | addon | — | iconRef, iconAND, nameRef, canvasRef, holdIndicatorContainerRef |
| inkInventoryPuppetPreviewGameController | addon | — | sceneName, cameraRef |
| inkItemPreviewGameController | addon | — | root, image, sceneName, cameraRef |
| inkLanguageOverrideProvider | addon | — | languageId |
| inkLinePattern | addon | — | vertexList, spacing, looseSpacing, startOffset, endOffset |
| inkMask | addon | — | textureAtlas, texturePart, dynamicTextureMask, dataSource, invertMask |
| inkPreviewGameController | addon | — | yawSpeed, yawDefault |
| inkPuppetPreviewGameController | addon | — | cameraController |
| inkRadioGroupController | addon | — | toggleRefs, alwaysToggled, selectedIndex, ValueChanged |
| inkScrollArea | addon | — | horizontalScrolling, verticalScrolling, constrainContentPosition, fitToContentDirection, useInternalMask |
| inkScrollController | addon | — | ScrollArea, VerticalScrollBarRef, navigableCompoundWidget, CompoundWidgetRef, autoHideVertical |
| inkShape | addon | — | shapeResource, shapeName, shapeVariant, keepInBounds, nineSliceScale |
| inkSliderController | addon | — | slidingAreaRef, handleRef, nextRef, priorRef, direction |
| inkStepperController | addon | — | Change |
| inkText | addon | — | localizationString, textIdKey, text, fontFamily, fontStyle |
| inkTextAnimationController | addon | — | playOnInitialize, animationName, useDefaultAnimation, duration, startDelay |
| inkTextKiroshiAnimController | addon | — | timeToSkip, nativeText, preTranslatedTextWidget, postTranslatedTextWidget, nativeTextWidget |
| inkTextMotherTongueController | addon | — | preTranslatedTextWidget, postTranslatedTextWidget, nativeTextWidget, translatedTextWidget |
| inkTextOffsetController | addon | — | timeToSkip |
| inkTextReplaceController | addon | — | timeToSkip, widgetTextUsage, baseTextLocalized, targetText, targetTextLocalized |
| inkTextValueProgressController | addon | — | baseValue, targetValue, numbersAfterDot, stepValue, suffix |
| inkToggleController | addon | — | ToggleChanged, isToggled, autoToggleOnInput |
| inkUniformGrid | addon | — | wrappingWidgetCount, orientation |
| inkVideo | addon | — | videoResource, loop, overriddenPlayerName, isParallaxEnabled, prefetchVideo |
| inkVirtualCompoundController | addon | — | ItemSelected, ItemActivated, AllElementsSpawned |
| inkVirtualCompoundItemController | addon | — | ToggledOff, ToggledOn, Selected, Deselected, Added |
| inkVirtualListController | addon | — | itemTemplates, cycleNavigation |
| inkVirtualUniformListController | addon | — | itemTemplate |
| inkWidget | addon | — | logicController, secondaryControllers, userData, name, state |
| inkWidgetLayout | addon | — | sizeRule, sizeCoefficient |
| inkWidgetLibraryResource | addon | — | library |
| inkWidgetPath | addon | — | names |
| inkWidgetRef | addon | — | widget |
| inkWorldMapPreviewGameController | addon | — | viewTemplate, viewEnvironmentDefinition, cursorTemplate, canvas |

# Citations

- `codeware/scripts/Base/Addons/inkAnimAnchor.reds`
- `codeware/scripts/Base/Addons/inkAnimColor.reds`
- `codeware/scripts/Base/Addons/inkAnimDef.reds`
- `codeware/scripts/Base/Addons/inkAnimEffect.reds`
- `codeware/scripts/Base/Addons/inkAnimEvent.reds`
- `codeware/scripts/Base/Addons/inkAnimInterpolator.reds`
- `codeware/scripts/Base/Addons/inkAnimMargin.reds`
- `codeware/scripts/Base/Addons/inkAnimPadding.reds`
- `codeware/scripts/Base/Addons/inkAnimPivot.reds`
- `codeware/scripts/Base/Addons/inkAnimRotation.reds`
- ... and 61 more source files
