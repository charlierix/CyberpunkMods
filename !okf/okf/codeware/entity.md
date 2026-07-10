---
type: "API"
title: "Entity System"
description: "Entity management including game objects, components, and entity builders."
resource: "codeware/scripts/"
tags: "[entity]"
timestamp: 2026-07-01T18:08:59Z
---

# Overview

Entity management including game objects, components, and entity builders.

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| Entity | unknown | — | — |
| EntityBuilderWrapper | class | — | HasEntity, HasAppearance, HasCustomAppearances, GetRecordID, GetTemplatePath |
| EntityID | unknown | — | — |
| GameObject | unknown | — | — |
| IComponent | addon | — | appearanceName, appearancePath |
| IPlacedComponent | addon | — | worldTransform |
| MeshComponent | addon | — | meshResource |
| PersistentID | unknown | — | — |
| TagList | struct | — | tags |
| entVisualControllerComponent | class | IComponent | LoadAppearanceDependencies, meshProxy, appearanceDependency, cookedAppearanceData, forcedLodDistance |

# Citations

- `codeware/scripts/Entity/Entity.reds`
- `codeware/scripts/Entity/EntityBuilderWrapper.reds`
- `codeware/scripts/Entity/EntityID.reds`
- `codeware/scripts/Entity/GameObject.reds`
- `codeware/scripts/Entity/IComponent.reds`
- `codeware/scripts/Entity/IPlacedComponent.reds`
- `codeware/scripts/Entity/MeshComponent.reds`
- `codeware/scripts/Entity/PersistentID.reds`
- `codeware/scripts/Entity/TagList.reds`
- `codeware/scripts/Entity/entVisualControllerComponent.reds`
